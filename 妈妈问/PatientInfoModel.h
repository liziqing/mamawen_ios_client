//
//  PatientInfoModel.h
//  妈妈问
//
//  Created by lixuan on 15/3/12.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//


// AskForFreeViewController 患者信息 - Model
#import <Foundation/Foundation.h>

@interface PatientInfoModel : NSObject
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *sex;
@property (nonatomic, copy)   NSString *age;
@property (nonatomic, copy)   NSString *lastTime;
@property (nonatomic, copy)   NSString *category;
@end
