//
//  SpecialistTableViewCell.m
//  妈妈问
//
//  Created by kin on 15/4/16.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "SpecialistTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation SpecialistTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.53 blue:0.67 alpha:0.6];
    _icon.layer.cornerRadius = _icon.frame.size.height / 2;
    _icon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SpecialistModel *)model {
//    _icon.image = model.iconImage;
    NSString *iconPath = model.iconPath;
//    NSLog(@"%@",iconPath);
    if (![iconPath isEqual:[NSNull null]]) {
        [_icon setImageWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:iconPath]] placeholderImage:[UIImage imageNamed:@"04_101"]];
    }
    else _icon.image = [UIImage imageNamed:@"04_101"];
    _name.text = model.name;
    _category.text = model.category;
    _hospital.text = model.hospital;
}
@end
