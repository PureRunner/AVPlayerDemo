//
//  PlayerProgressView.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/15.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "PlayerProgressView.h"
#import "HexColors.h"
@interface PlayerProgressView(){
    
}
@property (nonatomic ,strong)UISlider *slider;

@end;
@implementation PlayerProgressView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControls];
    }
    return self;
}

#pragma mark API *************************************
-(void)setProgressValue:(CGFloat)progressValue{
    _progressValue  =progressValue;
    [_slider setValue:_progressValue animated:YES];
}
- (void)setMaxValue:(CGFloat)maxValue{
    _maxValue = maxValue;
    _slider.maximumValue = _maxValue;
}
- (void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
    _slider.minimumValue = _minValue;
}
- (void)sliderValueChanged:(UISlider *)slider{
    if (self.dragPlayerProgress) {
        self.dragPlayerProgress(slider.value);
    }
}
#pragma mark Private Method *****************************
- (void)initializeControls{
    
    [self addSubview:self.timeRateLabel];
    [self addSubview:self.slider];
    
}
- (void)layoutSubviews{
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    self.slider.bounds = CGRectMake(0.0f,0, w-120 ,h);
    self.slider.center = CGPointMake((w-100)/2, h/2);
    self.timeRateLabel.frame = CGRectMake(CGRectGetMaxX(self.slider.frame),0, 120, h);
}



#pragma mark UI set **************************************
- (UILabel *)timeRateLabel{
    if (!_timeRateLabel) {
        _timeRateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeRateLabel.font = [UIFont systemFontOfSize:12];
        _timeRateLabel.textColor = [UIColor lightGrayColor];
        _timeRateLabel.textAlignment = NSTextAlignmentCenter;
        _timeRateLabel.text = @"00:00:00/00:00:00";
    }
    return _timeRateLabel;
}
- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectZero];
        _slider.thumbTintColor = [UIColor hx_colorWithHexRGBAString:@"#4F4F4F" alpha:1];
        _slider.tintColor = [UIColor hx_colorWithHexRGBAString:@"#FFFFFF" alpha:1];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1.0;
        _slider.value = 0;
        [_slider setThumbImage:[self sliderThumbImage:[UIImage imageNamed:@"slider_thumb"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        [_slider setThumbImage:[self sliderThumbImage:[UIImage imageNamed:@"slider_thumb_highlighted"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
-(UIImage*)sliderThumbImage:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}
@end
