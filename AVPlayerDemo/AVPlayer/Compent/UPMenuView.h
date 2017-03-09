//
//  UPMenuView.h
//  TestDemo
//
//  Created by shuai pan on 2016/12/20.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemButton;
@class PlayerProgressView;
@interface UPMenuView : UIView

@property (nonatomic ,assign)BOOL upMenuWaken;
@property (nonatomic ,strong)PlayerProgressView *progressView;
@property (nonatomic ,strong)ItemButton *playItem;
@property (nonatomic ,strong)ItemButton *fastForwardItem;

@end
