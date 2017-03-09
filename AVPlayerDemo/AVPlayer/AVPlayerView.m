//
//  MainPlayerView.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/15.
//  Copyright © 2016年 BSL. All rights reserved.
//
#import "NSString+ClockTime.h"
#import "AVPlayerView.h"
#import "UIDevice+DeviceOrientation.h"
#import "PlayButton.h"

#import "PlayerProgressView.h"

#import "AVVideoPlayer.h"
#import "HexColors.h"

#import "TopMenuView.h"
#import "UPMenuView.h"
#define BGMenuColor [UIColor hx_colorWithHexRGBAString:@"#000000" alpha:0.5]
#define weakObject(type) __weak typeof(type) weakSelf = type

@interface AVPlayerView(){
    CGRect objInitFrame;
}

@property (nonatomic ,strong)UIView *playerView;
@property (nonatomic ,strong)TopMenuView *topMenuView;
@property (nonatomic ,strong)UPMenuView *bottomView;
//@property (nonatomic ,strong)PlayerProgressView *progressView;
//@property (nonatomic ,strong)ItemButton *playerItem;
//@property (nonatomic ,strong)ItemButton *fastForwardItem;
@property (nonatomic ,strong)PlayButton *pasueItem;

@property (nonatomic ,strong)UIActivityIndicatorView *indicatorView;
@end


@implementation AVPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControls:frame];
        [self addVideoGestureRecognizer];
     }
    return self;
}
- (void)turnOnVideoPlayerUrlString:(NSString*)urlString{
    weakObject(self);

//    播放前
    [[AVVideoPlayer shareVideoPlayer] addPlayerLayer:self.playerView.layer viewoUrlString:urlString totalTime:^(CGFloat totalTime) {
        //设置播放进度最大值
        
        weakSelf.bottomView.progressView.maxValue = totalTime;
        weakSelf.topMenuView.topMenuWaken = NO;
        weakSelf.bottomView.upMenuWaken = NO;


    } ] ;
//   播放中
    [[AVVideoPlayer shareVideoPlayer] setLocateVideoPlayingTimeBlock:^(CGFloat palyTime,CGFloat totalTime) {
         int playSeconds = palyTime;
        int totalSeconds = totalTime;
        NSString *playTimeStr = [NSString getClockTimeWithSeconds:playSeconds];
        NSString *totalTimeStr = [NSString getClockTimeWithSeconds:totalSeconds];
//显示播放时间
        weakSelf.bottomView.progressView.timeRateLabel.text = [NSString stringWithFormat:@"%@/%@",playTimeStr,totalTimeStr];
//设置播放进度
        weakSelf.bottomView.progressView.progressValue = palyTime;
       }];
// 播放结束
    [[AVVideoPlayer shareVideoPlayer] setVideoPlayEndBlock:^{
        //重置播放按钮
        weakSelf.bottomView.playItem.itemSelect = YES;
    }];
//延迟回调
    [[AVVideoPlayer shareVideoPlayer] setVideoPlayDelayBlock:^(BOOL isDelay){
        if (isDelay) {
            [weakSelf.indicatorView startAnimating];
        }else{
            [weakSelf.indicatorView stopAnimating];
        }
    }];
//屏幕设置
    [[AVVideoPlayer shareVideoPlayer] setVideoDirectionChange:^(UIInterfaceOrientation orientation){
         switch (orientation) {
         case UIInterfaceOrientationPortraitUpsideDown:
         case UIInterfaceOrientationPortrait:{
             [UIApplication sharedApplication].statusBarHidden = NO;
              weakSelf.frame = objInitFrame;
         }
             break;
         case UIInterfaceOrientationLandscapeLeft:
         case UIInterfaceOrientationLandscapeRight:{
             [UIApplication sharedApplication].statusBarHidden = YES;
             weakSelf.frame = weakSelf.window.bounds;
         }
             break;
         case UIInterfaceOrientationUnknown:{
         }
             break;
         default:
             break;
        }
    }];
}
- (void)setVideoTitle:(NSString *)videoTitle{
    _videoTitle = videoTitle;
    if (_videoTitle) {
        self.topMenuView.titleLabel.text = _videoTitle;
    }
}


