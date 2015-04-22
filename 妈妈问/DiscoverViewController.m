//
//  DiscoverViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "DiscoverViewController.h"
#import "RegisterVC.h"
#import "LoginViewController.h"

#import "SettingView.h"
#import "MySettingModel.h"
#import "SettingViewController.h"
#import "BecomeVIPVC.h"
@interface DiscoverViewController ()
{

    UIImageView *_iconImgV;
    UILabel     *_nameLable;
    UILabel     *_phoneLable;
    
    UILabel     *_levelLable;
    UILabel     *_balanceLable;
    
    UIScrollView *_scroll;
    UIImageView  *_userInfoV;
    
    
    NSMutableArray *_titleArr;
    
}
@end

@implementation DiscoverViewController
- (void)leftBarButtonItemClick {}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    [self setLeftNavigationItemWithTitle:@"" isImage:NO];
    
    [self prepareData];
    [self uiConfig];
}
- (void)prepareData {
    
  if (!_name)  _name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameIdentify];
  if (!_phone)  _phone = @"18777776677";
  if (!_level)  _level = @"0";
  if (!_balance)   _balance = @"0";
  if (!_golds)  _golds = @"0";
  if (!_iconImg)  _iconImg = [UIImage imageNamed:@"baby"];
  if (!_titleArr)  _titleArr = [NSMutableArray array];
    NSArray *titles = @[//@"开通会员",@"赚取金币",@"金币商城",
                        @"设置与帮助"];
    NSArray *pics = @[//@"16_03",@"05_07",@"16_09",
                      @"16_11"];
    for (int i = 0; i < titles.count; i++) {
        MySettingModel *model = [[MySettingModel alloc] init];
        model.picPath = pics[i];
        model.title = titles[i];
        model.shouldShowArrow = YES;
        if (1 == i) {
            model.subTitle = [NSString stringWithFormat:@"当前金币  %@",_golds];
        }
        [_titleArr addObject:model];
    }
}
- (void)uiConfig {
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_scroll];
    [self creatIconImgV];
}
- (void)creatIconImgV {
    _userInfoV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 5)];
    _userInfoV.userInteractionEnabled = YES;
    [_scroll addSubview:_userInfoV];

    [self refrashUserInfo];
    [self createLevelView];
    
}
- (void)refrashUserInfo {
    for (UIView *view in _userInfoV.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat w = CGRectGetHeight(_userInfoV.frame) * 0.6;
    _iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(_userInfoV.frame) / 2 - w / 2, w, w)];
    _iconImgV.layer.cornerRadius = w / 2;
    _iconImgV.layer.masksToBounds = YES;
//    _iconImgV.backgroundColor = [UIColor whiteColor];
    [_userInfoV addSubview:_iconImgV];
    
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_userInfoV.frame) - 30, _iconImgV.center.y - 7, 10, 15)];
    arrow.image = [UIImage imageNamed:@"11_10"];
    [_userInfoV addSubview:arrow];
    
   NSInteger tag = [[[NSUserDefaults standardUserDefaults] objectForKey:kHasLoginOrRegister] integerValue];
    if (tag != 0) {// 已登录
        _iconImgV.image = _iconImg;
//        [UIView animateWithDuration:0.8 animations:^{
//            CGRect rect = _iconImgV.frame;
//            rect.origin.x  = 30;
//            _iconImgV.frame = rect;
//        } completion:^(BOOL finished) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgV.frame) + 10, _iconImgV.center.y, CGRectGetMinX(arrow.frame) - CGRectGetMaxX(_iconImgV.frame) - 30, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [_userInfoV addSubview:line];
            
            _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(line.frame), CGRectGetMinY(line.frame) - 30, 100, 30)];
            _nameLable.text = _name;
            _nameLable.textColor = [UIColor whiteColor];
            _nameLable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
            [_userInfoV addSubview:_nameLable];
            
            
            _phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(line.frame), CGRectGetMaxY(line.frame) + 10, CGRectGetWidth(line.frame), 20)];
            _phoneLable.text = [NSString stringWithFormat:@"手机:  %@",_phone];
            _phoneLable.textColor = [UIColor whiteColor];
            _phoneLable.font = [UIFont systemFontOfSize:iphone6? 16:14];
            [_userInfoV addSubview:_phoneLable];
            
            [_userInfoV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkUserInfos)]];
