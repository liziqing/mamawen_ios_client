//
//  PatientInfoView.h
//  妈妈问
//
//  Created by lixuan on 15/3/12.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//


// AskForFreeViewController  添加患者信息View
#import <UIKit/UIKit.h>
#import "PatientInfoModel.h"
@interface PatientInfoView : UIView
@property (nonatomic, assign) BOOL isSlected;


@property (nonatomic, strong) PatientInfoModel *model;

@property (nonatomic, copy)  void(^editCallBack)();
@property (nonatomic, copy)  void(^selectedCB)();
- (void)setSelected:(BOOL)select;
@end
