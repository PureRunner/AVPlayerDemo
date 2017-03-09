//
//  NSString+ClockTime.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/16.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "NSString+ClockTime.h"

@implementation NSString (ClockTime)

+ (NSString *)getClockTimeWithSeconds:(int)timeCount{
    int seconds = timeCount%60;
    int minutes = (timeCount/60) % 60;
    int hours = timeCount/3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
@end
