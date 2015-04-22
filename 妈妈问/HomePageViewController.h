//
//  HomePageViewController.h
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface HomePageViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray        *buttons;


// 个人信息
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *days;
@property (nonatomic, copy)   NSString *info;
@end
