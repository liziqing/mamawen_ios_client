//
//  AddPatientINfoViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "AddPatientINfoViewController.h"

@interface AddPatientINfoViewController () <UIAlertViewDelegate>
{
    NSArray *_titles;
    UITextField *_nameTF;
    UITextField *_sexTF;
    UITextField *_bornTF;
    UITextField *_categoryTF;
    
}
@end

@implementation AddPatientINfoViewController
- (void)rightBarButtonItemclick {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除当前患者" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kAddPatientInfo];
        NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (_reEditModel != nil) {
            [dd removeObjectForKey:_reEditModel.name];
        }
    
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAddPatientInfo];
        [[NSUserDefaults standardUserDefaults] setObject:dd forKey:kAddPatientInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"姓名",@"性别",@"出生日期",@"科室"];
    [self setRightNavigationItemWithTitle:@"删除" isImage:NO];
    [self uiConfig];
}
- (void)uiConfig {
    
    BOOL isAdd = _reEditModel == nil;
    CGFloat spaceWidth = 15;

    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 60, kScreenWidth - 60, iphone6?40:30)];
    _nameTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _nameTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _nameTF.layer.borderWidth = 1;
    [self.view addSubview:_nameTF];
    
    _sexTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameTF.frame), CGRectGetMaxY(_nameTF.frame) + spaceWidth, CGRectGetWidth(_nameTF.frame), CGRectGetHeight(_nameTF.frame))];
    _sexTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _sexTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _sexTF.layer.borderWidth = 1;

    [self.view addSubview:_sexTF];

    
    _bornTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameTF.frame), CGRectGetMaxY(_sexTF.frame) + spaceWidth, CGRectGetWidth(_nameTF.frame), CGRectGetHeight(_nameTF.frame))];
    _bornTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _bornTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _bornTF.layer.borderWidth = 1;

    [self.view addSubview:_bornTF];

    
    _categoryTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameTF.frame), CGRectGetMaxY(_bornTF.frame) + spaceWidth, CGRectGetWidth(_nameTF.frame), CGRectGetHeight(_nameTF.frame))];
    _categoryTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _categoryTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _categoryTF.layer.borderWidth = 1;
_categoryTF.text = @"儿科";
    [self.view addSubview:_categoryTF];

    
    if (isAdd) {
        _nameTF.placeholder         = _titles[0];
        _sexTF.placeholder          = _titles[1];
        _bornTF.placeholder         = _titles[2];
        _categoryTF.placeholder     = _titles[3];
    } else {
        _nameTF.text        = _reEditModel.name;
        _sexTF.text         = _reEditModel.sex;
        _bornTF.text        = _reEditModel.age;
        _categoryTF.text    = _reEditModel.category;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40, CGRectGetMaxY(_categoryTF.frame) + 50, kScreenWidth - 80, 40);
    [btn setTitle:@"确认添加" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:0.31 green:0.83 blue:0.68 alpha:1];
    [btn addTarget:self action:@selector(sureCilck) forControlEvents:64];
    [self.view addSubview:btn];
}
- (void)sureCilck {
    NSDictionary *newDic = @{@"sex":_sexTF.text,@"born":_bornTF.text,@"category":_categoryTF.text};
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kAddPatientInfo];
    NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (NSString *key in [dd allKeys]) {
        if ([key isEqualToString:_nameTF.text]) {
            [dd removeObjectForKey:key];
        }
    }
    
    if (_reEditModel != nil) {
        [dd removeObjectForKey:_reEditModel.name];
    }
    
    [dd setObject:newDic forKey:_nameTF.text];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAddPatientInfo];
    [[NSUserDefaults standardUserDefaults] setObject:dd forKey:kAddPatientInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
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
