//
//  SettingView.m
//  妈妈问
//
//  Created by kin on 15/4/17.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView
{
    UIImageView *_pic;
    UILabel     *_title;
    UILabel     *_subTitle;
    UIImageView *_arrow;

}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pic = [[UIImageView alloc] init];
        [self addSubview:_pic];
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:iphone6? 18:16];
        [self addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor whiteColor];
        _subTitle.font = [UIFont systemFontOfSize:iphone6? 14 :12];
        [self addSubview:_subTitle];
        
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 7 / 8, frame.size.height / 2 - 8, 10, 16)];
        _arrow.image = [UIImage imageNamed:@"11_10"];
        _arrow.hidden = YES;
        [self addSubview:_arrow];
    }
    return self;
}

- (void)setModel:(MySettingModel *)model {
    CGPoint startPt = CGPointZero;
    if (model.picPath) {
        _pic.frame = CGRectMake(30, self.frame.size.height / 2 - (self.frame.size.height - 25) / 2, self.frame.size.height - 25, self.frame.size.height - 25);
        _pic.image = [UIImage imageNamed:model.picPath];
        startPt = CGPointMake(CGRectGetMaxX(_pic.frame), 0);
    }
    _title.frame = CGRectMake(startPt.x + 30, self.frame.size.height / 2 - 10, self.frame.size.width / 3, 20);
    _title.text = model.title;
    
    if (model.subTitle) {
        _subTitle.frame = CGRectMake(CGRectGetMaxX(_title.frame), CGRectGetMinY(_title.frame), _title.frame.size.width / 2, 20);
        _subTitle.adjustsFontSizeToFitWidth = YES;
        _subTitle.text = model.subTitle;
    }
    
    if (model.shouldShowArrow) {
        _arrow.hidden = NO;
    }
}


@end
