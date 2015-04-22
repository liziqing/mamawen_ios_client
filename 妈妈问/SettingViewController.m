//
//  SettingViewController.m
//  妈妈问
//
//  Created by kin on 15/4/6.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"
#import "MySettingModel.h"

#import "ChangePSDVC.h"
#import "NewMessageNoteVC.h"
#import "InfomationVC.h"
#import "AboutUsVC.h"
#import "SpeakOutVC.h"
@interface SettingViewController () <UIAlertViewDelegate>
{
    NSMutableArray *_firstArr;
    NSMutableArray *_secondArr;
    NSMutableArray *_thirdArr;

    CGFloat _viewH;
}
@end

@implementation SettingViewController
- (void)prepareData {
    _viewH = iphone6? 50 : 40;
    NSArray *fa = @[@"修改密码"];
    NSArray *sa = @[@"新消息通知",@"清理缓存"];
    NSArray *ta  = @[@"吐槽", @"服务条款"  ,@"使用帮助",@"关于我们"];

    
    _firstArr = [[NSMutableArray alloc] init];
    _secondArr = [[NSMutableArray alloc] init];
    _thirdArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < fa.count; i++) {
        MySettingModel *model = [[MySettingModel alloc] init];
        model.title = fa[i];
        model.shouldShowArrow = YES;
        [_firstArr addObject:model];
    }
    
    for (int i = 0; i < sa.count; i ++) {
        MySettingModel *model = [[MySettingModel alloc] init];
        model.title = sa[i];
        model.shouldShowArrow = YES;
        if (i == 1) {
            model.shouldShowArrow = NO;
        }
        [_secondArr addObject:model];
    }
    
    
    for (int i = 0; i < ta.count; i ++) {
        MySettingModel *model = [[MySettingModel alloc] init];
        model.title = ta[i];
        model.shouldShowArrow = YES;
        [_thirdArr addObject:model];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    [self uiConfig];
}
- (void)uiConfig {
    [self firstViewConfig];
    [self quitLoginBtn];
}
- (void)quitLoginBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, kScreenHeight - kNavigationBarMaxY - 80, kScreenWidth - 60, 50);
    btn.backgroundColor = [UIColor colorWithRed:0.16 green:0.82 blue:0.88 alpha:1];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"退出当前登录账号" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(quitLoginBtnClick) forControlEvents:64];
    [self.view addSubview:btn];

}
- (void)firstViewConfig {
    CGFloat topY = 0.0;
    for (int i = 0; i < _firstArr.count; i++) {
        SettingView *view = [[SettingView alloc] initWithFrame:CGRectMake(0, (_viewH + 1) * i, kScreenWidth, _viewH)];
        view.backgroundColor = [UIColor colorWithRed:0.87 green:0.6 blue:0.67 alpha:1];
        view.model = _firstArr[i];
        view.tag = 400 + i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstViewTap:)]];
        [self.view addSubview:view];
        if (i == _firstArr.count - 1) {
            topY = CGRectGetMaxY(view.frame);
        }
        if (i != _firstArr.count - 1) {
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), kScreenWidth, 1)];
            lineV.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:lineV];
        }

    }
    [self secondViewConfig:topY + 15];
}
- (void)secondViewConfig:(CGFloat)frameY {
    CGFloat topY = 0.0;
    for (int i = 0; i < _secondArr.count; i++) {
        SettingView *view = [[SettingView alloc] initWithFrame:CGRectMake(0,frameY + (_viewH + 1) * i, kScreenWidth, _viewH)];
        view.backgroundColor = [UIColor colorWithRed:0.87 green:0.6 blue:0.67 alpha:1];
        view.model = _secondArr[i];
        view.tag = 410 + i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondViewTap:)]];
        [self.view addSubview:view];
        if (i == _secondArr.count - 1) {
            topY = CGRectGetMaxY(view.frame);
        }
        if (i != _secondArr.count - 1) {
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), kScreenWidth, 1)];
            lineV.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:lineV];
        }
    }
    [self thirdViewConfig:topY + 15];

}
- (void)thirdViewConfig:(CGFloat)frameY {
    for (int i = 0; i < _thirdArr.count; i++) {
        SettingView *view = [[SettingView alloc] initWithFrame:CGRectMake(0, frameY + (_viewH + 1) * i, kScreenWidth, _viewH)];
        view.backgroundColor = [UIColor colorWithRed:0.87 green:0.6 blue:0.67 alpha:1];
        view.model = _thirdArr[i];
        view.tag = 420 + i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdViewTap:)]];
        [self.view addSubview:view];
        if (i != _thirdArr.count - 1) {
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), kScreenWidth, 1)];
            lineV.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:lineV];
        }

    }

}


- (void)firstViewTap:(UIGestureRecognizer *)ges {
    NSInteger index = ges.view.tag - 400;
//    NSLog(@"%ld",index);
    if (index == 0) {
        ChangePSDVC *vc = [[ChangePSDVC alloc] init];
        vc.title = @"设置新密码";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)secondViewTap:(UIGestureRecognizer *)ges {
    NSInteger index = ges.view.tag - 410;
//    NSLog(@"%ld",index);
    if (index == 0) {
        NewMessageNoteVC *vc = [[NewMessageNoteVC alloc] init];
//        InfomationVC *vc = [[InfomationVC alloc] initWithNibName:@"InfomationVC" bundle:nil];
        vc.title = @"新消息通知";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 1) {
        NSLog(@"清除缓存");
    }

}

- (void)thirdViewTap:(UIGestureRecognizer *)ges {
    NSInteger index = ges.view.tag - 420;
//    NSLog(@"%ld",index);
    
        AboutUsVC *vc = [[AboutUsVC alloc] init];
        vc.title = @"关于我们";
    
    SpeakOutVC *svc = [[SpeakOutVC alloc] init];
    
    svc.title = @"吐槽";
    switch (index) {
        case 0: // 吐槽
            [self.navigationController pushViewController:svc animated:YES];
            break;
        case 1: // 服务条款
            
            break;
        case 2:// 使用帮助
            
            break;
        case 3:// 关于我们
             [self.navigationController pushViewController:vc animated:YES];
            break;
    
        default:
            break;
    }
}

- (void)quitLoginBtnClick {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"warming" message:@"您确定要退出登录吗" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
    

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:kHasLoginOrRegister];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
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
