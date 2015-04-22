//
//  DiscoverViewController.h
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController
@property (nonatomic, strong) UIImage *iconImg;
@property (nonatomic, copy)  NSString *name;
@property (nonatomic, copy)  NSString *phone;


@property (nonatomic, copy)  NSString *level;
@property (nonatomic,copy)   NSString *golds;
@property (nonatomic, copy)  NSString *balance;

@property (nonatomic, assign) BOOL isRegister;
@end
