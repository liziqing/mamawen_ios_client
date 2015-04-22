//
//  ShowAlertView.m
//  妈妈问
//
//  Created by lixuan on 15/3/13.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "ShowAlertView.h"

@implementation ShowAlertView
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message leftbtn:(NSString *)left rightBtn:(NSString *)right {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:left otherButtonTitles:right, nil];
    [alert show];
}
@end
