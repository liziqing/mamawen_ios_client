//
//  RootTabbarController.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "RootTabbarController.h"
#import "CustomTabbarButton.h"

#import "HomePageViewController.h"
#import "InquiryViewController.h"
//#import "HealthViewController.h"
#import "DiscoverViewController.h"

#import "BaseNavigationController.h"


#import "ChartVC.h"

@interface RootTabbarController ()
{
    UIImageView *_customTabbarImgV;
}
@end

@implementation RootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createViewControllers];
    self.tabBar.hidden = YES;
    [self createTabbarButtons];
}

// 自定义tabbar按钮
- (void)createTabbarButtons {
    // 自定义tabbar
    CGFloat H = self.tabBar.frame.size.height;
    _customTabbarImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - H, kScreenWidth, H)];
    _customTabbarImgV.backgroundColor = [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1];
    _customTabbarImgV.backgroundColor = [UIColor colorWithRed:0.84 green:0.55 blue:0.56 alpha:1];
    _customTabbarImgV.userInteractionEnabled = YES;
    [self.view addSubview:_customTabbarImgV];
    
    NSArray *namesArr = @[@"首页",@"问诊",@"健康",@"我"]; // 按钮名称(个数)
    NSArray *imagesArr = @[@"UI_60",@"UI_63",@"UI_57",@"UI_66"]; // 按钮图片
//    NSArray *imageSelected = @[@"jiezhen1_03",@"jiezhen1_07",@"jiezhen1_10",@"jiezhen1_14"]; // 按钮选中图片
    
    NSInteger index = [[[NSUserDefaults standardUserDefaults] objectForKey:kTabbarBtnIdentify] integerValue];
    self.selectedIndex = index;
    
    for (int i = 0; i < namesArr.count; i ++) {
        CustomTabbarButton *btn = [[CustomTabbarButton alloc] initWithFrame:CGRectMake(kScreenWidth / 4 * i, 0, kScreenWidth / 4, H)];
        [btn setTitle:namesArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imagesArr[i]] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:imageSelected[i]] forState:UIControlStateSelected];
        
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:64];
        [_customTabbarImgV addSubview:btn];
        
        if (index == i) {
            btn.selected = YES;
        }
    }
}

// 按钮点击事件
- (void)tabbarButtonClick:(UIButton *)btn {
    for (id obj in _customTabbarImgV.subviews) {
        if ([obj isKindOfClass:[CustomTabbarButton class]]) {
            [(CustomTabbarButton *)obj setSelected:NO];
        }
    }
    
    NSInteger tag = btn.tag - 10;
    [[NSUserDefaults standardUserDefaults] setObject:@(tag) forKey:kTabbarBtnIdentify];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    btn.selected = YES;
    self.selectedIndex = tag;
}

// 视图控制器
- (void)createViewControllers {
    HomePageViewController *homePgVC = [[HomePageViewController alloc] init];
    InquiryViewController *inquiryVC = [[InquiryViewController alloc] init];
    ChartVC *healthVC = [[ChartVC alloc] init];
    DiscoverViewController *discoverVC = [[DiscoverViewController alloc] init];
    
    NSArray *arr = @[homePgVC,inquiryVC,healthVC,discoverVC];
    NSMutableArray *navis = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++) {
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:arr[i]];
        [navis addObject:navi];
    }
    self.viewControllers = navis;
}
- (void)hiddenMyTabbar:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:0.35 animations:^{
            _customTabbarImgV.alpha = 0;
            CGRect rect = _customTabbarImgV.frame;
//            rect.origin.x = -CGRectGetWidth(_customTabbarImgV.frame);
            rect.origin.y = kScreenHeight;
            _customTabbarImgV.frame = rect;
        }];
        
    }
    else  {
        [UIView animateWithDuration:0.35 animations:^{
            _customTabbarImgV.alpha = 1;
            CGRect rect = _customTabbarImgV.frame;
//            rect.origin.x = 0;
            rect.origin.y = kScreenHeight - CGRectGetHeight(_customTabbarImgV.frame);
            _customTabbarImgV.frame = rect;
        }];
    }
}
@end
