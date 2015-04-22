//
//  MsgListTableViewCell.h
//  妈妈问
//
//  Created by kin on 15/4/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MsgListTableViewCell : UITableViewCell
@property (nonatomic, strong) MessageModel *model;

@property (nonatomic, assign) BOOL isShowBadge;
@end
