//
//  MessageListViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/18.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//




//  这里的东西已经移到问诊页面


#import "MessageListViewController.h"
#import "DBManager.h"
#import "ChatViewController.h"
#import "UserModel.h"
#import "MessageModel.h"
@interface MessageListViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_numberOfChatArr;  // 聊天个数  每一条是一个messagemodel
    UserModel      *_toUser;
    
    
    UITableView    *_tableView;
}
@end

@implementation MessageListViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)prepareData {
    if (!_numberOfChatArr) _numberOfChatArr = [NSMutableArray array];
    if (!_toUser)          _toUser          = [[UserModel alloc] init];
    
    [self quiryDataFromDB];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    [self prepareData];
    [self uiConfig];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify) name:kReceiveMessageNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [self receiveNotify];
}
// 从数据库取数据
- (void)quiryDataFromDB {
   NSMutableArray *arr = [[DBManager sharedManager] fetchAll];
    
//    for (MessageModel *m in arr) {
//        m.messageId = @"";
//        [[DBManager sharedManager] deleteModel:m];
//        NSLog(@"%@",m);
//    }
    
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

//    NSLog(@"%ld",arr.count);
}
// UI
- (void)uiConfig {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    [self.view addSubview:_tableView];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfChatArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *messageListCellID = @"messageListCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageListCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageListCellID];
    }
    cell.textLabel.text = [_numberOfChatArr[indexPath.row] messageBody];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *vc = [[ChatViewController alloc] init];
//    UserModel *model = [[UserModel alloc] init];
//    model.jid = [_numberOfChatArr[indexPath.row] messageId];
//    vc.toUser = model;
    vc.inquiryID = [_numberOfChatArr[indexPath.row] inquiryID];
    vc.doctorID  = [_numberOfChatArr[indexPath.row] doctorID];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
