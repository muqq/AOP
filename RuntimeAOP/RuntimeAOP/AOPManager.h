//
//  AOPManager.h
//  RuntimeAOP
//
//  Created by QQ Shih on 2017/4/11.
//  Copyright © 2017年 QQ Shih. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Test.h"

typedef void (^AOPCallback)(void);

@interface AOPManager : NSObject

- (void)register:(Class)class selector:(SEL)selector callback:(AOPCallback)callback;

+ (id)sharedManager;

@end
