//
//  CustomDropDownTextField.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//
// 自定义有下拉的textview
#import "CustomDropDownTextField.h"

@implementation CustomDropDownTextField
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = NO;
//        self.borderStyle = UITextBorderStyleRoundedRect;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"xiaIcon"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        CGFloat r = iphone6? 20 : 10;
        btn.imageEdgeInsets = UIEdgeInsetsMake(r, r, r, r);
        CGFloat w = iphone6? 25 : 15;
        btn.center = CGPointMake(frame.size.width - w, frame.size.height / 2);
        [btn addTarget:self action:@selector(btnClick) forControlEvents:64];
        btn.tintColor = [UIColor blueColor];
        self.rightView = btn;
        self.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}
- (void)btnClick {
 if (_buttonClick)   _buttonClick();

}
- (void)setIsHiddenRightBtn:(BOOL)isHiddenRightBtn {
    if (isHiddenRightBtn) {
        self.rightViewMode = UITextFieldViewModeNever;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
