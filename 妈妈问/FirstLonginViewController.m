//
//  FirstLonginViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "FirstLonginViewController.h"
#import "UserInfoOfRegisterVC.h"
#import "LoginViewController.h"

@interface FirstLonginViewController ()

@end

@implementation FirstLonginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    
    [self createBtns];
//    [self createLoginView];
}
- (void)createLoginView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 - kNavigationBarMaxY, self.view.frame.size.width, 60)];
    view.backgroundColor = [UIColor colorWithRed:0.21 green:0.64 blue:0.94 alpha:1];
    [self.view addSubview:view];
    
    CGFloat h = view.frame.size.height /3;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, h, view.frame.size.width / 2, h)];
    lable.text = @"已是妈妈帮用户";
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor whiteColor];
    [view addSubview:lable];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"登 陆" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(view.frame.size.width  * 5 / 6, h, view.frame.size.width / 6, h);
    btn.tag = 103;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:64];
    [view addSubview:btn];
}
- (void)createBtns {
    CGFloat w = (kScreenHeight - 64 - 49 - 100) / 3;
    CGFloat H = w;
    NSArray *imgsArr = @[@"userinfo_status_icon_prepare",@"userinfo_status_icon_pregnant",@"userinfo_status_icon_after_pregnant"];
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 40 + w*i, w, H);
        btn.layer.cornerRadius = w / 2;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageNamed:imgsArr[i]] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:64];
        [self.view addSubview:btn];
    }

}

- (void)btnClick:(UIButton *)btn {
    NSInteger tag = btn.tag - 100;
    if (tag == 3) {
        LoginViewController *loginVC = [LoginViewController new];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    UserInfoOfRegisterVC *vc = [[UserInfoOfRegisterVC alloc] init];
    vc.index = tag;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
