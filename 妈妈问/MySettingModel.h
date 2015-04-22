//
//  MySettingModel.h
//  妈妈问
//
//  Created by kin on 15/4/6.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySettingModel : NSObject

@property (nonatomic, copy)  NSString *picPath;
@property (nonatomic, copy)  NSString *title;
@property (nonatomic, copy)  NSString *subTitle;
@property (nonatomic, assign) BOOL shouldShowArrow;
@end