//        }];
    } else {//未登录
        _iconImgV.image = _iconImg;
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgV.frame) + 20, _iconImgV.center.y - 10, 200, 20)];
        lable.text = @"您尚未登录或注册，现在就去?";
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:iphone6? 16 : 14];
        lable.adjustsFontSizeToFitWidth = YES;
        [_userInfoV addSubview:lable];
    
        [_userInfoV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goRegister)]];
    }

}
- (void)createLevelView {
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_userInfoV.frame), kScreenWidth, CGRectGetHeight(_userInfoV.frame) * 0.4)];
    backV.backgroundColor = [UIColor colorWithRed:0.84 green:0.58 blue:0.64 alpha:1];
    [_scroll addSubview:backV];
    
    UILabel *lvl = [[UILabel alloc] initWithFrame:CGRectMake(30, backV.frame.size.height / 2 - 10, 50, 20)];
    lvl.textColor = [UIColor whiteColor];
    lvl.text = @"等级";
    lvl.font = [UIFont systemFontOfSize:iphone6?16 : 14];
    [backV addSubview:lvl];
    
    _levelLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lvl.frame) + 20, CGRectGetMinY(lvl.frame), 50, 20)];
    _levelLable.text = [NSString stringWithFormat:@"LV : %@",_level];
    _levelLable.textColor = [UIColor whiteColor];
    _levelLable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
    [backV addSubview:_levelLable];
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(backV.frame) / 2, 5, 1, CGRectGetHeight(backV.frame) - 10)];
    lv.backgroundColor = [UIColor whiteColor];
    [backV addSubview:lv];
    
    UILabel *bnl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lv.frame ) + 20, CGRectGetMinY(lvl.frame), CGRectGetWidth(lvl.frame), CGRectGetHeight(lvl.frame))];
    bnl.textColor = [UIColor whiteColor];
    bnl.font = lvl.font;
    bnl.text = @"余额";
    [backV addSubview:bnl];
    
    
    _balanceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bnl.frame) + 50, CGRectGetMinY(_levelLable.frame), CGRectGetWidth(_levelLable.frame), CGRectGetHeight(_levelLable.frame))];
    _balanceLable.font = _levelLable.font;
    _balanceLable.text = _balance;
    _balanceLable.textColor = [UIColor whiteColor];
    [backV addSubview:_balanceLable];
    
    [self createListViewWithTopY:CGRectGetMaxY(backV.frame) + 20];
}
- (void)createListViewWithTopY:(CGFloat)frameY {
    CGFloat h = _userInfoV.frame.size.height / 2;
    for (int i = 0; i < _titleArr.count; i++) {
        SettingView *set = [[SettingView alloc] initWithFrame:CGRectMake(0, frameY + h * i, kScreenWidth, h)];
        set.backgroundColor = [UIColor colorWithRed:0.88 green:0.62 blue:0.72 alpha:1];
        set.tag = 300 + i;
        [set addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listViewTap:)]];
        set.model = _titleArr[i];
        [_scroll addSubview:set];
        
        UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(0, set.frame.size.height - 1, CGRectGetWidth(set.frame), 0.5)];
        linev.backgroundColor = [UIColor whiteColor];
        [set addSubview:linev];
    }
}
- (void)goRegister {

    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)checkUserInfos {

    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)listViewTap:(UIGestureRecognizer *)ges {
    NSInteger inde = ges.view.tag - 300;
    
    SettingViewController *vc = [[SettingViewController alloc] init];
//    BecomeVIPVC *vipVC = [[BecomeVIPVC alloc] init];
    switch (inde) {
//        case 0: // 会员
//           vipVC.title = @"开通会员";
//            [self.navigationController pushViewController:vipVC animated:YES];
//            break;
//        case 1:// 赚金币
//            vc.title = @"赚取金币";
//            [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"敬请期待" leftbtn:@"OK" rightBtn:nil];
//            break;
//        case 2:// 商城
//            vc.title = @"金币商城";
//            [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"敬请期待" leftbtn:@"OK" rightBtn:nil];
//            break;
        case 0:// 设置
            vc.title = @"设置与帮助";
            [self.navigationController pushViewController:vc animated:YES];
            break;
            
        default:
            break;
    }
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self prepareData];
    [self refrashUserInfo];
    [self hiddenTabbar:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
//    [self hiddenTabbar:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
