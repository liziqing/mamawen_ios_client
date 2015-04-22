//
//  BaseViewController.h
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController



- (void)setRightNavigationItemWithTitle:(NSString *)rightTitle isImage:(BOOL)isImage;
- (void)setLeftNavigationItemWithTitle:(NSString *)leftTitle isImage:(BOOL)isImage;
- (void)rightBarButtonItemclick;
- (void)leftBarButtonItemClick;

- (void)hiddenTabbar:(BOOL)hidden;

@end
