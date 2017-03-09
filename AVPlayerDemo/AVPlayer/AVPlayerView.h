//
//  MainPlayerView.h
//  TestDemo
//
//  Created by shuai pan on 2016/12/15.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "MainPlayView.h"

@interface AVPlayerView : MainPlayView


@property (nonatomic ,strong)NSString *videoTitle;
/**
 * 播放
 */
- (void)turnOnVideoPlayerUrlString:(NSString*)urlString;
@end
