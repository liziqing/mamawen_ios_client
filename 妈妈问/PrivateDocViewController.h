//
//  PrivateDocViewController.h
//  妈妈问
//
//  Created by lixuan on 15/3/10.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BaseViewController.h"


// 现在不用  抛弃了?
@interface PrivateDocViewController : BaseViewController
@property (nonatomic, copy)  NSString *UID;

@property (nonatomic, copy)  NSString *price;//  原价
@property (nonatomic, copy)  NSString *buyerNum;//  购买人数
@property (nonatomic, copy)  NSString *discountPrice;//  折扣价
@property (nonatomic, copy)  NSString *name;//  姓名
@property (nonatomic, copy)  NSString *category;//  职称
@property (nonatomic, copy)  NSString *skill;//  擅长
@property (nonatomic, copy)  NSString *evaluate; // 评价
@end
