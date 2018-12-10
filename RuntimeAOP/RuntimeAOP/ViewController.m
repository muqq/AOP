//
//  ViewController.m
//  RuntimeAOP
//
//  Created by QQ Shih on 2017/4/11.
//  Copyright © 2017年 QQ Shih. All rights reserved.
//

#import "ViewController.h"
#import "AOPManager.h"
#import "Test.h"
#import "Test2.h"
#import <Objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [AOPManager.sharedManager register:[Test class] selector:@selector(func) callback:^{
        NSLog(@"haha");
    }];
    
    [AOPManager.sharedManager register:[Test2 class] selector:@selector(yo) callback:^{
        NSLog(@"yo man");
    }];
    
    Test *test = [[Test alloc] init];
    [test func];
    
    Test2 *test2 = [[Test2 alloc] init];
    [test2 yo];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
