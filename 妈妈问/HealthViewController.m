//
//  HealthViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "HealthViewController.h"
#import "EnteringVC.h"



@interface HealthViewController ()
{
    UIScrollView *_scroll;
    
}
@end

@implementation HealthViewController

- (void)prepareData {
    
}
- (void)leftBarButtonItemClick {}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康";
    [self setLeftNavigationItemWithTitle:@"" isImage:NO];
    [self prepareData];
    [self uiConfig];
}


- (void)uiConfig {
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenHeight)];
    _scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scroll];
    
    CGFloat H = 60;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, H / 3, kScreenWidth, H)];
    view.backgroundColor = [UIColor colorWithRed:0.89 green:0.68 blue:0.72 alpha:0.8];
    [_scroll addSubview:view];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, view.frame.size.height / 2 - 15, 30, 30)];
    imgV.image = [UIImage imageNamed:@"123_05"];
    [view addSubview:imgV];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 15, CGRectGetMinY(imgV.frame), kScreenWidth / 4, CGRectGetHeight(imgV.frame))];
    lable.text = @"查看病例";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:16];
    [view addSubview:lable];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30, view.frame.size.height / 2 - 10, 16, 20)];
    arrow.image = [UIImage imageNamed:@"11_10"];
    [view addSubview:arrow];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkCase)]];
    
    [self configGraphWithTopY:CGRectGetMaxY(view.frame) + 20];
}

// 查看病例
- (void)checkCase {
    [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"查看病例" leftbtn:nil rightBtn:@"sure"];

}
- (void)configGraphWithTopY:(CGFloat)frameY {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, frameY, kScreenWidth - 30, 100)];
    view.backgroundColor = [UIColor colorWithRed:0.89 green:0.68 blue:0.72 alpha:0.8];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enteringDataWithTitle)]];
    [_scroll addSubview:view];
}
- (void)enteringDataWithTitle {
    EnteringVC *vc = [[EnteringVC alloc] init];
    vc.type = 0;
    [vc setEndEnteringCB:^(NSDictionary *para) {
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
