//
//  SpecialistViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/10.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "SpecialistViewController.h"
#import "SpecialistTableViewCell.h"
#import "DoctorDetailIfoVC.h"
#import "SpecialistModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"

@interface SpecialistViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_tableView;
    NSMutableArray  *_dataArr;
}
@end

@implementation SpecialistViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareData];
    [self createTopTap];
}
- (void)prepareData {
    _dataArr = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *para;
    para = @{};
//  para = @{@"department":@"儿科",@"level":@"1"};
    

    [manager POST:[kBaseURL stringByAppendingString:[NSString stringWithFormat:@"/user/expert/get?uid=%@&sessionkey=123&page=0&limit=10",[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] ]] parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"找医生 - 列表：%@",responseObject);
       NSArray * arr = [(NSDictionary *)responseObject objectForKey:@"doctorInfos"];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            SpecialistModel *model = [[SpecialistModel alloc] init];
            model.iconPath = dic[@"avatar"];
            model.name = dic[@"name"];
            model.category = dic[@"title"];
            model.hospital = dic[@"hospital"];
            model.drID = [dic[@"doctorID"] stringValue];
            model.skill = ([dic[@"goodAt"] isEqual:[NSNull null]])? @"这个医生很懒，没有设置专长" : dic[@"goodAt"];
            model.origenalPrice =  (i%2 == 0)?@"222":@"333";
            model.num =  (i%2 == 0)?@"321":@"123";
            [_dataArr addObject:model];
        }
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"network requird faild %@",error.description);
    }];
    
}
- (void)createTopTap {
//    NSArray *arr = @[@"医生专长",@"智能排序"];
//    CGFloat topY = 0.0;
//    for (int i = 0; i < 2 ; i ++) {
//        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth / 2 + 0.5)*i, 1, kScreenWidth / 2 - 0.5, 40)];
//        tapView.backgroundColor = [UIColor clearColor];
//        tapView.tag = 10 + i;
//        [self.view addSubview:tapView];
//        UILabel *lable = [[UILabel alloc] initWithFrame:tapView.bounds];
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.font = [UIFont systemFontOfSize:16];
//        lable.text = arr[i];
//        lable.textColor = [UIColor whiteColor];
//        [tapView addSubview:lable];
//        
//        topY = CGRectGetMaxY(tapView.frame) + 1;
//        
//        if (i == 1) {
//           UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 0.5, 5, 1, 30)];
//            lineView.backgroundColor = [UIColor whiteColor];
//            [self.view addSubview:lineView];
//        }
//        
//        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categryTaped:)]];
//    }
    
    
    
//    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
//    lineV.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineV];
    
    [self createTableViewWithTopY:0];
}
//- (void)categryTaped:(UIGestureRecognizer *)ges {
//    NSInteger index = ges.view.tag - 10;
//    switch (index) {
//        case 0:
//            
//            break;
//        case 1:
//            
//            break;
//        default:
//            break;
//    }
//}
- (void)createTableViewWithTopY:(CGFloat)topY {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth, kScreenHeight - topY) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) return 1;
    else return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {  return 1;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SpecialistTableViewCellID = @"SpecialistTableViewCellID";
    SpecialistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SpecialistTableViewCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecialistTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataArr[indexPath.section];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if (0 == section) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }else {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = [UIColor clearColor];
    
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SpecialistModel *model = _dataArr[indexPath.section];
    DoctorDetailIfoVC *drVC = [[DoctorDetailIfoVC alloc] init];
    drVC.title = @"医生简介";
    drVC.model = model;
    
    [self.navigationController pushViewController:drVC animated:YES];
}


#pragma -
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}
@end
