//
//  CustomTabbarButton.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//
// 自定义标签栏按钮
#import "CustomTabbarButton.h"

@implementation CustomTabbarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.96 green:0.24 blue:0.56 alpha:1] forState:UIControlStateSelected];
    }
    return self;
}
//取消按钮的高亮状态
-(void)setHighlighted:(BOOL)highlighted
{
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(-4, 27, contentRect.size.width, 20);
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 29) /2, 5, 20, 20);
}




@end
