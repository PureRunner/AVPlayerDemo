//
//  UPMenuView.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/20.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "UPMenuView.h"
#import "PlayerProgressView.h"
#import "ItemButton.h"

#import "AVVideoPlayer.h"

@implementation UPMenuView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControls:frame];
    }
    return self;
}
- (void)setUpMenuWaken:(BOOL)upMenuWaken{
    _upMenuWaken = upMenuWaken;
    if (!_upMenuWaken) {
        self.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hidden = YES;
        });
    }else{
        self.hidden = YES;
    }
}
- (void)initializeControls:(CGRect)frame{
    
    [self addSubview:self.playItem];
    [self addSubview:self.fastForwardItem];
    [self addSubview:self.progressView];
    //拖放进度回调，快进
    [self.progressView setDragPlayerProgress:^(CGFloat value) {
        [[AVVideoPlayer shareVideoPlayer] videoSeekToTimeWithSeconds:value];
    }];
    

}
- (void)layoutSubviews{
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    
    self.playItem.frame  = CGRectMake(5, h/2-35/2, 35, 35);
    self.fastForwardItem.frame  = CGRectMake(CGRectGetMaxX(self.playItem.frame), h/2-15/2, 20, 15);
    
    CGFloat freeLength = w - CGRectGetMaxX(self.fastForwardItem.frame);
    self.progressView.frame = CGRectMake(CGRectGetMaxX(self.fastForwardItem.frame)+5,0, freeLength-5-10, h);
}


- (ItemButton *)playItem{
    if (!_playItem) {
        _playItem = [[ItemButton alloc]initWithFrame:CGRectZero backgroundImage:@"player_itemcontrol_play" selectImage:@"player_itemcontrol_pause"];
    }
    return _playItem;
}
- (ItemButton *)fastForwardItem{
    if (!_fastForwardItem) {
        _fastForwardItem = [[ItemButton alloc]initWithFrame:CGRectZero backgroundImage:@"player_itemcontrol_forward" selectImage:nil];
    }
    return _fastForwardItem;
}
- (PlayerProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[PlayerProgressView alloc]initWithFrame:CGRectZero];
    }
    return _progressView;
}

@end
