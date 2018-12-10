//
//  ViewController.m
//  runtimeTest
//
//  Created by QQ Shih on 2017/4/11.
//  Copyright © 2017年 QQ Shih. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"
#import <objc/runtime.h>
#import "Test2.h"

@interface ViewController ()

@end

@implementation ViewController

void test2IMP(id self, SEL _cmd) {
    NSLog(@"add function");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // add function
    Class metaClass = NSClassFromString(@"Test");
    class_addMethod(metaClass, @selector(test2), (IMP) test2IMP, "v@:");
    Test *test = [[Test alloc] init];
    [test performSelector:@selector(test2)];
    
    // change imp
    Method m1 = class_getInstanceMethod(metaClass, @selector(test));
    Method m2 = class_getInstanceMethod([self class], @selector(test2));
    method_exchangeImplementations(m1, m2);
    [test test];
    
    //test
    Method yo = class_getInstanceMethod([Test2 class], @selector(yo));
    class_addMethod(metaClass, @selector(yo), method_getImplementation(yo), method_getTypeEncoding(yo));
    [test performSelector:@selector(yo)];
}

- (void)test2 {
    NSLog(@"change");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
