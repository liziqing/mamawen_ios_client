//
//  PatientInfoView.m
//  妈妈问
//
//  Created by lixuan on 15/3/12.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "PatientInfoView.h"

@implementation PatientInfoView
{
    UIImageView *_selectedImgV;  // 显示是否选中
    UILabel     *_nameLable;
    UILabel     *_sexLable;
    UILabel     *_ageLable;
    UILabel     *_timeLable;
    UILabel     *_categoryLable;
    UILabel     *_editLable;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat H = frame.size.height / 3;
    if (self == [super initWithFrame:frame]) {
        _selectedImgV = [[UIImageView alloc] initWithFrame:CGRectMake(H, H, H, H)];
        _selectedImgV.layer.cornerRadius = H / 2;
        _selectedImgV.layer.masksToBounds = YES;
        _selectedImgV.layer.borderWidth = 1;
        _selectedImgV.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectedImgV.backgroundColor = [UIColor clearColor];
        [self addSubview:_selectedImgV];
        
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectedImgV.frame) + H /2, H, H / 2 + H * 4, H)];
        _nameLable.textColor = [UIColor whiteColor];
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
        [self addSubview:_nameLable];
        
//        _sexLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLable.frame) + H, H, H, H)];
//        _sexLable.textAlignment = NSTextAlignmentCenter;
//        _sexLable.font = [UIFont systemFontOfSize:13];
//        _sexLable.textColor = [UIColor whiteColor];
//        [self addSubview:_sexLable];
        
//        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sexLable.frame) + H / 2, H, H * 2, H)];
//        _timeLable.textColor = [UIColor whiteColor];
//        _timeLable.textAlignment = NSTextAlignmentCenter;
//        _timeLable.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_timeLable];
        
        
//        _categoryLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeLable.frame) + H / 2, H, H * 2, H)];
//        _categoryLable.textColor = [UIColor whiteColor];
//        _categoryLable.textAlignment = NSTextAlignmentCenter;
//        _categoryLable.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_categoryLable];
        
        _editLable = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - H * 3, H, H * 2, H)];
        _editLable.textColor = [UIColor whiteColor];
        _editLable.textAlignment = NSTextAlignmentCenter;
        _editLable.font = [UIFont systemFontOfSize:iphone6? 16 : 14];
        _editLable.text = @"编辑";
        [self addSubview:_editLable];
        
        CGFloat ww = CGRectGetHeight(_editLable.frame);
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_editLable.frame) - ww * 4 / 3, CGRectGetMinY(_editLable.frame), ww, ww)];
        imgv.image = [UIImage imageNamed:@"04_17"];
        [self addSubview:imgv];
    }
    return self;
}
- (void)setModel:(PatientInfoModel *)model {
    _nameLable.text = model.name;
//    _sexLable.text  = model.sex;
//    _ageLable.text  = model.age;
//    _timeLable.text = model.lastTime;
//    _categoryLable.text = model.category;
}
- (void)setSelected:(BOOL)select {
//    _selectedImgV.backgroundColor = select? [UIColor redColor]:[UIColor lightGrayColor];
    if (select) { // 可以用hidden属性   但是懒得改了 ^^
         CGFloat w = CGRectGetWidth(_selectedImgV.frame);
        UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w/2, w/2)];
        bv.backgroundColor = [UIColor whiteColor];
        bv.center  = CGPointMake(w/2, w/2);
        bv.layer.cornerRadius = w/4;
        bv.layer.masksToBounds = YES;
        [_selectedImgV addSubview:bv];
    } else{
        for (UIView *v in _selectedImgV.subviews) {
            [v removeFromSuperview];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch=(UITouch*)[[touches objectEnumerator] nextObject];
    CGPoint pt=[touch locationInView:self];
    
    if (pt.x > self.frame.size.width * 3 / 4) {
        if (_editCallBack) {
            _editCallBack();
        }
    }
    else {
        _isSlected = YES;
        [self setSelected:_isSlected];
        if (_selectedCB) {
            _selectedCB();
        }
    }
}
@end
