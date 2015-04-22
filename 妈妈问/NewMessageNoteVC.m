//
//  NewMessageNoteVC.m
//  妈妈问
//
//  Created by kin on 15/4/21.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "NewMessageNoteVC.h"
#import "AppDelegate.h"
@interface NewMessageNoteVC ()
{
    CGFloat _h; // 每个cell View的高度
   BOOL _isOpenNewMessageNote;
   BOOL _isOpenNewMessageNoteDetail;
   BOOL _isOpenSound;
   BOOL _isOpenVibrate;

    UISwitch *_swh1;
    UISwitch *_swh2;
    UISwitch *_swh3;
    UISwitch *_swh4;
}
@end

@implementation NewMessageNoteVC
- (void)authenBoolNum {
   AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _isOpenNewMessageNote = delegate.isOpenNewMessageNote;
    _isOpenNewMessageNoteDetail = delegate.isOpenNewMessageNoteDetail;
    _isOpenSound = delegate.isOpenSound;
    _isOpenVibrate = delegate.isOpenVibrate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self authenBoolNum];
    [self uiConfig];
}

- (void)crecteViewWithSwitch:(UISwitch *)swith lableText:(NSString *)lableText noteLableHeight:(CGFloat)lableHeight noteLableText:(NSString *)noteText startY:(CGFloat)pointY {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, pointY, kScreenWidth, _h)];
    view.backgroundColor = [UIColor colorWithRed:0.82 green:0.54 blue:0.59 alpha:1];
    [self.view addSubview:view];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, _h/2 - 10, kScreenWidth / 2, 20)];
    lable.text = lableText;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:16];
    lable.adjustsFontSizeToFitWidth = YES;
    [view addSubview:lable];
    
    
    swith.frame = CGRectMake(kScreenWidth - 70, _h / 4, 40, _h / 2);
    [swith addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:swith];
    
    if (!noteText || lableHeight == 0) {
        return;
    }
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(view.frame), kScreenWidth - 60, lableHeight)];
    lable1.text = noteText;
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = [UIColor whiteColor];
    lable1.numberOfLines = 0;
    [self.view addSubview:lable1];
    
}

- (void)uiConfig {
    _h = iphone6? 60 : 50;

    _swh1 = [[UISwitch alloc] init];
    _swh2 = [[UISwitch alloc] init];
    _swh3 = [[UISwitch alloc] init];
    _swh4 = [[UISwitch alloc] init];
    
    _swh1.tag = 130;
    _swh2.tag = 131;
    _swh3.tag = 132;
    _swh4.tag = 133;
    
    _swh1.on = _isOpenNewMessageNote;
    _swh2.on = _isOpenNewMessageNoteDetail;
    _swh3.on = _isOpenSound;
    _swh4.on = _isOpenVibrate;
    

    [self crecteViewWithSwitch:_swh1 lableText:@"新消息通知" noteLableHeight:_h * 2 noteLableText:@"如果你要关闭或开启应用的新消息通知，请在iPhone的“设置” - “通知” 功能中，找到应用程序 “妈妈问” 进行更改。" startY:0];
    [self crecteViewWithSwitch:_swh2 lableText:@"通知显示消息详情" noteLableHeight:_h * 3 / 2 noteLableText:@"若关闭，当收到应用消息时，通知提示将不显示发言人和内容摘要。" startY:_h * 3];
    [self crecteViewWithSwitch:_swh3 lableText:@"声音" noteLableHeight:0 noteLableText:nil startY:_h * 5.5];
    [self crecteViewWithSwitch:_swh4 lableText:@"震动" noteLableHeight:_h noteLableText:@"当应用在运行时，您可以设置是否需要声音或者震动" startY:_h * 6.5 + 1];
    
}
- (void)switchValueChange:(UISwitch *)swh {
    NSInteger index = swh.tag - 130;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    switch (index) {
        case 0: //
            delegate.isOpenNewMessageNote = !delegate.isOpenNewMessageNote;
            NSLog(@"新消息通知");
            break;
        case 1:
            delegate.isOpenNewMessageNoteDetail = !delegate.isOpenNewMessageNoteDetail;
            NSLog(@"通知详情");
            break;
        case 2:
            delegate.isOpenSound = !delegate.isOpenSound;
            NSLog(@"声音");
            break;
        case 3:
            delegate.isOpenVibrate = !delegate.isOpenVibrate;
            NSLog(@"震动");
            break;
            
        default:
            break;
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [self hiddenTabbar:YES];
}



@end
