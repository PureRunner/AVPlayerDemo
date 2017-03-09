//
//  UIDevice+DeviceOrientation.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/16.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "UIDevice+DeviceOrientation.h"

@implementation UIDevice (DeviceOrientation)
//调用私有方法实现

+ (void)setDeviceOrientation:(UIInterfaceOrientation)orientation {
    
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[self currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}
@end
