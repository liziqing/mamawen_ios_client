//
//  PrivateDocViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/10.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "PrivateDocViewController.h"
#import "DoctorDetailIfoVC.h"


@interface PrivateDocViewController ()
{
    UIScrollView *_scroll;
    CGFloat _spaceW;         // 控件间的小间隔
    CGFloat _bottomH;        // 底部购买lable的高度
    
  
}
@end

@implementation PrivateDocViewController
- (void)prepareData {
    if (!_price)         _price = @"100";
    if (!_buyerNum)      _buyerNum = @"49";
    if (!_discountPrice) _discountPrice = @"95";
    if (!_name)          _name = @"小黄";
    if (!_category)      _category = @"主治医师";
    if (!_skill)         _skill = @"擅长儿科";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithRed:0.84 green:0.68 blue:0.62 alpha:1];
    [self prepareData];
    [self uiConfig];
}
- (void)uiConfig {
    CGFloat topViewheight = 70; //
    _spaceW = 8;
    _bottomH = 60;
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarMaxY - 60)];
//    _scroll.backgroundColor = [UIColor redColor];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_scroll];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,1, kScreenWidth, topViewheight)];
    topView.backgroundColor = [UIColor clearColor];
    [_scroll addSubview:topView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), CGRectGetWidth(topView.frame), 1)];
    lineV.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:lineV];
    
    // 头像
    UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(_spaceW, _spaceW, topViewheight - _spaceW * 2, topViewheight - _spaceW * 2)];
    iconImgV.layer.cornerRadius = 5;
    iconImgV.layer.masksToBounds = YES;
    iconImgV.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:iconImgV];
    
    // lable
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImgV.frame) + _spaceW, _spaceW + 2, topViewheight, 20)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:16];
    lable.text = @"私人医生";
    [topView addSubview:lable];
    
    // 购买人数
    UILabel *buyerLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lable.frame), CGRectGetMaxY(iconImgV.frame) - 20 - _spaceW, topViewheight, 20)];
    buyerLable.textAlignment = NSTextAlignmentCenter;
    buyerLable.font = [UIFont systemFontOfSize:12];
    buyerLable.textColor = [UIColor whiteColor];
    buyerLable.text = [NSString stringWithFormat:@"%@人购买",_buyerNum];
    [topView addSubview:buyerLable];
    
    // 价格
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - topViewheight * 2, topViewheight / 2 - 20, topViewheight * 2 - 20, 20)];
    priceLable.textAlignment = NSTextAlignmentRight;
    priceLable.font = [UIFont systemFontOfSize:18];
    priceLable.textColor = [UIColor colorWithRed:0.99 green:0.38 blue:0.13 alpha:1];
    priceLable.text = [NSString stringWithFormat:@"%@元/周",_price];
    [topView addSubview:priceLable];
    
    [self createDescribeLableWithTopY:CGRectGetMaxY(topView.frame) + 1];
}
- (void)createDescribeLableWithTopY:(CGFloat)topY {
    CGFloat descViewheight = 90;
    UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth, descViewheight)];
    descView.backgroundColor = [UIColor clearColor];
    [_scroll addSubview:descView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descView.frame), CGRectGetWidth(descView.frame), 1)];
    lineV.backgroundColor  = [UIColor whiteColor];
    [_scroll addSubview:lineV];
    
    // noticeLable
    UILabel *noteLable = [[UILabel alloc] initWithFrame:CGRectMake(_spaceW, _spaceW, kScreenWidth / 3, 20)];
    noteLable.font = [UIFont systemFontOfSize:12];
    noteLable.textAlignment = NSTextAlignmentLeft;
    noteLable.text = @"购买期间可享受:";
    [descView addSubview:noteLable];
    
    // 特约提问
    UILabel *special = [[UILabel alloc] initWithFrame:CGRectMake(_spaceW * 3, CGRectGetMaxY(noteLable.frame) + 5, noteLable.frame.size.width / 2, 20)];
    special.textColor = [UIColor greenColor];
    special.font = [UIFont systemFontOfSize:12];
    special.text = @"特约提问";
    special.textAlignment = NSTextAlignmentCenter;
    [descView addSubview:special];
    
    // 电话咨询
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(special.frame), CGRectGetMaxY(special.frame) + 5, special.frame.size.width, 20)];
    lable.textColor = [UIColor greenColor];
    lable.font = [UIFont systemFontOfSize:12];
    lable.text = @"电话咨询";
    lable.textAlignment = NSTextAlignmentCenter;
    [descView addSubview:lable];
    
    
    [self createDoctorInfoWithTopY:CGRectGetMaxY(descView.frame) + _spaceW];
}

