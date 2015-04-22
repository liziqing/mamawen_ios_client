//
//  InquiryViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "InquiryViewController.h"



#import "MessageListViewController.h"
#import "DBManager.h"
#import "ChatViewController.h"

#import "MessageModel.h"

#import "MsgListTableViewCell.h"
#import "DrListCell.h"
#import "DrListModel.h"
@interface InquiryViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_numberOfChatArr;  // 聊天个数  每一条是一个messagemodel
    
    
    UITableView    *_tableView; // 消息
    UITableView    *_drListTableView; // 医生列表
    NSInteger       _topTapIndex;
    UIView         *_topBackView;
    UIImageView    *_moveV;
    
    NSMutableArray  *_titleArr;
    NSMutableArray  *_drListArr;
}
@end

@implementation InquiryViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)prepareData {
    _topTapIndex = 0;
    if (!_numberOfChatArr) _numberOfChatArr = [NSMutableArray array];
    if (!_drListArr) _drListArr = [NSMutableArray array];
    if (!_titleArr) _titleArr = [NSMutableArray array];
    
    
    NSArray *pics = @[@"05_03",@"05_07",@"05_11"];
    NSArray *titles = @[@"新认识的",@"已付费的",@"在线客服"];
    for (int i = 0; i < pics.count; i++) {
        DrListModel *model = [[DrListModel alloc] init];
        model.picPath = pics[i];
        model.name = titles[i];
        [_titleArr addObject:model];
    }
    
    
    
    [self quiryDataFromDB];
}
- (void)leftBarButtonItemClick {}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithTitle:@"" isImage:NO];
    self.title = @"问诊";
    [self prepareData];
    [self uiConfig];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify) name:kReceiveMessageNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    if (0 == _topTapIndex) {
        [self receiveNotify];
    } 
}
// 从数据库取数据
- (void)quiryDataFromDB {
    NSMutableArray *arr = [[DBManager sharedManager] fetchAll];
    
    // messageID 为空时   会出现死循环
    
    NSArray *reverceArr = [[arr reverseObjectEnumerator] allObjects];
    NSLog(@"最后条信息内容:%@",[[reverceArr firstObject] messageBody]);
    [_numberOfChatArr removeAllObjects];
    for (MessageModel *model in reverceArr) {
        if (_numberOfChatArr.count == 0) {
            [_numberOfChatArr addObject:model];
        } else {
            for (int i = 0; i<_numberOfChatArr.count; i++) {
                MessageModel *m = _numberOfChatArr[i];
                if ([model.messageId isEqualToString:m.messageId]  || !model.messageId || !m.messageId) break;
                else if (i == _numberOfChatArr.count - 1) [_numberOfChatArr addObject:model];
            }
        }
    }
}
// UI
- (void)uiConfig {
    NSArray *arr = @[@"消息",@"医生"];
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,iphone6? 50 : 40)];
    [self.view addSubview:_topBackView];
    
    CGFloat w = kScreenWidth / 2;
    CGFloat h = _topBackView.frame.size.height - 8;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w * i, 0, w, h);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor colorWithRed:0.85 green:0.61 blue:0.65 alpha:1];
        btn.tag = 22 + i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:64];
        [_topBackView addSubview:btn];
        if (i == _topTapIndex) {
            btn.selected = YES;
        }
        
    }
    _moveV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w,h)];
//    _moveV.backgroundColor = [UIColor colorWithRed:0.91 green:0.73 blue:0.77 alpha:1];
    _moveV.backgroundColor = [UIColor colorWithRed:0.85 green:0.35 blue:0.5 alpha:0.5];
//    _moveV.alpha = 0.5;
    [_topBackView addSubview:_moveV];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topBackView.frame) + 10, kScreenWidth, kScreenHeight - kNavigationBarMaxY - CGRectGetHeight(_topBackView.frame) - 59) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    
//    _drListTableView = [[UITableView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>) style:<#(UITableViewStyle)#>];
}
- (void)topBtnClick:(UIButton *)sender {
    for (UIView *vv in _topBackView.subviews) {
        if ([vv isKindOfClass:[UIButton class]]) {
            [(UIButton *)vv setSelected:NO];
        }
    
    }
    
    
    _topTapIndex = sender.tag - 22;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = _moveV.frame;
        rect = CGRectMake(kScreenWidth / 2 * _topTapIndex, rect.origin.y, rect.size.width, rect.size.height);
        _moveV.frame = rect;
    } completion:^(BOOL finished) {
        sender.selected = YES;
        NSLog(@"%ld",_topTapIndex);
        // 更换数据源   刷表
        [_tableView reloadData];
    }];

}
- (void)receiveNotify {
    
    [self quiryDataFromDB];
    [_tableView reloadData];
}
#pragma mark -
#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_topTapIndex == 0) {
        return 1;
    } else return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = 0;
    
    if (_topTapIndex == 0) index = _numberOfChatArr.count;
     else {
        if (section == 0) index = _titleArr.count;
                    else  index = _drListArr.count;
    }
    return index;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_topTapIndex == 0) {
        static NSString *messageListCellID = @"messageListCellID";
        
        MsgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageListCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MsgListTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.model = _numberOfChatArr[indexPath.row];
        return cell;
 
    } else {
    static NSString *drListCellID = @"drListCellID";
        DrListCell *cell = [[DrListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:drListCellID];
        if (indexPath.section == 0) {
            cell.model = _titleArr[indexPath.row];
        } else cell.model = _drListArr[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if (_topTapIndex == 1 && section == 1) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        view.backgroundColor = [UIColor colorWithRed:0.89 green:0.66 blue:0.74 alpha:1];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 100, 10)];
        lable.text = @"重点关注";
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
        [view addSubview:lable];
    }
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_topTapIndex == 0) {
            ChatViewController *vc = [[ChatViewController alloc] init];
    vc.inquiryID = [_numberOfChatArr[indexPath.row] inquiryID];
    vc.doctorID  = [_numberOfChatArr[indexPath.row] doctorID];
    [self.navigationController pushViewController:vc animated:YES];

    } else {
        if (indexPath.section == 0) {
            
            
            
        } else {
        
            
            
        }
    }
}
@end



