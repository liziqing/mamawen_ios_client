//
//  LoginViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "LoginViewController.h"
//#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
//#import "AFHTTPRequestOperation.h"
#import "ViewController.h"
#import "LXXMPPManager.h"
#import "RegisterVC.h"
@interface LoginViewController ()
{    
    UITextField *_usernameTextField;
    UITextField *_passwordTextField;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    
    [self uiConfig];
}
- (void)uiConfig {
    
//    CGFloat lableX = 50;
    CGFloat h = iphone6? 50 : 40;
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, kScreenHeight / 5, kScreenWidth - 60, h)];
    _usernameTextField.layer.cornerRadius = 5;
    _usernameTextField.layer.masksToBounds = YES;
    _usernameTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    _usernameTextField.layer.borderWidth = 1;
    _usernameTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:_usernameTextField];
    _usernameTextField.placeholder = @"手机号";
    _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *leftUV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(_usernameTextField.frame))];
    UIImageView *ulv = [[UIImageView alloc] initWithFrame:CGRectMake(15, h / 3, h / 3 , h / 3)];
    ulv.image = [UIImage imageNamed:@"02_03"];
    [leftUV addSubview:ulv];
    _usernameTextField.leftView = leftUV;
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
   
    
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_usernameTextField.frame), CGRectGetMaxY(_usernameTextField.frame) + 10, CGRectGetWidth(_usernameTextField.frame), CGRectGetHeight(_usernameTextField.frame))];
    _passwordTextField.layer.cornerRadius = 5;
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    _passwordTextField.layer.borderWidth = 1;
    _passwordTextField.textColor = [UIColor whiteColor];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTextField];
    _passwordTextField.placeholder = @"密码";
    UIView *leftPV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(_passwordTextField.frame))];
    UIImageView *plv = [[UIImageView alloc] initWithFrame:CGRectMake(15, h / 3, h / 3, h / 3)];
    plv.image = [UIImage imageNamed:@"02_06"];
    [leftPV addSubview:plv];
    _passwordTextField.leftView = leftPV;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;

    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kCellPhone];
    NSString *psd   = [[NSUserDefaults standardUserDefaults] objectForKey:kPassWordIdentify];
    if (phone) {
        _usernameTextField.text = phone;
        _passwordTextField.text = psd;
    }
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_passwordTextField.frame) + 20, CGRectGetWidth(_passwordTextField.frame), CGRectGetHeight(_passwordTextField.frame));
    btn.backgroundColor = [UIColor colorWithRed:0.31 green:0.83 blue:0.68 alpha:1];
    [btn setTitle:@"登   陆" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(login) forControlEvents:64];
    [self.view addSubview:btn];
    
    
    UILabel *regist = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 40, kScreenHeight - 200, 80, 30)];
    regist.textColor = [UIColor whiteColor];
    regist.text = @"现在注册";
    regist.adjustsFontSizeToFitWidth = YES;
    regist.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:regist];
    regist.userInteractionEnabled = YES;
    [regist addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerNow)]];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(regist.frame), CGRectGetMaxY(regist.frame) + 2, CGRectGetWidth(regist.frame), 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
}
- (void)login {
    NSString *userName = _usernameTextField.text;
    NSString *passWord = _passwordTextField.text;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userName forKey:@"phoneNumber"];
    [dic setObject:passWord forKey:@"password"];
    [dic setObject:@(1) forKey:@"deviceType"];
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
//    [dic setObject:token == nil?@"xxxxxxxx":token forKey:@"deviceToken"];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    
    // 发起请求
    [manager POST:[kBaseURL stringByAppendingString:@"/user/login"] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([[dic[@"code"] stringValue] isEqualToString:@"0"] && [dic[@"message"] isEqualToString:@"success"]) {
            NSString *UName = [dic[@"user"] objectForKey:@"name"];
            NSString *UID   = [[dic[@"user"] objectForKey:@"userID"] stringValue];
            NSString *phone = [dic[@"user"] objectForKey:@"cellPhone"];
            NSString *jid   = [dic[@"user"] objectForKey:@"jid"];
            NSString *xmpToken   = [dic[@"user"] objectForKey:@"xmpToken"];
            NSString *sessionKey   = [dic[@"user"] objectForKey:@"sessionKey"];
//            NSString *avatar   = [[dic[@"user"] objectForKey:@"avatar"] stringValue];
            [[NSUserDefaults standardUserDefaults] setObject:UName forKey:kUserNameIdentify];
            [[NSUserDefaults standardUserDefaults] setObject:UID forKey:kUserID];
            [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:kPassWordIdentify];
            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:kCellPhone];
            [[NSUserDefaults standardUserDefaults] setObject:jid forKey:kUserJid];
            [[NSUserDefaults standardUserDefaults] setObject:xmpToken forKey:kXmmpToken];
            [[NSUserDefaults standardUserDefaults] setObject:sessionKey forKey:kSessionKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ViewController *vc = [[ViewController alloc] init]; // 登陆成功   连接im服务器--登陆
            vc.myJid = [NSString stringWithFormat:@"%@@%@",[[(NSDictionary *)responseObject objectForKey:@"user"] objectForKey:@"jid"],kIMIP];
            vc.password = xmpToken;
       
            [[LXXMPPManager shareXMPPManager] offlineWithXMPP];  // 多个账号切换登陆时   需先与xmpp
                                                                 // 的连接断开才能进行下一个连接
            [vc loginOpenfire];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kHasLoginOrRegister];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"登陆失败" leftbtn:@"返回" rightBtn:nil];
    }];
}
- (void)registerNow {
    RegisterVC *vc = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
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
