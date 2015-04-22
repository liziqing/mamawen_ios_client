//
//  AboutUsVC.m
//  妈妈问
//
//  Created by kin on 15/4/21.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
{
    NSString *_name;
    NSString *_version;
    NSString *_build;
    
    NSString *_phone;
}
@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phone = @"10086";
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
//    NSLog(@"%@",info);
    // app名称
    _name = [info objectForKey:@"CFBundleDisplayName"];
    // app版本
    _version = [info objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    _build = [info objectForKey:@"CFBundleVersion"];
    
    
    if (_name == nil || [_name isEqual:[NSNull null]]) {
        _name = @"妈妈问";
    }
    [self uiConfig];
}
- (void)uiConfig {
    CGFloat iconh = iphone6? 120 : 80;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - iconh / 2, 40, iconh, iconh)];
    icon.image = [UIImage imageNamed:@"18_03"];
    [self.view addSubview:icon];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame) + 15, kScreenWidth, 20)];
    name.textColor  = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont systemFontOfSize:16];
    name.text = [NSString stringWithFormat:@"%@  %@",_name,_version];
    [self.view addSubview:name];
    
    CGFloat w = iphone6? 100 : 80;
    CGFloat spacing = 15;
    
    UIImageView *good = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - spacing - w, CGRectGetMaxY(name.frame) + w / 2, w, w)];
    good.image = [UIImage imageNamed:@"18_07"];
    [good setUserInteractionEnabled:YES];
    [good addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(good)]];
    [self.view addSubview:good];
    
    UIImageView *bad = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x + spacing , CGRectGetMinY(good.frame), w, w)];
    bad.image = [UIImage imageNamed:@"18_09"];
    bad.userInteractionEnabled = YES;
    [bad addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bad)]];
    [self.view addSubview:bad];
    
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(good.frame) + w  * 2 / 3, kScreenWidth, iphone6? 50 : 40)];
    phone.text = [NSString stringWithFormat: @"      客服电话  %@",_phone ];
    phone.textColor = [UIColor whiteColor];
    phone.font = [UIFont systemFontOfSize:iphone6 ? 18 : 16];
    phone.userInteractionEnabled = YES;
    [phone addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCall)]];
    phone.backgroundColor = [UIColor colorWithRed:0.9 green:0.62 blue:0.72 alpha:1];
    [self.view addSubview:phone];
    
    UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarMaxY - 40, kScreenWidth, 40)];
    right.textColor = [UIColor whiteColor];
    right.font = [UIFont systemFontOfSize:iphone6? 14 : 12];
    right.textAlignment = NSTextAlignmentCenter;
    right.text = @"Copyright@2015 YIYA.All Rights Reserved";
    [self.view addSubview:right];
}
- (void)good {
    NSLog(@"赞");
}
- (void)bad {
    NSLog(@"损");

}
- (void)phoneCall {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel://%@" ,_phone]]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self hiddenTabbar:YES];
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
