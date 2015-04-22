//
//  AppDelegate.h
//  妈妈问
//
//  Created by lixuan on 15/3/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTabbarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RootTabbarController *tabbarVC;

@property (nonatomic, assign) BOOL isOpenNewMessageNote; //是否开启新消息通知
@property (nonatomic, assign) BOOL isOpenNewMessageNoteDetail;// 通知显示消息详情
@property (nonatomic, assign) BOOL isOpenSound; // 开启提示音
@property (nonatomic, assign) BOOL isOpenVibrate; // 开启震动
@end

