//
//  MsgListTableViewCell.m
//  妈妈问
//
//  Created by kin on 15/4/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "MsgListTableViewCell.h"

@implementation MsgListTableViewCell
{
    UIImageView *_iconImgV;
    UILabel *_nameLable;
    UILabel *_contentLable;
    UILabel *_timelable;
    UIImageView *_badgeV;
    
}
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    CGFloat H = self.frame.size.height;
    CGFloat W = self.frame.size.width;
    _iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, H - 8, H - 8)];
    _iconImgV.layer.cornerRadius = (H - 10)/2;
    _iconImgV.layer.masksToBounds = YES;
    _iconImgV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_iconImgV];
    
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgV.frame) + 5, 5, W - CGRectGetMaxX(_iconImgV.frame) - 120, CGRectGetHeight(_iconImgV.frame) / 2 - 3)];
    _nameLable.font = [UIFont systemFontOfSize:18];
    _nameLable.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameLable];
    
    _contentLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLable.frame), CGRectGetMaxY(_nameLable.frame) + 6, CGRectGetWidth(_nameLable.frame) + 100, CGRectGetHeight(_nameLable.frame))];
    _contentLable.font = [UIFont systemFontOfSize:12];
    _contentLable.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentLable];
    
    _timelable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLable.frame) + 10, 5, 100, CGRectGetHeight(_nameLable.frame))];
    _timelable.textColor = [UIColor whiteColor];
    _timelable.font = [UIFont systemFontOfSize:12];
    _timelable.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_timelable];
    
    _badgeV = [[UIImageView alloc] initWithFrame:CGRectMake(_timelable.center.x, _contentLable.center.y, 8, 8)];
    _badgeV.layer.cornerRadius = 4;
    _badgeV.layer.masksToBounds = YES;
    _badgeV.backgroundColor = [UIColor redColor];
    _badgeV.hidden = YES;
    
    
}
- (void)setModel:(MessageModel *)model {
    _iconImgV.image = [UIImage imageNamed:@"04_101"];
    _nameLable.text = model.messageId;
    // 内容
    if (model.ccategory == chatCatagoryNormal) {
        if (model.cmode == chatModeString) {
            _contentLable.text = model.messageBody;
        } else if (model.cmode == chatModePicture) {
            _contentLable.text = @"[图片]";
        } else if (model.cmode == chatModeVideo) {
            _contentLable.text = @"[语音]";
        }
    } else if (model.ccategory == chatCatagoryPrediagnosisReport) {
        _contentLable.text = @"[问诊报告]";
    }
    
    _timelable.text = model.mesTime;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
