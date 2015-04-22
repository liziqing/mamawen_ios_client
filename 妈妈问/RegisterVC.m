//
//  RegisterVC.m
//  妈妈问
//
//  Created by kin on 15/4/8.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "RegisterVC.h"
#import "FirstLonginViewController.h"
#import "UserInfoOfRegisterVC.h"
@interface RegisterVC () <UITextFieldDelegate>
{
    UITextField *_phoneTF;
    UITextField *_psdTF;
    UITextField *_levelTF;
    UITextField *_authTF;
    
    
    UIView *_levelV;
    CGFloat _lvh;
    NSArray *_levelsArr;
}
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    self.title = @"注册";
    [self uiConfig];
}
- (void)uiConfig {
    CGFloat spaceWidth = 15;
    CGFloat h = iphone6? 50 : 40;
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, kScreenWidth - 40, iphone6?60 : 40)];
//    _phoneTF.leftView =
//    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _phoneTF.layer.borderWidth = 1;
    _phoneTF.placeholder = @"手机号";
    _phoneTF.delegate = self;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTF.font = [UIFont systemFontOfSize:iphone6? 16 : 14];
    _phoneTF.textColor = [UIColor whiteColor];
    [self.view addSubview:_phoneTF];
    UIView *leftPV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(_phoneTF.frame))];
    UIImageView *plv = [[UIImageView alloc] initWithFrame:CGRectMake(15, h / 3, h / 3, h / 3)];
    plv.image = [UIImage imageNamed:@"02_03"];
    [leftPV addSubview:plv];
    _phoneTF.leftView = leftPV;
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;

    
    _psdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_phoneTF.frame) + spaceWidth, CGRectGetWidth(_phoneTF.frame), CGRectGetHeight(_phoneTF.frame))];
    _psdTF.placeholder = @"密码";
    _psdTF.secureTextEntry = YES;
    _psdTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _psdTF.layer.borderWidth = 1;
    _psdTF.delegate = self;
    _psdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _psdTF.font = [UIFont systemFontOfSize:iphone6? 16 : 14];
    [self.view addSubview:_psdTF];
    [self.view addSubview:_phoneTF];
    UIView *leftPSV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(_psdTF.frame))];
    UIImageView *pslv = [[UIImageView alloc] initWithFrame:CGRectMake(15, h / 3, h / 3, h / 3)];
    pslv.image = [UIImage imageNamed:@"02_06"];
    [leftPSV addSubview:pslv];
    _psdTF.leftView = leftPSV;
    _psdTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    _levelTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_psdTF.frame), CGRectGetMaxY(_psdTF.frame) + spaceWidth, CGRectGetWidth(_psdTF.frame), CGRectGetHeight(_psdTF.frame))];
    _levelTF.placeholder = @"现状阶段";
    _levelTF.font = [UIFont systemFontOfSize:iphone6? 16 : 14];
    _levelTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _levelTF.layer.borderWidth = 1;
    _levelTF.delegate = self;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"xiaIcon"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, _levelTF.frame.size.height, _levelTF.frame.size.height);
    CGFloat r = iphone6? 20 : 10;
    btn.imageEdgeInsets = UIEdgeInsetsMake(r, r, r, r);
    CGFloat w = iphone6? 25 : 15;
    btn.center = CGPointMake(_levelTF.frame.size.width - w, _levelTF.frame.size.height / 2);
    [btn addTarget:self action:@selector(levelBtnClick) forControlEvents:64];
    btn.tintColor = [UIColor blueColor];
    _levelTF.rightView = btn;
    _levelTF.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_levelTF];
    UIView *leftLSV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(_levelTF.frame))];
    UIImageView *llv = [[UIImageView alloc] initWithFrame:CGRectMake(15, h / 3, h / 3, h / 3)];
    llv.image = [UIImage imageNamed:@"02_08"];
    [leftLSV addSubview:llv];
    _levelTF.leftView = leftLSV;
    _levelTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    _authTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_psdTF.frame), CGRectGetMaxY(_levelTF.frame) + spaceWidth, CGRectGetWidth(_psdTF.frame) * 2 / 3 - 5, CGRectGetHeight(_psdTF.frame))];
    _authTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _authTF.font = [UIFont systemFontOfSize:iphone6? 16 : 14];
    _authTF.layer.borderWidth = 1;
    _authTF.placeholder = @"验证码";
    _authTF.delegate = self;
    [self.view addSubview:_authTF];
    UIView *leftASV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(_authTF.frame))];
    UIImageView *alv = [[UIImageView alloc] initWithFrame:CGRectMake(15, h / 3, h / 3, h / 3)];
    alv.image = [UIImage imageNamed:@"02_06"];
    [leftASV addSubview:alv];
    _authTF.leftView = leftASV;
    _authTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    UIButton *authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    authBtn.frame = CGRectMake(CGRectGetMaxX(_authTF.frame) + 5, CGRectGetMinY(_authTF.frame), CGRectGetWidth(_levelTF.frame) - CGRectGetWidth(_authTF.frame) - 5, CGRectGetHeight(_authTF.frame));
    authBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    authBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    authBtn.layer.borderWidth = 1;
    [authBtn setTitle:@" 点击获取验证码 " forState:UIControlStateNormal];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authBtn setBackgroundColor:[UIColor colorWithRed:0.87 green:0.53 blue:0.64 alpha:1]];
    [authBtn addTarget:self action:@selector(authenBtnClick) forControlEvents:64];
    [self.view addSubview:authBtn];
    
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(CGRectGetMinX(_authTF.frame), CGRectGetMaxY(_authTF.frame) + spaceWidth * 4, CGRectGetWidth(_phoneTF.frame), CGRectGetHeight(_phoneTF.frame));
    registerBtn.backgroundColor = [UIColor colorWithRed:0.31 green:0.83 blue:0.68 alpha:1];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注  册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerbtnClick) forControlEvents:64];
    [self.view addSubview:registerBtn];
    
    _levelV = [[UIView alloc] init];
    _levelV.backgroundColor = [UIColor cyanColor];
    _levelsArr = @[@"备孕",@"怀孕",@"育儿"];
    for (int i = 0; i < _levelsArr.count; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 * i, CGRectGetWidth(_levelTF.frame), 20)];
        lable.text = _levelsArr[i];
        lable.textColor = [UIColor whiteColor];
        lable.userInteractionEnabled = YES;
        [lable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedLable:)]];
        [_levelV addSubview:lable];
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lable.frame), CGRectGetMaxY(lable.frame), CGRectGetWidth(lable.frame), 1)];
        lineV.backgroundColor = [UIColor whiteColor];
        [_levelV addSubview:lineV];
        if (i == (_levelsArr.count - 1)) {
            _lvh = lable.frame.size.height * _levelsArr.count + 2;
        }
    }
}
- (void)selectedLable:(UIGestureRecognizer *)ges {
        _levelTF.text = [(UILabel *)ges.view text];
    [_levelV removeFromSuperview];
}
- (void)levelBtnClick {
    [self textFieldShouldBeginEditing:_levelTF];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField != _levelTF) {
        if (_levelV.superview) {
            [_levelV removeFromSuperview];
        }
        return YES;
    }
    [self.view endEditing:YES];
    _levelV.frame = CGRectMake(CGRectGetMinX(_levelTF.frame), CGRectGetMaxY(_levelTF.frame), CGRectGetWidth(_levelTF.frame), _lvh);
    [self.view addSubview:_levelV];

    
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
- (void)authenBtnClick {
    NSLog(@"send authen num");

}
- (void)registerbtnClick {

    UserInfoOfRegisterVC *vc = [[UserInfoOfRegisterVC alloc] init];
    vc.index =  [_levelsArr indexOfObject:  _levelTF.text ];
    if (vc.index >2 || vc.index < 0) {
        [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"请完善个人信息" leftbtn:@"sure" rightBtn:nil];
        return;
    }
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
