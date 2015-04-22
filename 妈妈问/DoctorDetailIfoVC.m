//
//  DoctorDetailIfoVC.m
//  妈妈问
//
//  Created by lixuan on 15/3/10.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "DoctorDetailIfoVC.h"
#import "CustomSevicesView.h"
#import "SevicesModel.h"
#import "UIImageView+AFNetworking.h"

#import "ChatViewController.h"
#import "SureToAskVC.h"
@interface DoctorDetailIfoVC () <UIAlertViewDelegate>
{
    UIScrollView    *_scroll;
    NSMutableArray  *_dataArr;
    
    
    CGFloat         _spaceW;  // 控件间隔
    CGFloat         _iconW;   // 头像宽度
    CGFloat         _descLableH;   // 描述内容高度
    
    NSString        *_numberOfPatient;  // 患者数
    NSString        *_numberOfFans;     // 粉丝数
    BOOL            _isAttention;       // 是否关注
    
    
    NSString        *_descStr;          // 描述内容
    
    NSArray *_categoryArr;
}
@end

@implementation DoctorDetailIfoVC

- (void)prepareData {
    _spaceW = 8;
    _iconW  = 70;
    
    _isAuthentication = YES;
    _numberOfPatient  = @"123";
    _numberOfFans     = @"124";
    _isAttention      = NO;
    
//    _descStr = @"病毒、细菌引起的阴道炎、宫颈炎、宫颈糜烂、盆腔炎、附件炎、月经不调等各种妇科炎症。";
    _descStr = _model.skill;
    _dataArr = [NSMutableArray array];
    _categoryArr = @[@"单次",@"包周",@"包月"];
    NSArray *iconArr = @[@"15_17",@"15_20",@"15_22"];
    NSArray *priceArr    = @[@"70",@"100",@"10"];
//    NSArray *descArr     = @[@"购买期内不限次图文、电话咨询",
//                             @"选定时间与医生进行15分钟电话咨询",
//                             @"预约专家到医院挂号就诊"];
//    NSArray *buyerNumArr = @[@"211",@"112",@"34"];
//    NSArray *evaluateArr = @[@"4.9",@"4.9",@"4.9"];
    
    for (int i = 0; i < _categoryArr.count; i++) {
        SevicesModel *model = [[SevicesModel alloc] init];
        model.icon = iconArr[i];
        model.category = _categoryArr[i];
        model.price    = priceArr[i];
//        model.descryption = descArr[i];
//        model.buyerNum    = buyerNumArr[i];
//        model.evaluate    = evaluateArr[i];
        [_dataArr addObject:model];
    }
}
- (void)sureButtonItemclick {
    SureToAskVC *svc = [[SureToAskVC alloc] init];
//    svc.isFindDr = YES;
//    svc.doctorID = _model.drID;
    svc.title = @"医生详情";
    svc.model = _model;
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setRightNavigationItemWithTitle:@"7_03" isImage:YES];
//    self.view.backgroundColor = [UIColor redColor];
    [self prepareData];
    [self uiConfig];
}

- (void)uiConfig {
    // 计算描述内容所占高度
   _descLableH = [_descStr boundingRectWithSize:CGSizeMake(kScreenWidth - _spaceW * 7, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height + 10;
    
    
    [self createSureButton];
    [self createUserInfo];
}
- (void)createSureButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, kScreenHeight - kNavigationBarMaxY - (iphone6?60:50), kScreenWidth, iphone6? 60 : 50);
    [btn setTitle:@"确认咨询" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureButtonItemclick) forControlEvents:64];
    [btn setBackgroundColor:[UIColor colorWithRed:0.18 green:1 blue:1 alpha:1]];
    [self.view addSubview:btn];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarMaxY - CGRectGetHeight(btn.frame) - 1)];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = YES;
    _scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scroll];

    
}

// 医生信息
- (void)createUserInfo {
    // 信息背景色
//    UIView *topBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _iconW + _spaceW * 4 + 25 + _descLableH + 10)];
//    topBack.backgroundColor = [UIColor clearColor];
//    [_scroll addSubview:topBack];
    
    // 头像
    
    
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(_spaceW * 3, _spaceW * 2, _iconW, _iconW)];
    iconV.layer.cornerRadius = _iconW / 2;
    iconV.layer.masksToBounds = YES;
