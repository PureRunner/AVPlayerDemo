//
//  PlayButton.m
//  TestDemo
//
//  Created by shuai pan on 2016/12/20.
//  Copyright © 2016年 BSL. All rights reserved.
//

#import "PlayButton.h"
#import "HexColors.h"


#define BGColor [UIColor hx_colorWithHexRGBAString:@"#000000" alpha:0.6]
@implementation PlayButton

- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString*)bgImage selectImage:(NSString*)slImage{
    self = [super initWithFrame:frame backgroundImage:bgImage selectImage:slImage];
    if (self) {
        self.backgroundColor = BGColor;
        
    }
    return self;
}
- (void)layoutSubviews{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
}
- (void)setItemSelect:(BOOL)itemSelect{
    [super setItemSelect:itemSelect];
    if (!itemSelect) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hidden = YES;
        });
    }
    else{
        self.hidden = NO;

    }
}

@end
