//
//  CamberView.h
//  妈妈问
//
//  Created by kin on 15/4/15.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamberView : UIView
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, copy) void(^buttonClickInIndex)(NSInteger index);
@end
