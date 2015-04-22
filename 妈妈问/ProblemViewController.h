//
//  ProblemViewController.h
//  妈妈问
//
//  Created by lixuan on 15/3/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BaseViewController.h"
#import "PatientInfoModel.h"
@interface ProblemViewController : BaseViewController
@property (nonatomic, strong)  PatientInfoModel *model;
@property (nonatomic, assign)  BOOL isFindDr;
@property (nonatomic, copy)    NSString *doctorID;
@end
