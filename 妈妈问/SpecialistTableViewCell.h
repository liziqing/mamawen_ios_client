//
//  SpecialistTableViewCell.h
//  妈妈问
//
//  Created by kin on 15/4/16.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialistModel.h"
@interface SpecialistTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *hospital;


@property (nonatomic, strong)  SpecialistModel *model;
@end
