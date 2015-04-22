//
//  HomePageViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "HomePageViewController.h"
#import "ReservationTapView.h"
#import "UserInfoView.h"
#import "AskForFreeViewController.h"
#import "SpecialistViewController.h"
//#import "FriendListViewController.h"
#import "CamberView.h"
#import "WheelButtonModel.h"
#import <QuartzCore/QuartzCore.h>
#import "RegisterVC.h"
#import "LoginViewController.h"

#import "MessageListViewController.h"
//#import <AdSupport/ASIdentifierManager.h>  //

#import "DoctorDetailIfoVC.h"

@interface HomePageViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scroll;
    UserInfoView *_userInfoView;  // 个人信息展示 View
    CGFloat _bannerHeight;
    
    UIImageView *_bannerImgv;
    
    UIView *_userInfoBackView;
    CamberView *_buttonsBackV;
}
@end

@implementation HomePageViewController

//
- (void)rightBarButtonItemclick {
//    MessageListViewController *vc = [[MessageListViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setRightNavigationItemWithTitle:@"add" isImage:YES];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarMaxY )];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    [self setLeftNavigationItemWithTitle:@"menu" isImage:YES];
    self.title = @"妈妈问";
    
    
    [self createBanner];

}



#warning left button
- (void)leftBarButtonItemClick {
//    RegisterVC *vc = [RegisterVC new];
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)createBanner {
    _bannerHeight = kScreenHeight / 6;
    _bannerImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _bannerHeight)];
    UIImage *img1 = [UIImage imageNamed:@"banner"];
    UIImage *img2 = [UIImage imageNamed:@"banner2"];
    _bannerImgv.animationImages = @[img1,img2];
    _bannerImgv.animationRepeatCount = 0;
    _bannerImgv.animationDuration = 5.0;
    [_scroll addSubview:_bannerImgv];
    
    
    [self createUserInfoLableWithTopY:CGRectGetMaxY(_bannerImgv.frame) + 5];
}
- (void)createUserInfoLableWithTopY:(CGFloat)frameY {
    _userInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, frameY, kScreenWidth, _bannerHeight * 3 / 4)];
    _userInfoBackView.backgroundColor = [UIColor colorWithRed:0.89 green:0.64 blue:0.7 alpha:0.6];
    [_scroll addSubview:_userInfoBackView];

    [self createTapsWithTopY:CGRectGetMaxY(_userInfoBackView.frame) + 1];
}
- (void)RefrashUserInfoViews {
   BOOL hasLog = [[[NSUserDefaults standardUserDefaults] objectForKey:kHasLoginOrRegister] intValue];
    for (UIView *vw in _userInfoBackView.subviews) {
            [vw removeFromSuperview];
    }
    
    if (hasLog) {
        _userInfoView = [[UserInfoView alloc] initWithFrame:_userInfoBackView.bounds];
    _userInfoView.backgroundColor = [UIColor clearColor];
        
   
    _userInfoView.iconImg = [UIImage imageNamed:@"userinfo_status_icon_after_pregnant"];
    _userInfoView.name = @"胡杨";
    _userInfoView.dayNumber = @"24天";
    _userInfoView.descStr = @"   新生儿吃完奶后，常常会吐出一些奶，他并不是生病，只是在吸奶时连带吸入了空气，在吃完奶后把空气吐出来，使得奶也跟着吐出。";
    _userInfoView.iconImg = [UIImage imageNamed:@"userinfo_status_icon_after_pregnant"];
    
    [_userInfoBackView addSubview:_userInfoView];
    } else {
        
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(_userInfoBackView.frame) / 2 - 15, CGRectGetWidth(_userInfoBackView.frame) * 3 / 5, 30)];
        lable.textColor = [UIColor whiteColor];
        lable.text = @"每一个宝宝都是妈妈的天使";
        lable.font = [UIFont systemFontOfSize:iphone6?16:14];
        [_userInfoBackView addSubview:lable];
        
        UIImageView *vv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_userInfoBackView.frame) - 30, lable.center.y - 7.5, 15, 15)];
        vv.image = [UIImage imageNamed:@"11_10"];
        vv.userInteractionEnabled = YES;
        [vv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goinRegister)]];
        [_userInfoBackView addSubview:vv];
        
        UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(vv.frame) - 80, CGRectGetMinY(lable.frame), 70, 30)];
        ll.text = @"加入妈妈帮";
        ll.textColor = [UIColor whiteColor];
        ll.adjustsFontSizeToFitWidth = YES;
        ll.userInteractionEnabled = YES;
        [ll addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goinRegister)]];
        [_userInfoBackView addSubview:ll];
    }
}
// 进入注册 或者登陆
- (void)goinRegister {
//    RegisterVC *vc = [[RegisterVC alloc] init];
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createTapsWithTopY:(CGFloat)frameY {
    NSArray *iconImgsArr = @[@"免费提问",@"专家问诊"];
    NSArray *titleArr = @[@"问医生",@"找医生"];
    
    CGFloat H = 0.0;
    for (int i = 0; i < 2; i++ ) {
        ReservationTapView *view = [[ReservationTapView alloc] initWithFrame:CGRectMake((kScreenWidth + 2) / 2 * i, frameY, kScreenWidth / 2, _bannerHeight + _bannerHeight / 3)];
        view.backgroundColor = [UIColor clearColor];
        view.iconString = iconImgsArr[i];
        view.titleString = titleArr[i];
        view.tag = 10 + i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)]];
        [_scroll addSubview:view];
        
        if (i == 1) {
            H = CGRectGetMaxY(view.frame);
        }
        
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, frameY + 5, 1, _bannerHeight + _bannerHeight / 3 - 25)];
    lineView.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:lineView];
    
    [self createDoctorView:H + 5];
}

