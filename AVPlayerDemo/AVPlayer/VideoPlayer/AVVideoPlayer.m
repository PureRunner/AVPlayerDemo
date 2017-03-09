//
//  AVVideoPlayer.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/15.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "AVVideoPlayer.h"
#define weakObject(type)  __weak typeof(type)weak##type = type


@interface AVVideoPlayer(){
    BOOL playSucces;
}
/**
 * 当前播放视频总时长
 */
@property (nonatomic, copy)void (^totalTimeBlock)(CGFloat);

@property(nonatomic,strong) AVPlayerLayer *videoLayer;

@property (nonatomic, strong) CADisplayLink *playlink;
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVURLAsset *videoURLAsset;

@property (nonatomic, strong) id playbackTimeObserver;//界面更新时间ID
@property (nonatomic, strong) CADisplayLink *link;//以屏幕刷新率进行定时操作
@property (nonatomic, assign) NSTimeInterval lastTime;
@end
@implementation AVVideoPlayer
- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deciveOrientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];//注册监听，屏幕方向改变
    }
    return self;
}
+ (instancetype)shareVideoPlayer{
    static AVVideoPlayer *obj ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[AVVideoPlayer alloc]init];
    });
    return obj;
}

- (void)addPlayerLayer:(CALayer*)layer viewoUrlString:(NSString *)urlString totalTime:(void (^)(CGFloat totalTime))videoTotalTimeBlock{
    //限制锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    if (self.videoPlayer) {
        self.videoPlayer = nil;
        [self videoRemoveObserver];
    }
    NSURL *url = [NSURL fileURLWithPath:urlString];
    if ([urlString hasPrefix:@"http"]) {
        url = [NSURL URLWithString:urlString];
    }
    self.videoURLAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    if (self.videoPlayer.currentItem) {
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
    }else{
        self.videoPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    [layer addSublayer:self.videoLayer ];
    [self videoPlay];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性变化
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监听loadedTimeRanges属性变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];//注册监听，视屏播放完成
    self.totalTimeBlock = videoTotalTimeBlock;
}
- (void)updateVideoPlayerFrame:(CGRect)frame{
    self.videoLayer.frame = frame;
}


- (void)videoPlay{
    [self.videoPlayer play];
    if (!self.link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(videoPlayUpadte)];//和屏幕频率刷新相同的定时器
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}
- (void)videoPause{
    if (self.link) {
        [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.link = nil;
    }
    [self.videoPlayer pause];
}
- (void)videoClose{
    [self.videoPlayer pause];
    //开启锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self videoRemoveObserver];
    [self.videoPlayer setRate:0];
    [self.videoPlayer replaceCurrentItemWithPlayerItem:nil];
    self.playerItem = nil;
    self.videoPlayer = nil;
}
- (void)videoSeekToTimeWithSeconds:(float)seconds{
    [self.videoPlayer seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC)];
}

- (CGFloat)videoTotalValue{
    return CMTimeGetSeconds(self.playerItem.duration);
}
- (CGFloat)videoCurrentValue{
    return CMTimeGetSeconds(self.playerItem.currentTime);
}
- (CGFloat)videoPlayRate{
    return [self videoCurrentValue]/[self videoTotalValue];
}



#pragma mark Private Method **********************************
- (void)videoRemoveObserver{
    if (self.link) {
        [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.link = nil;
    }
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.videoPlayer removeTimeObserver:self.playbackTimeObserver];
    self.playbackTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deciveOrientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];//注册监听，屏幕方向改变
}

//播放结束回调
- (void)videoDidPlayToEndTime:(NSNotificationCenter *)not{
    NSLog(@"播放结束");
    //使视频在播放结束的时候跳转到初始画面。
    weakObject(self);
    [self.videoPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        if (weakself.videoPlayEndBlock) {
            weakself.videoPlayEndBlock();
        }
    }];
}
//状态监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"播放成功");
            playSucces = YES;
            CMTime duration = self.playerItem.duration;//获取视屏总长
            CGFloat totalTime = CMTimeGetSeconds(duration);//转换成秒
            if (self.totalTimeBlock) {
                self.totalTimeBlock(totalTime);
            }
            //监听播放状态
            [self monitoringPlayerStatus];
            
        }else if (playerItem.status == AVPlayerItemStatusUnknown){
            NSLog(@"播放未知");
            playSucces = NO;
        }else if (playerItem.status == AVPlayerStatusFailed){
            NSLog(@"播放失败");
            playSucces = NO;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSTimeInterval timeInterval = [self videoPlayerCacheDuration];
        CGFloat totalDuration = CMTimeGetSeconds(self.playerItem.duration);
        if (self.videoLoadedTimeBlock) {
            self.videoLoadedTimeBlock(timeInterval/totalDuration);
        }
    }
}

//屏幕方向改变时的监听
- (void)deciveOrientChange:(NSNotification *)notification{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (self.videoDirectionChange) {
        self.videoDirectionChange(orientation);
    }
}
//实时监听播放状态
- (void)monitoringPlayerStatus{
    //一秒监听一次CMTimeMake(a, b),a/b表示多少秒一次；
    weakObject(self);
    self.playbackTimeObserver = [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        //获取当前时间
        CGFloat currentSeconds = CMTimeGetSeconds(weakself.playerItem.currentTime);
        CGFloat totalTime = CMTimeGetSeconds(weakself.playerItem.duration);

        if (weakself.locateVideoPlayingTimeBlock) {
            weakself.locateVideoPlayingTimeBlock(currentSeconds,totalTime);
        }
    }];
}
//计算缓冲区
- (NSTimeInterval)videoPlayerCacheDuration{
    NSArray *loadedTimeRanges = [[self.videoPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds+durationSeconds;//计算缓冲进度
    return result;
}
//延时操作
- (void)videoPlayUpadte{
    NSTimeInterval current = CMTimeGetSeconds(self.videoPlayer.currentTime);
    if (current ==self.lastTime) {
        //卡顿
        if (self.videoPlayDelayBlock) {
            self.videoPlayDelayBlock(YES);
        }
    }else{//没有卡顿
        if (self.videoPlayDelayBlock) {
            self.videoPlayDelayBlock(NO);
        }
    }
    self.lastTime = current;
}
- (AVPlayerLayer*)videoLayer{
    if (!_videoLayer) {
        _videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        _videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _videoLayer;
}
@end
