//
//  ThanksDrVC.m
//  妈妈问
//
//  Created by kin on 15/4/16.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "ThanksDrVC.h"
#import "HHTextView.h"
@interface ThanksDrVC () <UITextViewDelegate>
{
    UIView *_drInfoView;
    UIView *_evaluateView;
    HHTextView *_textView;
}
@end

@implementation ThanksDrVC

- (void)prepareData {


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"感谢医生";
    
    [self prepareData];
    [self uiConfig];
}
- (void)uiConfig {
    [self doctorInfo];
    [self evaluate];
    [self updateButton];
}
- (void)doctorInfo {
    _drInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _drInfoView.backgroundColor = [UIColor colorWithRed:0.83 green:0.56 blue:0.6 alpha:1];
    [self.view addSubview:_drInfoView];
    
    CGFloat w = 50;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(30, _drInfoView.frame.size.height / 2 - w / 2, w, w)];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = w / 2;
    icon.backgroundColor = [UIColor lightGrayColor];
    [_drInfoView addSubview:icon];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 10, CGRectGetMinY(icon.frame) , w, 20)];
    name.text = @"黄华";
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont systemFontOfSize:iphone6?18 : 16];
    [_drInfoView addSubview:name];
    
    UILabel *category = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame) + 10, CGRectGetMinY(name.frame) + 5, w * 2, 15)];
    category.text = @"主任医师";
    category.textColor = [UIColor whiteColor];
    category.font = [UIFont systemFontOfSize:iphone6? 15:13];
    [_drInfoView addSubview:category];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMaxY(name.frame) + 3, CGRectGetMaxX(category.frame) - CGRectGetMinX(name.frame), 1)];
    line.backgroundColor = [UIColor whiteColor];
    [_drInfoView addSubview:line];
    
    UILabel *hospital = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMaxY(line.frame) + 3,  CGRectGetWidth(line.frame), 15)];
    hospital.textColor = [UIColor whiteColor];
    hospital.font = [UIFont systemFontOfSize:iphone6?15:13];
    hospital.text = @"上海交通大学附属医院";
    [_drInfoView addSubview:hospital];

}
- (void)evaluate {
    _evaluateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_drInfoView.frame) + 10, kScreenWidth, kScreenHeight / 2)];
    _evaluateView.backgroundColor = [UIColor colorWithRed:0.83 green:0.56 blue:0.6 alpha:1];
    [self.view addSubview:_evaluateView];
    
    CGFloat w = kScreenWidth - 70;
    UILabel *attitude = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 70, 20)];
    attitude.text = @"服务态度";
    attitude.font = [UIFont systemFontOfSize:iphone6?18:16];
    attitude.textColor = [UIColor whiteColor];
    [_evaluateView addSubview:attitude];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(attitude.frame), CGRectGetMaxY(attitude.frame) + 15, w, 1)];
    line1.backgroundColor = [UIColor whiteColor];
    [_evaluateView addSubview:line1];
    
    UILabel *userful = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(attitude.frame), CGRectGetMaxY(line1.frame) + 15, 70, 20)];
    userful.textColor = [UIColor whiteColor];
    userful.font = [UIFont systemFontOfSize:iphone6?18:16];
    userful.text = @"是否有用";
    [_evaluateView addSubview:userful];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(line1.frame), CGRectGetMaxY(userful.frame) + 15, w, 1)];
    line2.backgroundColor = [UIColor whiteColor];
    [_evaluateView addSubview:line2];
    
    
    _textView = [[HHTextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(line2.frame), CGRectGetMaxY(line2.frame) + 15, w, _evaluateView.frame.size.height - CGRectGetMaxY(line2.frame) - 30)];
    _textView.delegate = self;
    _textView.placeHolder = @"还有什么要对我说的";
    [_evaluateView addSubview:_textView];
    
}
- (void)updateButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, kScreenHeight - kNavigationBarMaxY - 64, kScreenWidth - 70, 40);
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(updateClick) forControlEvents:64];
    [btn setBackgroundColor:[UIColor colorWithRed:0.18 green:1 blue:1 alpha:1]];
    [self.view addSubview:btn];
}
- (void)updateClick {
// 上传
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}
@end
