//
//  SureToAskVC.m
//  妈妈问
//
//  Created by kin on 15/4/22.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "SureToAskVC.h"
#import "AskForFreeViewController.h"
#import "UIImageView+AFNetworking.h"
@interface SureToAskVC ()
{
    UIScrollView *_scroll;
}
@end

@implementation SureToAskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}

- (void)uiConfig {
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
//    _scroll.del
    [self.view addSubview:_scroll];
    
    UIView *userInfoV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5)];
    [_scroll addSubview:userInfoV];
    CGFloat spaceW = 8;
    CGFloat iconW  = 70;
    
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(spaceW * 3, spaceW * 2, iconW, iconW)];
    iconV.layer.cornerRadius = iconW / 2;
    iconV.layer.masksToBounds = YES;
    //    iconV.backgroundColor = [UIColor lightGrayColor];
    NSString *iconPath = _model.iconPath;
    //    NSLog(@"%@",iconPath);
    if (![iconPath isEqual:[NSNull null]]) {
        [iconV setImageWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:iconPath]] placeholderImage:[UIImage imageNamed:@"04_101"]];
    }
    else iconV.image = [UIImage imageNamed:@"04_101"];
    [userInfoV addSubview:iconV];
    
    // 名字
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + spaceW,CGRectGetMinY(iconV.frame), 60, 20)];
    nameLable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
    nameLable.text = _model.name;
    nameLable.textColor = [UIColor whiteColor];
    [userInfoV addSubview:nameLable];
    
    UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLable.frame), CGRectGetMaxY(nameLable.frame) + spaceW, kScreenWidth - CGRectGetMinX(nameLable.frame) - 30, 1)];
    linev.backgroundColor = [UIColor whiteColor];
    [userInfoV addSubview:linev];
    
    // 职称
    UILabel *zcLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLable.frame), CGRectGetMaxY(linev.frame), 70, 20)];
    zcLable.font = [UIFont systemFontOfSize:iphone6?16 : 14];
    zcLable.textColor = [UIColor whiteColor];
    zcLable.text = _model.category;
    [userInfoV addSubview:zcLable];
    
    [self chargeView:CGRectGetMaxY(userInfoV.frame) + 20];
}
- (void)chargeView:(CGFloat)frameY {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frameY, kScreenWidth, 50)];
    view.backgroundColor = [UIColor colorWithRed:0.88 green:0.65 blue:0.72 alpha:1];
    [_scroll addSubview:view];
    
    
    UILabel *freeLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 30)];
    freeLabe.text = @"    免费咨询";
    freeLabe.textColor = [UIColor whiteColor];
    freeLabe.font = [UIFont systemFontOfSize:18];
    [view addSubview:freeLabe];
    
    UILabel *descLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(freeLabe.frame), kScreenWidth / 2, 20)];
    descLable.text = @"        医生将在24小时内进行回复";
    descLable.textColor = [UIColor whiteColor];
    descLable.font = [UIFont systemFontOfSize:14];
    [view addSubview:descLable];
    
    UILabel *sureLable = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 70, view.frame.size.height / 2 - 10, 70, 20)];
    sureLable.textColor = [UIColor whiteColor];
    sureLable.text = @"咨询";
    sureLable.font = [UIFont systemFontOfSize:16];
    [view addSubview:sureLable];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(freeAsking)]];
}
- (void)freeAsking {

    AskForFreeViewController *vc = [[AskForFreeViewController alloc] init];
    vc.isFindDr = YES;
    vc.doctorID = _model.drID;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
@end
