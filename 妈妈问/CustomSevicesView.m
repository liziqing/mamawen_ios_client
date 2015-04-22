//
//  CustomSevicesView.m
//  妈妈问
//
//  Created by lixuan on 15/3/10.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "CustomSevicesView.h"

@implementation CustomSevicesView
{
    UIImageView *_icon;
    UILabel     *_categoryLable;
    UILabel     *_priceLable;
    UILabel     *_describLable;
    UILabel     *_buyerNumLable;
    UILabel     *_evaluateLable;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat spacingW = 8 + 5;
        CGFloat W        = frame.size.height - spacingW * 2 ;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(spacingW * 3, spacingW , W, W)];
        _icon.layer.cornerRadius  = 5;
        _icon.layer.masksToBounds = YES;
        [self addSubview:_icon];
        
        CGFloat lableX = CGRectGetMaxX(_icon.frame) + 10;
        CGFloat lableH = W / 4;
        _categoryLable = [[UILabel alloc] initWithFrame:CGRectMake(lableX + 20, _icon.center.y - lableH / 2, W - 10, lableH)];
        _categoryLable.textColor = [UIColor whiteColor];
        _categoryLable.font = [UIFont systemFontOfSize:iphone6? 20 : 18];
        [self addSubview:_categoryLable];
        
        
        _priceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_categoryLable.frame) + 15, CGRectGetMinY(_categoryLable.frame), W / 2 + W, lableH)];
        _priceLable.textColor = [UIColor whiteColor];
        _priceLable.font = [UIFont systemFontOfSize:16];
        [self addSubview:_priceLable];
        
//        _describLable = [[UILabel alloc] initWithFrame:CGRectMake(lableX, CGRectGetMaxY(_categoryLable.frame) + lableH / 2, frame.size.width * 2 / 3, lableH)];
//        _describLable.font = [UIFont systemFontOfSize:13];
//        _describLable.textColor = [UIColor whiteColor];
//        [self addSubview:_describLable];
//        
//        _buyerNumLable = [[UILabel alloc] initWithFrame:CGRectMake(lableX, CGRectGetMaxY(_describLable.frame) + lableH / 2, CGRectGetWidth(_describLable.frame), lableH)];
//        _buyerNumLable.font = [UIFont systemFontOfSize:13];
//        _buyerNumLable.textColor = [UIColor whiteColor];
//        [self addSubview:_buyerNumLable];
        
#warning 评价星数
//        _evaluateLable = 
    }
    return self;
}
- (void)setModel:(SevicesModel *)model {
    _icon.image = [UIImage imageNamed: model.icon ];
    _icon.backgroundColor = [UIColor lightGrayColor];
    _categoryLable.text = model.category;
    _priceLable.text = [NSString stringWithFormat:@"¥%@元/周",model.price];
//    _describLable.text = model.descryption;
//    _buyerNumLable.text = [NSString stringWithFormat:@"%@人购买，用户评价：%@星",model.buyerNum,model.evaluate];
}
@end
