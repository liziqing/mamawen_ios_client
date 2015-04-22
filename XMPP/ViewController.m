//
//  ViewController.m
//  chatdemo
//
//  Created by lixuan on 15/2/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "ViewController.h"
#import "LXXMPPManager.h"
#import "FriendListViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)userNameAndPassword {
    if (_userNAmeTextfield.text != nil && _userNAmeTextfield.text.length > 6 && _passwordTextfield.text != nil && _passwordTextfield.text.length > 6) {
        _myJid = _userNAmeTextfield.text;
        _password = _passwordTextfield.text;
    }
    
    else if(!_myJid || !_password){
        _myJid = [NSString stringWithFormat:@"%@@182.254.222.156",[[NSUserDefaults standardUserDefaults] objectForKey:kUserJid]];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:kXmmpToken];
//        _myJid = @"test6@182.254.222.156";
//        _password = @"123456";
    }
}
- (void)loginOpenfire {
    [self userNameAndPassword];
    [self registerAction];
    [self loginAction];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self uiConfig];
}
- (void)uiConfig {
//    _userNAmeTextfield.text = @"demoChat@127.0.0.1"; // 测试账号
//    _passwordTextfield.text = @"123456";
    [self userNameAndPassword];
    _passwordTextfield.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)registerAction {
    // 注册 -- 初始化
    [[LXXMPPManager shareXMPPManager]
     registerUser:_myJid
     withPassword:_password
     withCompletion:^(BOOL ret, NSError *error) {
         if (YES == ret) {
             NSLog(@"注册成功");
         }
         else {
             NSLog(@"注册失败 error = %@",error);
         }
     }];
}
- (void)loginAction {
    [[LXXMPPManager shareXMPPManager]
     loginUser:_myJid
     withPassword:_password
     withCompletion:^(BOOL ret, NSError *error) {
         if (YES == ret) {
             NSLog(@"登陆成功!!!");
//             FriendListViewController *fvc = [[FriendListViewController alloc] init];
//             UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:fvc];
//             [self presentViewController:navi animated:YES completion:nil];
         }
         else {
             NSLog(@"登陆失败 error = %@",error);
         }
     }];

}
- (void)offLine {
    [[LXXMPPManager shareXMPPManager] offlineWithXMPP];
}

+ (void)loginOpenfire {
    ViewController *vc = [[ViewController alloc] init];
    [vc loginOpenfire];
}
+ (void)offLine {
    ViewController *vc = [[ViewController alloc] init];
    [vc offLine];
}
+ (void)reconnect {
    NSString *jid = [NSString stringWithFormat:@"%@@182.254.222.156",[[NSUserDefaults standardUserDefaults] objectForKey:kUserJid]];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kXmmpToken];
    
    
    [[LXXMPPManager shareXMPPManager]
     loginUser:jid
     withPassword:pwd
     withCompletion:^(BOOL ret, NSError *error) {
         if (YES == ret) {
             NSLog(@"reconnect成功!!!");
             //             FriendListViewController *fvc = [[FriendListViewController alloc] init];
             //             UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:fvc];
             //             [self presentViewController:navi animated:YES completion:nil];
         }
         else {
             NSLog(@"reconnect失败 error = %@",error);
         }
     }];
    
    XMPPJID *myJID = [XMPPJID jidWithString:jid];
    
//    if ([_xmppStream isConnecting]) {
//        [_xmppStream disconnect];
//    }
//    [_xmppStream setMyJID:myJID];
////    NSError *err = nil;
//    BOOL ret = [_xmppStream connectWithTimeout:-1 error:&err];


}
- (IBAction)registerClick:(UIButton *)sender {
    [self registerAction];
}


- (IBAction)loginClick:(UIButton *)sender {
    [self loginAction];
}
@end
/*
 - (NSUInteger)DaysAgainstDate:(NSString*)againstDate
 {
 NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
 [mdf setDateFormat:@"yyyyMMdd"];
 NSDate *againstMidnightDate = [mdf dateFromString:againstDate];
 NSTimeInterval difftime = [againstMidnightDate timeIntervalSinceNow];
 ／／与今天的时间差
 difftime = (-difftime) / (60*60*24);
 
 return difftime;
 }
 */