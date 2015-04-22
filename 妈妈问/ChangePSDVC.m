//
//  ChangePSDVC.m
//  妈妈问
//
//  Created by kin on 15/4/21.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "ChangePSDVC.h"

@interface ChangePSDVC ()
{
    UITextField *_firTF;
    UITextField *_secTF;
    UITextField *_thdTF;
}
@end

@implementation ChangePSDVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setRightNavigationItemWithTitle:@"7_03" isImage:YES];
    [self uiConfig];
}
- (void)rightBarButtonItemclick {
    if (!_secTF.text || !_thdTF.text || !([_secTF.text isEqual: _thdTF.text])) {
//        NSLog(@"%d--%d--%@-",!_secTF.text,!_thdTF.text,[_secTF.text isEqual:_thdTF.text]);
        [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"两次输入的新密码不一致，请再次确认" leftbtn:@"OK" rightBtn:nil];
        return;
    } else if (!_firTF.text) { // 判断初始密码
    [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"原密码输入有误" leftbtn:@"OK" rightBtn:nil];
        return;
    }
    NSLog(@"修改成功%@",_firTF.text);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)uiConfig {
    CGFloat h = iphone6? 60 : 50;

    UIView *lfv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, h)];
    _firTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    _firTF.placeholder = @"原密码";
    _firTF.leftView = lfv;
    _firTF.leftViewMode = UITextFieldViewModeAlways;
    _firTF.clearsOnBeginEditing = YES;
    _firTF.textColor = [UIColor whiteColor];
    _firTF.backgroundColor = [UIColor colorWithRed:0.83 green:0.54 blue:0.59 alpha:1];
    [self.view addSubview:_firTF];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_firTF.frame), kScreenWidth, 1)];
    line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line1];

    
    
    UIView *lfv2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, h)];

    _secTF = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_firTF.frame) + 1, kScreenWidth, h)];
    _secTF.placeholder = @"新密码";
    _secTF.leftView = lfv2;
    _secTF.leftViewMode = UITextFieldViewModeAlways;
    _secTF.clearsOnBeginEditing = YES;
    _secTF.textColor = [UIColor whiteColor];
    _secTF.backgroundColor = [UIColor colorWithRed:0.83 green:0.54 blue:0.59 alpha:1];
    [self.view addSubview:_secTF];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_secTF.frame), kScreenWidth, 1)];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];
    
    
    
    UIView *lfv3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, h)];

    _thdTF = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_secTF.frame) + 1, kScreenWidth, h)];
    _thdTF.placeholder = @"再次确认新密码";
    _thdTF.leftView = lfv3;
    _thdTF.leftViewMode = UITextFieldViewModeAlways;
    _thdTF.clearsOnBeginEditing = YES;
    _thdTF.textColor = [UIColor whiteColor];
    _thdTF.backgroundColor = [UIColor colorWithRed:0.83 green:0.54 blue:0.59 alpha:1];
    [self.view addSubview:_thdTF];

    
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
