//
//  UserInfoView.h
//  妈妈问
//
//  Created by lixuan on 15/3/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//


// 首页个人中心lable  ---
#import <UIKit/UIKit.h>

@interface UserInfoView : UIView
@property (strong, nonatomic) UIImage *iconImg;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dayNumber;
@property (copy, nonatomic) NSString *descStr;

@end
