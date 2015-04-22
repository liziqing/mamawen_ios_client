//
//  BackView.m
//  mammawenUser
//
//  Created by alex on 15/4/13.
//  Copyright (c) 2015年 alex. All rights reserved.
//

#import "BackView.h"
#import "Content.h"

@implementation BackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backImageView.image=[UIImage imageNamed:@"背景.jpg"];
    [self addSubview:backImageView];
    
}

@end