#pragma mark Private Method **********************************
- (void)addVideoGestureRecognizer{
    weakObject(self);
    [self addTapGestureRecognizerEnents:^() {
        weakSelf.topMenuView.topMenuWaken = NO;
        weakSelf.bottomView.upMenuWaken = NO;
    }];
    
    [self addTouchesEventsWithScreen:^(TouchesCurrentState state) {
        switch (state) {
            case TouchesCurrentStateNorml:
                
                break;
            case TouchesCurrentStateBegin:{
                [weakSelf.indicatorView startAnimating];
            }
                break;
            case TouchesCurrentStateMoving:
                
                break;
            default:
                break;
        }
    } touchesEnd:^(TouchesMoveAdjustControl moveControl, CGFloat value) {
        CGFloat totalSeconds = [[AVVideoPlayer shareVideoPlayer] videoTotalValue];
        CGFloat rate = [[AVVideoPlayer shareVideoPlayer] videoPlayRate]+value;
        [[AVVideoPlayer shareVideoPlayer] videoSeekToTimeWithSeconds:totalSeconds*rate];
        [weakSelf.indicatorView stopAnimating];
    }];
}
- (void)initializeControls:(CGRect)frame{
    objInitFrame = frame;
    [self addSubview:self.playerView];
    [self addSubview:self.topMenuView];
    [self addSubview:self.bottomView];
    [self.playerView addSubview:self.indicatorView];
    [self.playerView addSubview:self.pasueItem];
    self.pasueItem.hidden = YES;
    weakObject(self);
    [self.pasueItem addMenuClickActionMethod:^(BOOL isSelect) {
        if (isSelect) {
            [[AVVideoPlayer shareVideoPlayer] videoPause];
            weakSelf.bottomView.playItem.itemSelect = YES;
            
        }else{
            [[AVVideoPlayer shareVideoPlayer] videoPlay];
            weakSelf.bottomView.playItem.itemSelect = NO;
        }
    }];
    //视频暂停及播放
    [self.bottomView.playItem addMenuClickActionMethod:^(BOOL isSelect) {
        if (isSelect) {
            [[AVVideoPlayer shareVideoPlayer] videoPause];
            weakSelf.pasueItem.itemSelect = YES;
        }else{
            [[AVVideoPlayer shareVideoPlayer] videoPlay];
            weakSelf.pasueItem.itemSelect = NO;
        }
    }];
}

#pragma mark set frame ******************************
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    self.playerView.frame = self.bounds;
    self.topMenuView.frame = CGRectMake(0, 0, w, 30);
    self.bottomView.frame = CGRectMake(0, h-40, w, 40);
    [[AVVideoPlayer shareVideoPlayer] updateVideoPlayerFrame:self.playerView.layer.bounds];

    
    self.indicatorView.bounds = CGRectMake(0, 0, 50, 50);
    self.indicatorView.center = self.playerView.center;
    self.pasueItem.frame = self.indicatorView.frame;
    [self.playerView bringSubviewToFront:self.indicatorView];
    [self.playerView bringSubviewToFront:self.pasueItem];
}
#pragma mark UI Init ******************************

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc]initWithFrame:CGRectZero];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}
- (UIView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView  =[[TopMenuView alloc]initWithFrame:CGRectZero];
        _topMenuView.backgroundColor = BGMenuColor;
    }
    return _topMenuView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UPMenuView alloc]initWithFrame:CGRectZero];
        _bottomView.backgroundColor =  BGMenuColor;
    }
    return _bottomView;
}
- (PlayButton *)pasueItem{
    if (!_pasueItem) {
        _pasueItem = [[PlayButton alloc]initWithFrame:CGRectZero backgroundImage:@"player_screencontrol_play" selectImage:@"player_screencontrol_pause"];
    }
    return _pasueItem;
}
- (UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _indicatorView;
}
@end