//    iconV.backgroundColor = [UIColor lightGrayColor];
    NSString *iconPath = _model.iconPath;
    //    NSLog(@"%@",iconPath);
    if (![iconPath isEqual:[NSNull null]]) {
        [iconV setImageWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:iconPath]] placeholderImage:[UIImage imageNamed:@"04_101"]];
    }
    else iconV.image = [UIImage imageNamed:@"04_101"];
    [_scroll addSubview:iconV];
    
    // 名字
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame) + _spaceW,CGRectGetMinY(iconV.frame), 60, 20)];
    nameLable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
    nameLable.text = _model.name;
    nameLable.textColor = [UIColor whiteColor];
    [_scroll addSubview:nameLable];
    
    UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLable.frame), CGRectGetMaxY(nameLable.frame) + _spaceW, kScreenWidth - CGRectGetMinX(nameLable.frame) - 30, 1)];
    linev.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:linev];
    
    // 职称
    UILabel *zcLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLable.frame), CGRectGetMinY(nameLable.frame), 70, 20)];
    zcLable.font = [UIFont systemFontOfSize:iphone6?16 : 14];
    zcLable.textColor = [UIColor whiteColor];
    zcLable.text = _model.category;
    [_scroll addSubview:zcLable];
    
    // 医院
    UILabel *hospitalLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLable.frame), CGRectGetMaxY(linev.frame) + _spaceW, 200, 20)];
    hospitalLable.font = [UIFont systemFontOfSize:iphone6? 15 : 13];
    hospitalLable.text = _model.hospital;
    hospitalLable.adjustsFontSizeToFitWidth = YES;
    hospitalLable.textColor = [UIColor whiteColor];
    [_scroll addSubview:hospitalLable];
    
    // 在线
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLable.frame), CGRectGetMaxY(hospitalLable.frame), 200, 20)];
//    lable.font = [UIFont systemFontOfSize: 13];
//    lable.text = @"X大夫皮肤科在线";
//    [_scroll addSubview:lable];
    
    // 认证
    if (_isAuthentication) {
        UIImageView *auth = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zcLable.frame) + 5, CGRectGetMinY(zcLable.frame) , 25, 25)];
        auth.image = [UIImage imageNamed:@"16_03"];
        [_scroll addSubview:auth];
//        UILabel *authLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zcLable.frame), CGRectGetMinY(zcLable.frame) + 5, 50, 15)];
//        authLable.font = [UIFont systemFontOfSize:10];
//        authLable.text = @"权威认证";
//        authLable.textColor = [UIColor whiteColor];
//        authLable.layer.cornerRadius = 7;
//        authLable.layer.masksToBounds = YES;
//        authLable.textAlignment = NSTextAlignmentCenter;
//        authLable.backgroundColor = [UIColor colorWithRed:0.31 green:0.83 blue:0.91 alpha:1];
//        [_scroll addSubview:authLable];
    }
    
    // 患者数
    
    CGFloat picH  = 25;
    UIImageView *patientV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLable.frame), CGRectGetMaxY(hospitalLable.frame) + 5, picH, picH)];
    patientV.image = [UIImage imageNamed:@"15_07"];
    [_scroll addSubview:patientV];
    UILabel *patient = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(patientV.frame), CGRectGetMinY(patientV.frame) , picH * 3 / 2, picH)];
    patient.adjustsFontSizeToFitWidth = YES;
    patient.font = [UIFont systemFontOfSize:14];
    patient.textColor = [UIColor whiteColor];
    patient.textAlignment = NSTextAlignmentCenter;
    patient.text = _numberOfPatient;
    [_scroll addSubview:patient];
    
    //  粉丝数
    
    UIImageView *fansV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(patient.frame) + 5, CGRectGetMinY(patientV.frame), picH, picH)];
    fansV.image = [UIImage imageNamed:@"15_09"];
    [_scroll addSubview:fansV];
    UILabel *fans = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fansV.frame) , CGRectGetMinY(patient.frame) , picH * 3 / 2, picH)];
    fans.font = [UIFont systemFontOfSize:14];
    fans.adjustsFontSizeToFitWidth = YES;
    fans.textColor = [UIColor whiteColor];
    fans.textAlignment = NSTextAlignmentCenter;
    fans.text = _numberOfFans;
    [_scroll addSubview:fans];
    
    // 关注
    UIImageView *atv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fans.frame) + 10, CGRectGetMinY(fansV.frame), picH, picH)];
    atv.image = [UIImage imageNamed:@"15_12"];
    [_scroll addSubview:atv];
    UILabel *attention = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(atv.frame), CGRectGetMinY(fansV.frame) , picH , picH)];
    attention.adjustsFontSizeToFitWidth = YES;
    attention.font = [UIFont systemFontOfSize:14];
    attention.textColor = [UIColor whiteColor];
    attention.textAlignment = NSTextAlignmentCenter;
    attention.text = _isAttention?@"已关注":@"关注";
    [_scroll addSubview:attention];
    
