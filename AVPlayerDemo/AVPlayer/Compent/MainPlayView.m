//
//  MainPlayView.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/19.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "MainPlayView.h"


@interface MainPlayView (){
}
@property (nonatomic ,strong)UIView *volumeView;
@property (nonatomic ,strong)UIView *brightnesView;
@property (nonatomic ,strong)UIView *rateView;

@property (nonatomic ,copy)void ((^ tapGestureBlock)()) ;
@property (nonatomic ,copy)void ((^ touchesMoveAdjustControlBlock)(TouchesCurrentState));
@property (nonatomic ,copy)void ((^ touchesEndBlock)(TouchesMoveAdjustControl,CGFloat));

@property (nonatomic ,assign)TouchesMoveAdjustControl moveControl;
@property (nonatomic ,assign)TouchesCurrentState touchesState;

@property (nonatomic, assign) BOOL touchOff;// 触发Tap

@property (nonatomic, assign) CGFloat ratioValue;//触摸速率
@property (nonatomic, assign) CGPoint startPoint;//触摸起始位置

@end
@implementation MainPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.volumeView];
        [self addSubview:self.rateView];
        [self addSubview:self.brightnesView];
    }
    return self;
}

- (void)addTapGestureRecognizerEnents:(void(^)())tapGestureBlock{
    UITapGestureRecognizer *singleGap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvents:)];
    singleGap.numberOfTapsRequired = 1;
    singleGap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleGap];
    self.tapGestureBlock = tapGestureBlock;
}
- (void)addTouchesEventsWithScreen:(void(^)(TouchesCurrentState state))touchesMoveControlBlock touchesEnd:(void(^)(TouchesMoveAdjustControl moveControl,CGFloat value))touchEndBlock{
    self.moveControl = TouchesMoveAdjustControlUnkown;
    self.touchesMoveAdjustControlBlock = touchesMoveControlBlock;
    self.touchesEndBlock = touchEndBlock;
}





- (void)layoutSubviews{
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    self.volumeView.frame = CGRectMake(0, 40, w/4, h-80);
    self.rateView.frame = CGRectMake(CGRectGetMaxX(self.volumeView.frame), 40, w/2, h-80);
    self.brightnesView.frame = CGRectMake(w-w/4, 40, w/4, h-80);

}

- (void)tapGestureEvents:(UITapGestureRecognizer*)tap{
    self.touchOff = !self.touchOff;
    if (self.tapGestureBlock) {
        self.tapGestureBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];

    CGPoint pt = [self.volumeView convertPoint:point fromView:self];
    CGPoint pt1 = [self.rateView convertPoint:point fromView:self];
    CGPoint pt2 = [self.brightnesView convertPoint:point fromView:self];
    if ([self.volumeView pointInside:pt withEvent:event]) {
        self.moveControl = TouchesMoveAdjustControlVolume;
    }
    else if ([self.rateView pointInside:pt1 withEvent:event]){
        self.moveControl = TouchesMoveAdjustControlRate;
    }
    else if ([self.brightnesView pointInside:pt2 withEvent:event]){
        self.moveControl = TouchesMoveAdjustControlBrightness;
    }
    else{
        self.moveControl = TouchesMoveAdjustControlUnkown;
    }
    //记录开始触摸点
    self.startPoint = point;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self];

    CGFloat move_w = movePoint.x-self.startPoint.x;
    CGFloat move_h = movePoint.y-self.startPoint.y;
    CGFloat move_max = 0.0 ;
        switch (self.moveControl) {
        case TouchesMoveAdjustControlVolume:{
            if (movePoint.x>CGRectGetMaxY(self.volumeView.frame))return;
            if (fabs(move_h) >fabs(move_w)) {
                if (fabs(move_h)>3) {
                    move_max = move_h;
                    self.ratioValue = move_max/CGRectGetWidth(self.volumeView.bounds)/10;
                }
            }
        }
            break;
        case TouchesMoveAdjustControlRate:{
            if (fabs(move_w) >fabs(move_h)) {
                if (movePoint.x>CGRectGetMaxX(self.rateView.frame))return;
                if (fabs(move_w)>3) {
                    move_max = move_w;
                    self.ratioValue = move_max/CGRectGetWidth(self.rateView.bounds)/10;
                }
            }
        }
            break;
        case TouchesMoveAdjustControlBrightness:{
            if (fabs(move_h) >fabs(move_w)) {
                if (movePoint.x>CGRectGetMaxY(self.brightnesView.frame))return;
                if (fabs(move_h)>3) {
                    move_max = move_h;
                    self.ratioValue = move_max/CGRectGetWidth(self.brightnesView.bounds)/10;
                }
             }
        }
            break;
        default:
            break;
    }
    if(move_max<2.0) return;
    if (move_max<3.0&&move_max>=2.0) {
        self.touchesState = TouchesCurrentStateBegin;
    }else{
        self.touchesState = TouchesCurrentStateMoving;
    }
    if (self.touchesMoveAdjustControlBlock) {
        self.touchesMoveAdjustControlBlock(self.touchesState);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.touchesEndBlock) {
        self.touchesEndBlock(self.moveControl,self.ratioValue);
    }
    self.touchesState = TouchesCurrentStateNorml;
    self.moveControl = TouchesMoveAdjustControlUnkown;
}





- (UIView *)volumeView{
    if(!_volumeView){
        _volumeView = [[UIView alloc]initWithFrame:CGRectZero];
        _volumeView.backgroundColor = [UIColor redColor];
    }
    return _volumeView;
}
- (UIView *)brightnesView{
    if (!_brightnesView) {
        _brightnesView = [[UIView alloc]initWithFrame:CGRectZero];
        _brightnesView.backgroundColor = [UIColor orangeColor];

    }
    return _brightnesView;
}
- (UIView *)rateView{
    if (!_rateView) {
        _rateView = [[UIView alloc]initWithFrame:CGRectZero];
        _rateView.backgroundColor = [UIColor greenColor];

    }
    return _rateView;
}








@end