// 医生头像view
- (void)createDoctorView:(CGFloat)topY {
//    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(25, topY, kScreenWidth - 50, 1)];
//    lineV.backgroundColor = [UIColor whiteColor];
//    [_scroll addSubview:lineV];
    
    CGFloat H =  self.tabBarController.tabBar.frame.origin.y - topY;
#warning 医生头像 
   
    UIImage *img = [UIImage imageNamed:@"04_101"];
    
    NSArray *arr = @[img,img,img,img,img];
    NSArray *nameArr = @[@"张医生",@"李医生",@"王医生",@"赵医生",@"孙医生"];
    NSArray *hosArr = @[@"北京协和医院",@"北京积水潭医院",@"虹口区妇幼保健院",@"上海第二医科大学附属新华医院",@"第一妇幼保健院"];
    _buttons = [NSMutableArray array];
    for (int i = 0; i < nameArr.count; i ++) {
        WheelButtonModel *model = [[WheelButtonModel alloc] init];
        model.name = nameArr[i];
        model.hospital = hosArr[i];
        model.icon = arr[i];
        [_buttons addObject:model];
    }
    
    CGRect viewRect = CGRectMake(0, topY, kScreenWidth, H - 64);
    
    _buttonsBackV = [[CamberView alloc] initWithFrame:viewRect];
    _buttonsBackV.models = _buttons;
    
    __block NSMutableArray *models = [NSMutableArray arrayWithArray:_buttons];
    __block CamberView *camber = _buttonsBackV;
    __block DoctorDetailIfoVC *vc = [[DoctorDetailIfoVC alloc] init];
    __block HomePageViewController *weakself  = self;
    [_buttonsBackV setButtonClickInIndex:^(NSInteger index) {
        if (0 == index) {// 进入医生页面?
#warning 设置每日医生model
//vc.model =
            vc.title = @"医生简介";
//            [weakself.navigationController pushViewController:vc animated:YES];
            [ShowAlertView showAlertViewWithTitle:@"Tips" message:[NSString stringWithFormat:@"进入了解%@更多信息",[models[0] name]] leftbtn:@"取消" rightBtn:nil];
        } else {
            [models exchangeObjectAtIndex:index withObjectAtIndex:0];
            camber.models = models;
        }
    }];

   
    [_scroll addSubview:_buttonsBackV];
//    _scroll.contentSize 
}


- (void)buttonPressed:(id)btn {
    UIButton *b = (UIButton *)btn;
    NSLog(@"%ld",(long)b.tag);
}
- (void)viewTaped:(UIGestureRecognizer *)ges {
    NSInteger index = ges.view.tag - 10;
    AskForFreeViewController *askForFreeVC = [[AskForFreeViewController alloc] init];
    SpecialistViewController    *speVC = [[SpecialistViewController alloc] init];
    switch (index) {
        case 0:
            askForFreeVC.title = @"预诊对象";
            [self.navigationController pushViewController:askForFreeVC animated:YES];
            break;
        case 1:
            speVC.title = @"找医生";
            [self.navigationController pushViewController:speVC animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
   [_bannerImgv startAnimating];
    [self hiddenTabbar:NO];
    
    [self RefrashUserInfoViews];
}
- (void)viewWillDisappear:(BOOL)animated {
   [_bannerImgv stopAnimating];
//    [self hiddenTabbar:YES];
}


@end