//    [self createSureButtonWithTopY:CGRectGetMaxY(patient.frame) + _spaceW * 2];
    [self createDescViewWithTopY:CGRectGetMaxY(patient.frame) + _spaceW * 2];
}

- (void)createDescViewWithTopY:(CGFloat)topY {
    UILabel *descLable = [[UILabel alloc] initWithFrame:CGRectMake(_spaceW * 3, topY, kScreenWidth - _spaceW * 6, _descLableH )];
    
    descLable.font = [UIFont systemFontOfSize:iphone6? 14 : 13];
    descLable.textColor = [UIColor whiteColor];
    descLable.text = [NSString stringWithFormat:@"擅长：%@", _descStr ];
    descLable.numberOfLines = 0;
    [_scroll addSubview:descLable];
    
        UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(descLable.frame),CGRectGetMinY(descLable.frame) - 1, CGRectGetWidth(descLable.frame), 1)];
        lineV1.backgroundColor = [UIColor whiteColor];
        [_scroll addSubview:lineV1];
    
    
    
        UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(descLable.frame), CGRectGetMaxY(descLable.frame) , CGRectGetWidth(descLable.frame), 1)];
        lineV2.backgroundColor = [UIColor whiteColor];
        [_scroll addSubview:lineV2];
    _scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(descLable.frame) - kNavigationBarMaxY);
//    [self createMoreSeviceWithTopY:CGRectGetMaxY(descLable.frame) + _spaceW * 3];
}
- (void)createMoreSeviceWithTopY:(CGFloat)topY {
    //  诊所服务
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth, 30)];
//    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor whiteColor];
    lable.text = @"    诊所服务";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:14];
    [_scroll addSubview:lable];
    


    
    [self createSevicesLable:CGRectGetMaxY(lable.frame) + 1];
}
- (void)createSevicesLable:(CGFloat)topY {
    CGFloat evaluateTopY = 0.0;
    
    for (int i = 0; i < _dataArr.count; i ++) {
        CustomSevicesView *view = [[CustomSevicesView alloc] initWithFrame:CGRectMake(0, topY + (kSeviceViewHeight + 1) * i, kScreenWidth, kSeviceViewHeight)];
        view.backgroundColor = [UIColor colorWithRed:0.89 green:0.66 blue:0.74 alpha:1];
        view.model = _dataArr[i];
        view.tag = 310 + i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceViewTap:)]];
        [_scroll addSubview:view];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) , kScreenWidth, 1)];
        lineV.backgroundColor = [UIColor whiteColor];
        [_scroll addSubview:lineV];
        
        if (i == _dataArr.count - 1) {
            evaluateTopY = CGRectGetMaxY(view.frame) + _spaceW;
        }
    }
    // 设置scrollView
    _scroll.contentSize = CGSizeMake(0, evaluateTopY);

//    [self creatrEvaluateView:evaluateTopY];
}
- (void)serviceViewTap:(UIGestureRecognizer *)ges {
//    UIView *view = ges.view;
//    NSInteger index = view.tag - 310;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"tips" message:[NSString stringWithFormat: @"是否购买%@?",_categoryArr[index]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
}
#pragma mark -
#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
//        NSLog(@"%@",_model.drID);
        ChatViewController *cvc = [[ChatViewController alloc] init];
        cvc.doctorID = _model.drID.integerValue;
        [self.navigationController pushViewController:cvc animated:YES];
    }

}

#pragma mark -
#pragma mark 评价 - 取消
- (void)creatrEvaluateView:(CGFloat)topY {
    //  评价
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth, 30)];
    lable.backgroundColor = [UIColor redColor];
    lable.text = @"    用户评价";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:14];
    [_scroll addSubview:lable];
    
    UIView *evaluateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame) + 1, kScreenWidth, 100)];
    evaluateView.backgroundColor = [UIColor redColor];
    [_scroll addSubview:evaluateView];
    
    [self createTopicView:CGRectGetMaxY(evaluateView.frame) + _spaceW];
}
- (void)createTopicView:(CGFloat)topY {
    // 话题
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth, 30)];
    lable.backgroundColor = [UIColor redColor];
    lable.text = @"    近期话题";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:14];
    [_scroll addSubview:lable];
    
    UIView *topicView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame) + 1, kScreenWidth, 60)];
    topicView.backgroundColor = [UIColor redColor];
    [_scroll addSubview:topicView];
    
}
#pragma -
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}

@end