// 医生信息视图
- (void)createDoctorInfoWithTopY:(CGFloat)topY {
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth, _bottomH)];
    infoV.backgroundColor = [UIColor clearColor];
    [_scroll addSubview:infoV];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(infoV.frame), CGRectGetWidth(infoV.frame), 1)];
    lineV.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:lineV];
    
    // 头像
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(_spaceW, _spaceW, _bottomH - _spaceW * 2, _bottomH - _spaceW * 2)];
    iconV.layer.cornerRadius = (_bottomH - _spaceW * 2) / 2;
    iconV.layer.masksToBounds = YES;
    iconV.backgroundColor = [UIColor lightGrayColor];
    [infoV addSubview:iconV];
    
    //  nameLable
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + _spaceW, CGRectGetMinY(iconV.frame), _bottomH, 20)];
    nameLable.textAlignment = NSTextAlignmentLeft;
    nameLable.font = [UIFont systemFontOfSize:17];
    nameLable.text = _name;
    [infoV addSubview:nameLable];
    
    // 职称lable
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLable.frame) + 1, _spaceW, _bottomH, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor whiteColor];
    lable.text = _category;
    [infoV addSubview:lable];
    
    // 介绍lable
    UILabel *desclable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLable.frame), CGRectGetMaxY(nameLable.frame) + _spaceW, kScreenWidth - CGRectGetMinX(nameLable.frame), 20)];
    desclable.numberOfLines = 1;
    desclable.font = [UIFont systemFontOfSize:12];
    desclable.textColor = [UIColor whiteColor];
    desclable.text = _skill;
    [infoV addSubview:desclable];
    [infoV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doctoerInfoTaped)]];
    
    
    // 右侧指示箭头
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoV.frame) - 20, CGRectGetHeight(infoV.frame) / 2 - 7.5, 15, 15)];
    arrow.image = [UIImage imageNamed:@"11_10"];
    [infoV addSubview:arrow];
    
    
    //
    [self createEvaluateViewWithTopY:CGRectGetMaxY(infoV.frame) + _spaceW];
}

// 评价视图
- (void)createEvaluateViewWithTopY:(CGFloat)topY {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth, CGRectGetHeight(_scroll.frame) - topY -1)];
    view.backgroundColor = [UIColor clearColor];
    [_scroll addSubview:view];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(view.frame), 1)];
    lineV.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:lineV];
    
    // 评价提示Lable
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(_spaceW, _spaceW, kScreenWidth / 2, 20)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:16];
    lable.textColor = [UIColor blackColor];
    lable.text = @"用户评价:";
    [view addSubview:lable];
    
    
    
    
    [self createBottomView];
}

// 底部购买视图
- (void)createBottomView {
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - _bottomH - kNavigationBarMaxY, kScreenWidth, _bottomH)];
    bv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bv];
    
    
    // priceLable
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(_spaceW * 2, _spaceW, 100, 20)];
    priceLable.text = [NSString stringWithFormat:@"¥%@元/周",_price];
    priceLable.textColor = [UIColor colorWithRed:0.99 green:0.38 blue:0.13 alpha:1];
    priceLable.font = [UIFont systemFontOfSize:18];
    [bv addSubview:priceLable];
    
    // 会员提示lable
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(priceLable.frame), CGRectGetMaxY(priceLable.frame) + _spaceW, kScreenWidth * 2 / 3, 20)];
    lable.text = [NSString stringWithFormat:@"会员价（需支付宝）%@元/周",_discountPrice];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor whiteColor];
    [bv addSubview:lable];
    
    
    
    
    // 购买按钮
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(kScreenWidth - 100 - _spaceW * 2, _spaceW, 100, _bottomH - _spaceW * 2);
    buyBtn.layer.cornerRadius = 5;
    buyBtn.layer.masksToBounds = YES;
    [buyBtn setBackgroundColor:[UIColor colorWithRed:0.99 green:0.38 blue:0.13 alpha:1]];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:64];
    [bv addSubview:buyBtn];
}
#pragma -
#pragma mark actions
- (void)doctoerInfoTaped {
    DoctorDetailIfoVC *dvc = [[DoctorDetailIfoVC alloc] init];
    dvc.title = @"医生信息";
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)buyBtnClick {
    NSLog(@"购买");
}
#pragma -
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
@end
