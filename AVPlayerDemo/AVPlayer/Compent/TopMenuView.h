//
//  TopMenuView.h
//  TestDemo
//
//  Created by shuai pan on 2016/12/20.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ItemButton;
@interface TopMenuView : UIView

@property (nonatomic ,assign)BOOL topMenuWaken;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)ItemButton *fullScreenItem;
@property (nonatomic ,strong)ItemButton *backItem;

@end
