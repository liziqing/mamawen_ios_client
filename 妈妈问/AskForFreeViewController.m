//
//  AskForFreeViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "AskForFreeViewController.h"
//#import "addPatientTableViewCell.h"
#import "AddPatientINfoViewController.h"
#import "ProblemViewController.h"
#import "PatientInfoView.h"
@interface AskForFreeViewController ()
{
    UIScrollView *_scroll;
    CGFloat _frameY;
}
@end

@implementation AskForFreeViewController

- (void)prepareData {
    _dataArr = [[NSMutableArray alloc] init];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kAddPatientInfo];
    for (NSString *key in [dic allKeys]) {
        PatientInfoModel *pm = [[PatientInfoModel alloc] init];
        pm.name = key;
        pm.age  = [[dic objectForKey:key] objectForKey:@"born"];
        pm.sex  = [[dic objectForKey:key] objectForKey:@"sex"];
        pm.category = [[dic objectForKey:key] objectForKey:@"category"];
        [_dataArr addObject:pm];
    }
//    for (int i = 0; i < 3; i ++) {
//        PatientInfoModel *model = [[PatientInfoModel alloc] init];
//        model.name = [NSString stringWithFormat:@"张%d",i];
//        model.age  = [NSString stringWithFormat:@"%d",arc4random_uniform(30)];
//        model.sex  = arc4random_uniform(2)?@"男":@"女";
//        model.lastTime = [NSString stringWithFormat:@"%d天",arc4random_uniform(300)];
//        model.category = 0==i? @"妇科":@"儿科";
//        [_dataArr addObject:model];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNexttapBtn];
    
    [self prepareData];
    [self createAddPatientBtn];
}
- (void)createNexttapBtn {
    [self setRightNavigationItemWithTitle:@"下一步" isImage:NO];
}
- (void)rightBarButtonItemclick {
    
    for (id obj in _scroll.subviews) {
        if ([obj isKindOfClass:[PatientInfoView class]]) {
            if (YES == [(PatientInfoView *)obj isSlected]) {
               NSInteger tag = [(PatientInfoView *)obj tag];
                NSInteger index = tag - 122;
                
                
                ProblemViewController *vc = [[ProblemViewController alloc] init];
                vc.title = @"问题概述";
                vc.model = _dataArr[index];
                vc.isFindDr = _isFindDr;
                vc.doctorID = _doctorID;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)createAddPatientBtn {
    CGFloat w = kScreenHeight / 5;
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(self.view.center.x - w / 2, w / 3, w, w);
    addBtn.layer.cornerRadius = w / 2;
    addBtn.layer.masksToBounds = YES;
//    addBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    addBtn.layer.borderWidth = 1;
    [addBtn setImage:[UIImage imageNamed:@"04_10"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addPatientBtnClick:) forControlEvents:64];
    [self.view addSubview:addBtn];
    
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addBtn.frame) + w / 3 - 20, kScreenWidth, 20)];
    bv.backgroundColor = [UIColor colorWithRed:0.89 green:0.63 blue:0.71 alpha:1];
    [self.view addSubview:bv];
    
    
     _frameY = CGRectGetMaxY(addBtn.frame) + w / 3;
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _frameY, kScreenWidth, kScreenHeight - _frameY - 60 - 60)];
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_scroll];
   
    [self createPatientViewsWithTopY:_frameY];
    [self createNoticeLable];
    
}
- (void)createNoticeLable {
    UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(_scroll.frame), kScreenWidth - 100, 20)];
    notice.text = @"为了医生能够更好,更快地为您预诊,请添加患者信息。";
    notice.textColor = [UIColor whiteColor];
    notice.font = [UIFont systemFontOfSize:14];
    notice.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:notice];

    UIImageView *warm = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(notice.frame) - 30, notice.center.y - 10, 20, 20)];
    warm.layer.cornerRadius = 10;
    warm.layer.masksToBounds = YES;
    warm.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:warm];
}
- (void)createPatientViewsWithTopY:(CGFloat)frameY {
   
    for (UIView *vv in _scroll.subviews) {
        [vv removeFromSuperview];
    }
    
    CGFloat h = 60;
    for (int i = 0; i < _dataArr.count; i ++) {
        PatientInfoModel *pm = _dataArr[i];
        PatientInfoView *view = [[PatientInfoView alloc] initWithFrame:CGRectMake(20, (h + 1) * i, kScreenWidth - 40, h)];
        view.backgroundColor = [UIColor clearColor];
        view.model = pm;
        view.tag = 122 + i;
        
        [view setEditCallBack:^{
            AddPatientINfoViewController *vc = [[AddPatientINfoViewController alloc] init];
                                vc.title = @"患者信息";
                                vc.reEditModel = pm;
                                [self.navigationController pushViewController:vc animated:YES];
        }];
        __block PatientInfoView *weakView = view;
        [view setSelectedCB:^{
            [self setPatientViewSelected:weakView];
        }];
        [_scroll addSubview:view];
        
        UIView *v= [[UIView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(view.frame), kScreenWidth - 80, 1)];
        v.backgroundColor = [UIColor whiteColor];
        [_scroll addSubview:v];
        
        if (_dataArr.count - 1 == i) {
            _scroll.contentSize = CGSizeMake(0, CGRectGetHeight(view.frame) * _dataArr.count);
        }
    }

}
- (void)setPatientViewSelected:(PatientInfoView *)view {
    for (id obj in _scroll.subviews) {
        if ([obj isKindOfClass:[PatientInfoView class]]) {
            [(PatientInfoView *)obj setIsSlected:NO];
            [(PatientInfoView *)obj setSelected:NO];
        }
    }
    [view setIsSlected:YES];
    [view setSelected:YES];
}


#pragma mark -
#pragma mark 隐藏tabbar
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
    [self prepareData];
    [self createPatientViewsWithTopY:_frameY];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}

- (IBAction)addPatientBtnClick:(UIButton *)sender {
    AddPatientINfoViewController *vc = [[AddPatientINfoViewController alloc] init];
    vc.title = @"添加患者信息";
    vc.reEditModel = nil;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
