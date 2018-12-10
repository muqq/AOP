//
//  AOPManager.m
//  RuntimeAOP
//
//  Created by QQ Shih on 2017/4/11.
//  Copyright © 2017年 QQ Shih. All rights reserved.
//

#import "AOPManager.h"
#import <Objc/runtime.h>
#import <Objc/message.h>

@interface AOPManager ()

@property (nonatomic) NSMutableDictionary *dict;
@property (nonatomic) id currentInstance;
@property (nonatomic) SEL fakeFunc;

@end

@implementation AOPManager

static NSString *kClassKey = @"class_key";
static NSString *kCallbackKey = @"callback_key";

+ (id)sharedManager {
    static AOPManager *aopManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aopManager = [[self alloc] init];
        aopManager.dict = [[NSMutableDictionary alloc] init];
        aopManager.fakeFunc = @selector(fakeFunc);
    });
    return aopManager;
}

- (void)register:(Class)class selector:(SEL)selector callback:(AOPCallback)callback {
    NSMethodSignature *methodSignature = [class instanceMethodSignatureForSelector:selector];
    if (methodSignature) {
        
        Method originMethod = class_getInstanceMethod(class, selector);
        IMP originIMP = class_getMethodImplementation(class, selector);
    
        
        method_setImplementation(originMethod, (IMP)_objc_msgForward);
        
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
        [infoDict setObject:class forKey:kClassKey];
        [infoDict setObject:[callback copy] forKey:kCallbackKey];
        
        
        [self.dict setObject:infoDict forKey: NSStringFromSelector(selector)];
        
    
        class_addMethod(class, @selector(forwardingTargetForSelector:), class_getMethodImplementation([self class], @selector(forwardingTargetForSelector:)), method_getTypeEncoding(class_getInstanceMethod(class, @selector(forwardingTargetForSelector:))));
        
        class_addMethod(class, self.fakeFunc, originIMP, method_getTypeEncoding(originMethod));
    }
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    AOPManager *aopManager = AOPManager.sharedManager;
    NSString *selectorName = NSStringFromSelector(aSelector);
    NSArray *keys = aopManager.dict.allKeys;
    for (NSString *key in keys) {
        if ([selectorName isEqualToString:key]) {
            if (self != aopManager) {
                aopManager.currentInstance = self;
            }
            return aopManager;
        }
    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSArray *keys = self.dict.allKeys;
    for (NSString *key in keys) {
        if ([NSStringFromSelector(aSelector) isEqualToString:key]) {
            return [[[self.dict objectForKey: NSStringFromSelector(aSelector)] objectForKey: kClassKey] instanceMethodSignatureForSelector:aSelector];
        }
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSMutableDictionary *infoDict = [self.dict objectForKey: NSStringFromSelector(anInvocation.selector)];
    AOPCallback callback = [infoDict objectForKey:kCallbackKey];
    
    [anInvocation setTarget:_currentInstance];
    [anInvocation setSelector:self.fakeFunc];
    [anInvocation invoke];
    callback();
}


@end
