//
//  SpeakOutVC.m
//  妈妈问
//
//  Created by kin on 15/4/22.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "SpeakOutVC.h"

@interface SpeakOutVC ()
{

    UITextView *_textView;
}
@end

@implementation SpeakOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    
}
- (void)uiConfig {
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight   * 2 / 5)];
    backV.backgroundColor = [UIColor colorWithRed:0.83 green:0.53 blue:0.59 alpha:1];
    [self.view addSubview:backV];
    
    
    UILabel *note = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, kScreenWidth - 60, 20)];
    note.textColor = [UIColor whiteColor];
    note.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
    note.text = @"我们懂得聆听，知错就改，在下面留下您的意见";
    note.adjustsFontSizeToFitWidth = YES;
    [backV addSubview:note];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(note.frame) + 10, CGRectGetWidth(note.frame), CGRectGetHeight(backV.frame) - CGRectGetMaxY(note.frame) - 10 - 20)];
    _textView.backgroundColor = [UIColor colorWithRed:0.9 green:0.71 blue:0.77 alpha:1];
    [backV addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
    _textView.textColor = [UIColor whiteColor];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, CGRectGetMaxY(backV.frame) + 30, kScreenWidth - 60, 40);
    btn.backgroundColor = [UIColor colorWithRed:0.16 green:0.82 blue:0.88 alpha:1];
    [btn  setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(updateBtnClick) forControlEvents:64];
    btn.layer.cornerRadius = 5;
//    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
}
- (void)updateBtnClick {
    if (_textView.text.length == 0 || !_textView.text) {
        return;
    }
    NSLog(@"提交成功");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}


@end
