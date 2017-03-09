//
//  MainPlayView.h
//  TestDemo
//
//  Created by shuai pan on 2016/12/19.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSUInteger,TouchesMoveAdjustControl)  {
    TouchesMoveAdjustControlUnkown,
    TouchesMoveAdjustControlVolume,
    TouchesMoveAdjustControlBrightness,
    TouchesMoveAdjustControlRate
};
typedef NS_ENUM (NSUInteger,TouchesCurrentState)  {
    TouchesCurrentStateNorml,//结束，正常状态
    TouchesCurrentStateBegin,// 开始
    TouchesCurrentStateMoving// 正在移动
};
@interface MainPlayView : UIView
/**
 *  单击时/双击回调
 */
- (void)addTapGestureRecognizerEnents:(void(^)())tapGestureBlock;
/**
 *  触摸回调
 */
- (void)addTouchesEventsWithScreen:(void(^)(TouchesCurrentState state))touchesMoveControlBlock touchesEnd:(void(^)(TouchesMoveAdjustControl moveControl,CGFloat value))touchEndBlock;
@end
