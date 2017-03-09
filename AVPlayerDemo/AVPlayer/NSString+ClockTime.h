//
//  NSString+ClockTime.h
//  TestDemo
//
//  Created by shuai pan on 2016/12/16.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ClockTime)
+ (NSString *)getClockTimeWithSeconds:(int)timeCount;
@end
