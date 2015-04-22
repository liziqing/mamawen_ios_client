//
//  DrListCell.m
//  妈妈问
//
//  Created by kin on 15/4/18.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "DrListCell.h"
#import "UIImageView+AFNetworking.h"
@implementation DrListCell
{
    UIImageView *_icon;
    UILabel     *_name;
    UILabel     *_hospital;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat w = self.frame.size.height  * 2 / 3;
        CGFloat space = self.frame.size.height / 6;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(30, space, w, w)];
        [self.contentView addSubview:_icon];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame) + space * 3, self.frame.size.height / 2 - 10, w * 3, 20)];
        _name.textColor = [UIColor whiteColor];
        _name.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
        [self.contentView addSubview:_name];
        
        _hospital = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_name.frame), CGRectGetMinY(_name.frame) + 5, w * 3, 15)];
        _hospital.textColor = [UIColor whiteColor];
        _hospital.font = [UIFont systemFontOfSize:iphone6?16 : 14];
        [self.contentView addSubview:_hospital];
    }
    return self;
}
- (void)setModel:(DrListModel *)model {
    if (!model.hospital) {
        _icon.image = [UIImage imageNamed:model.picPath];
        _name.text = model.name;
    } else {
        _icon.layer.cornerRadius = _icon.frame.size.height / 2;
        _icon.layer.masksToBounds = YES;
        [_icon setImageWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:model.picPath]] placeholderImage:[UIImage imageNamed:@"04_101"]];
        _name.text = model.name;
        _hospital.text = model.hospital;
    }

}
@end
