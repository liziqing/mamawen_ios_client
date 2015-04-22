//
//  CustomDropDownTextField.h
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//


// 自定义有下拉的textview
#import <UIKit/UIKit.h>

@interface CustomDropDownTextField : UITextField
@property (nonatomic, assign) BOOL isHiddenRightBtn;
@property (nonatomic, copy) void(^buttonClick)();
@end
