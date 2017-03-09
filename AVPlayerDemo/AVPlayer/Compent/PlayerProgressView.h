//
//  PlayerProgressView.h
//  TestDemo
//
//  Created by shuai pan on 2016/12/15.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerProgressView : UIView
//@property (nonatomic ,strong)UIProgressView *progView;

@property (nonatomic ,assign) CGFloat progressValue;
@property (nonatomic ,assign) CGFloat maxValue;
@property (nonatomic ,assign) CGFloat minValue;

@property (nonatomic ,copy)void(^(dragPlayerProgress))(CGFloat);
@property (nonatomic ,strong) UILabel *timeRateLabel;

@end
