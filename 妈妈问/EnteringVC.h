//
//  EnteringVC.h
//  妈妈问
//
//  Created by kin on 15/4/13.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BaseViewController.h"


@interface EnteringVC : BaseViewController
@property (nonatomic, copy) void(^endEnteringCB)(NSDictionary*para);
@property (nonatomic, assign) enteringType type;
@end
