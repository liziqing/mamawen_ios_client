//
//  CamberView.m
//  妈妈问
//
//  Created by kin on 15/4/15.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "CamberView.h"
#import "WheelButtonModel.h"
@implementation CamberView
{
    UIButton *_midButton;
    UIButton *_leftOne;
    UIButton *_leftTwo;
    UIButton *_rightOne;
    UIButton *_rightTwo;
    
    
    UILabel *_nameLable;
    UILabel *_hospLable;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self ==[super initWithFrame:frame]) {
        CGFloat r = iphone6? 5 : 2;
        CGFloat midH = frame.size.height / 2 - 10;
        CGFloat leftTwoH = midH * 3 / 4 - r * 2;
        CGFloat leftOneH = midH / 2 + 5 - r;
        _midButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _midButton.frame = CGRectMake(self.center.x - midH / 2, 3, midH, midH);
        _midButton.layer.cornerRadius = midH / 2;
        _midButton.layer.masksToBounds = YES;
        _midButton.tag = 210;
        [_midButton addTarget:self action:@selector(btnClick:) forControlEvents:64];
        [self addSubview:_midButton];
        
        _leftTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftTwo.frame = CGRectMake(self.center.x / 2 - leftTwoH / 2, _midButton.center.y - leftTwoH / 4, leftTwoH, leftTwoH);
        _leftTwo.layer.cornerRadius = leftTwoH / 2;
        _leftTwo.layer.masksToBounds = YES;
        _leftTwo.tag = 211;
        [_leftTwo addTarget:self action:@selector(btnClick:) forControlEvents:64];
        [self addSubview:_leftTwo];
        
        _rightTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightTwo.frame = CGRectMake(self.center.x  * 3 / 2 - leftTwoH / 2, CGRectGetMinY(_leftTwo.frame), leftTwoH, leftTwoH);
        _rightTwo.layer.cornerRadius = leftTwoH / 2;
        _rightTwo.layer.masksToBounds = YES;
        _rightTwo.tag = 212;
        [_rightTwo addTarget:self action:@selector(btnClick:) forControlEvents:64];
        [self addSubview:_rightTwo];
        
        _leftOne = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftOne.frame = CGRectMake(_leftTwo.center.x / 3 - leftOneH / 2 - 5, CGRectGetMaxY(_leftTwo.frame) - leftOneH / 2, leftOneH, leftOneH);
        _leftOne.layer.cornerRadius = leftOneH / 2;
        _leftOne.layer.masksToBounds = YES;
        _leftOne.tag = 213;
        [_leftOne addTarget:self action:@selector(btnClick:) forControlEvents:64];
        [self addSubview:_leftOne];
        
        _rightOne = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightOne.frame = CGRectMake(frame.size.width - CGRectGetMaxX(_leftOne.frame), CGRectGetMinY(_leftOne.frame), leftOneH, leftOneH);
        _rightOne.layer.cornerRadius = leftOneH / 2;
        _rightOne.layer.masksToBounds = YES;
        _rightOne.tag = 214;
        [_rightOne addTarget:self action:@selector(btnClick:) forControlEvents:64];
        [self addSubview:_rightOne];
        
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_midButton.frame), CGRectGetMaxY(_midButton.frame) + 15, midH, midH / 3)];
        _nameLable.textColor = [UIColor whiteColor];
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
        [self addSubview:_nameLable];
        
        _hospLable = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(_nameLable.frame) , frame.size.width - 120, midH / 3)];
        _hospLable.textAlignment = NSTextAlignmentCenter;
        _hospLable.textColor = [UIColor whiteColor];
        _hospLable.font = [UIFont systemFontOfSize:iphone6? 15 : 13];
        [self addSubview:_hospLable];
    }
    return self;
}
- (void)setModels:(NSArray *)models {
    if (models.count < 5) {
        return;
    }
    [_midButton setImage:[(WheelButtonModel *)models[0] icon] forState:UIControlStateNormal];
    [_leftOne setImage:[(WheelButtonModel *)models[1] icon] forState:UIControlStateNormal];
    [_leftTwo setImage:[(WheelButtonModel *)models[2] icon] forState:UIControlStateNormal];
    [_rightOne setImage:[(WheelButtonModel *)models[3] icon] forState:UIControlStateNormal];
    [_rightTwo setImage:[(WheelButtonModel *)models[4] icon] forState:UIControlStateNormal];

    _nameLable.text = [(WheelButtonModel *)models[0] name];
    _hospLable.text = [(WheelButtonModel *)models[0] hospital];
}
- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 210;
    if (_buttonClickInIndex) {
        _buttonClickInIndex(index);
    }
}
@end
