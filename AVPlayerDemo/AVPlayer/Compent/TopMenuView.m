//
//  TopMenuView.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/20.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "TopMenuView.h"
#import "ItemButton.h"

#import "AVVideoPlayer.h"
#import "UIDevice+DeviceOrientation.h"


@implementation TopMenuView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControls:frame];
    }
    return self;
}

- (void)setTopMenuWaken:(BOOL)topMenuWaken{
    _topMenuWaken = topMenuWaken;
    if (!_topMenuWaken) {
        self.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hidden = YES;
        });
    }else{
        self.hidden = YES;
    }
}
- (void)initializeControls:(CGRect)frame{
    
    [self addSubview:self.backItem];
    [self addSubview:self.titleLabel];
    [self addSubview:self.fullScreenItem];
    
    //是全屏显示
    [self.fullScreenItem addMenuClickActionMethod:^(BOOL isSelect) {
        if (isSelect) {
            [UIDevice setDeviceOrientation:UIInterfaceOrientationLandscapeRight];
        }else{
            [UIDevice setDeviceOrientation:UIInterfaceOrientationPortrait];
        }
    }];
    
    [self.backItem addMenuClickActionMethod:^(BOOL isSelect) {
        NSLog(@"返回");
        if (isSelect) {
            [[AVVideoPlayer shareVideoPlayer] videoPause];
        }else{
            [[AVVideoPlayer shareVideoPlayer] videoPlay];
        }
        
    }];
    
}
- (void)layoutSubviews{
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    
    self.backItem.frame = CGRectMake(10, h/2-15/2, 12, 15);
    
    CGFloat title_w = w - CGRectGetMaxX(self.backItem.frame)-10-35;
    self.titleLabel.frame  = CGRectMake(CGRectGetMaxX(self.backItem.frame)+10, 0, title_w,h);
    
    CGFloat fullScreenItem_x = CGRectGetMaxX(self.titleLabel.frame)+5;
    self.fullScreenItem.frame = CGRectMake(fullScreenItem_x, h/2-25/2, 25, 25);

}


- (ItemButton *)fullScreenItem{
    if (!_fullScreenItem) {
        _fullScreenItem  = [[ItemButton alloc]initWithFrame:CGRectZero backgroundImage:@"player_itemcontrol_fullScreen" selectImage:@"player_itemcontrol_exitfullScreen"];
    }
    return _fullScreenItem;
}
- (ItemButton *)backItem{
    if (!_backItem) {
        _backItem = [[ItemButton alloc]initWithFrame:CGRectZero backgroundImage:@"player_itemcontrol_back" selectImage:nil];
    }
    return _backItem;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment  =NSTextAlignmentLeft;
        _titleLabel.text = @"视频播放器";
    }
    return _titleLabel;
}
@end
