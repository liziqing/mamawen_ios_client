//
//  UserInfoView.m
//  妈妈问
//
//  Created by lixuan on 15/3/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//
// 首页 个人中心lable
#import "UserInfoView.h"
#import <QuartzCore/QuartzCore.h>
@implementation UserInfoView
{
    UIImageView *_iconImgV;
    UILabel *_nameLable;
    UILabel *_daysLable;
    UILabel *_descLable;

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, frame.size.height / 2, frame.size.height / 2)];
        _iconImgV.layer.cornerRadius = frame.size.height / 4;
        _iconImgV.layer.masksToBounds = YES;
        [self addSubview:_iconImgV];
        
        // 个人中心 lable
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_iconImgV.frame) + 10, _iconImgV.frame.size.width + 5, _iconImgV.frame.size.height / 3 + 3)];
        lable.text = @"个人中心";
        lable.font = iphone6? [UIFont systemFontOfSize:12] : [UIFont systemFontOfSize:9];
        
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.layer.borderColor = [UIColor blackColor].CGColor;
        lable.layer.borderWidth = 0.5;
        lable.layer.cornerRadius = 8;
        lable.layer.masksToBounds = YES;
        lable.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:lable];
        
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgV.frame) + 10, CGRectGetMinY(_iconImgV.frame) + 5, CGRectGetWidth(_iconImgV.frame) * 2, CGRectGetHeight(_iconImgV.frame) / 3)];
        _nameLable.font = [UIFont systemFontOfSize:iphone6? 20 : 18];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = [UIColor whiteColor];
        _nameLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_nameLable];
        
        _daysLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLable.frame), CGRectGetMinY(_nameLable.frame) + 5, CGRectGetWidth(_nameLable.frame), CGRectGetHeight(_nameLable.frame) - 5)];
        _daysLable.font = [UIFont systemFontOfSize:iphone6? 15 : 13];
        _daysLable.textColor = [UIColor whiteColor];
        _daysLable.textAlignment = NSTextAlignmentLeft;
        _daysLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_daysLable];
        
        
        _descLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLable.frame), CGRectGetMaxY(_nameLable.frame) + 15, kScreenWidth - CGRectGetMinX(_nameLable.frame) - 30, CGRectGetHeight(_iconImgV.frame) * 2 / 3)];
        _descLable.font = [UIFont systemFontOfSize:15];
        _descLable.textColor = [UIColor whiteColor];
        _descLable.numberOfLines = 2;
        _descLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_descLable];
    }
    return self;
}
- (void)setIconImg:(UIImage *)iconImg {
    _iconImgV.image = iconImg;
    _nameLable.text = _name;
    _daysLable.text = _dayNumber;
    _descLable.text = _descStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
