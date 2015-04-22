//
//  DoctorDetailIfoVC.h
//  妈妈问
//
//  Created by lixuan on 15/3/10.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BaseViewController.h"
#import "SpecialistModel.h"
@interface DoctorDetailIfoVC : BaseViewController
@property (nonatomic, assign) BOOL isAuthentication;
@property (nonatomic, strong) SpecialistModel *model;
@end
