//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by shuai pan on 2017/3/9.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerView.h"




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"MV-listen" ofType:@"mp4"];
    if(!urlString){
        urlString  = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    }
    NSArray *array = @[urlString,@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    
    AVPlayerView *player = [[AVPlayerView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.bounds), 200)];
    [self.view addSubview:player];
    player.videoTitle = @"MV-listen";
    
    [player turnOnVideoPlayerUrlString:array[arc4random()%2]];
    player.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
