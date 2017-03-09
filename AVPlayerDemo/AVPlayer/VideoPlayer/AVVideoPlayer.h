//
//  AVVideoPlayer.h
//  TestDemo
//
//  Created by shuai pan on 2016/12/15.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface AVVideoPlayer : NSObject

/**
 * 取得视频加载进度
 */
@property (nonatomic, copy)void (^videoLoadedTimeBlock)(CGFloat);

/**
 * 定位到当前播放时间(回调，刷新时间栏)
 */
@property (nonatomic, copy)void (^locateVideoPlayingTimeBlock)(CGFloat,CGFloat);

/**
 * 播放结束回调
 */
@property (nonatomic ,copy)void (^videoPlayEndBlock)();
/**
 * 播放延时
 */
@property (nonatomic ,copy)void (^videoPlayDelayBlock)(BOOL);

/**
 * 屏幕朝向
 */
@property (nonatomic ,copy)void (^videoDirectionChange)(UIInterfaceOrientation orientation);

+ (instancetype)shareVideoPlayer;

/**
 * 更新视频流视图frame
 */
- (void)updateVideoPlayerFrame:(CGRect)frame;
/**
 * 添加播放器
 */
- (void)addPlayerLayer:(CALayer*)layer viewoUrlString:(NSString *)urlString totalTime:(void (^)(CGFloat totalTime))videoTotalTimeBlock;
/**
 *  播放
 */
- (void)videoPlay;
/**
 *  暂停
 */
- (void)videoPause;
/**
 *  关闭播放器
 */
- (void)videoClose;
/**
 * 定位视频播放时间
 *
 */
- (void)videoSeekToTimeWithSeconds:(float)seconds;
- (CGFloat)videoTotalValue;
- (CGFloat)videoCurrentValue;
- (CGFloat)videoPlayRate;


@end
