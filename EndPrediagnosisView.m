//
//  EndPrediagnosisView.m
//  妈妈问1
//
//  Created by lixuan on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "EndPrediagnosisView.h"

@implementation EndPrediagnosisView
{
    UILabel *_titleLable;
    UILabel *_problemLable;
    UILabel *_problemContentLable;
    UILabel *_suggestLable;
    UILabel *_suggestContentLable;
    
}
// 高 243
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat W = frame.size.width;
//        CGFloat H = frame.size.height;
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 30)];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = @"预诊报告";
        _titleLable.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLable];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLable.frame), W - 20, 1)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView1];
        
        _problemLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView1.frame) + 15, 60, 15)];
        _problemLable.text = @"疑似问题:";
        _problemLable.textColor = [UIColor blackColor];
        _problemLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:_problemLable];
        
        
        _problemContentLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_problemLable.frame)  +15, W - 40, 20)];
        _problemContentLable.font = [UIFont systemFontOfSize:16];
        _problemContentLable.textColor = [UIColor blackColor];
        _problemContentLable.numberOfLines = 0;
        _problemContentLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_problemContentLable];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_problemContentLable.frame) + 15, W - 20, 1)];
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView2];
        
        _suggestLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView2.frame) + 15, 60, 15)];
        _suggestLable.text = @"医生建议:";
        _suggestLable.font = [UIFont systemFontOfSize:12];
        _suggestLable.textColor = [UIColor blackColor];
        [self addSubview:_suggestLable];
        
        _suggestContentLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_suggestLable.frame) + 5, W - 40, 30)];
        _suggestContentLable.font = [UIFont systemFontOfSize:16];
        _suggestContentLable.textColor = [UIColor blackColor];
        _suggestContentLable.numberOfLines = 0;
        _suggestContentLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_suggestContentLable];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_suggestContentLable.frame) + 15, W - 20, 1)];
        lineView3.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView3];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, CGRectGetMaxY(lineView3.frame) + 10, W - 20, 30);
        [btn setTitle:@"去评分" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:0.18 green:1 blue:1 alpha:1];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:64];
        [self addSubview:btn];
    }
    return self;
}
- (void)btnClick {
    _getScore();
}
- (void)setSuggest:(NSString *)suggest {
    _problemContentLable.text = _problem;
    _suggestContentLable.text = suggest;
}
//- (CGFloat)getHeightFromString:(NSString *)str {

//}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
