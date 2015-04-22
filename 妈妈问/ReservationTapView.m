//
//  ReservationTapView.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//
// 首页 预诊tap
#import "ReservationTapView.h"

@implementation ReservationTapView

{
    UIImageView *_iconImgV;
    UILabel *_titleLable;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        [self createSubviewsWithFrame:frame];
    }
    return self;
}
- (void)createSubviewsWithFrame:(CGRect)frame {
    CGPoint center = CGPointMake(frame.size.width / 2, frame.size.height / 3);
    _iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  frame.size.width *2/ 5, frame.size.height / 2)];
    _iconImgV.center = center;
    [self addSubview:_iconImgV];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _iconImgV.frame.size.height / 3)];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.center = CGPointMake(center.x, center.y + _titleLable.frame.size.height + _iconImgV.frame.size.height / 2);
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont systemFontOfSize:18];
//    _titleLable.backgroundColor = [UIColor redColor];
    [self addSubview:_titleLable];
    
}

- (void)setTitleString:(NSString *)titleString {
    _titleLable.text = titleString;
}
- (void)setIconString:(NSString *)iconString {
    _iconImgV.image = [UIImage imageNamed:iconString];
}


@end
