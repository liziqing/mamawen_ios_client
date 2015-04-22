//
//  ChatViewController.m
//  chatdemo
//
//  Created by lixuan on 15/2/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "ChatViewController.h"
#import "LXXMPPManager.h"
#import "MessageModel.h"
#import "NSData+Base64.h"
#import "CustomRoundnessButton.h"
#import "HHTextView.h"
#import "CustomMoreSeletoerButton.h"
#import "RootTabbarController.h"

#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"

#import "DBManager.h"

#import "EndPrediagnosisView.h"
#import "NSString+CurrentTimeString.h"

#import "ThanksDrVC.h"
#define SPACING_MIN   5.0

@interface ChatViewController () <VoiceRecorderBaseVCDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_cacheVideosArr;
    UIView *_toolBar;      // 对话框等  toolbar功能满足不了   用UIView自定义
    CustomRoundnessButton *_statusBtn;     // 切换语音状态按钮
    UIButton *_talkBtn;       // 语音按钮
    CustomRoundnessButton *_addBtn;        // 加号按钮
    CustomRoundnessButton *_giftBtn;       // 礼物按钮
    HHTextView *_textView;                 //
    CGRect _tbRect;
    CGRect _originalToolbarRect;
    UIView *_moreBackView;                 // 更多背景视图
    
    
    BOOL _isKeyBoard;
    
    BOOL _isSendTextMessage;              //
    BOOL _isbeginVoiceRecord;              //
    
    NSString *_receiveAmrPath;             // 收到的amr文件路径  存储
    NSString *_playWavPath;                // 用于播放的wav路径  需删除
    
    UIImageView *_bigImgVBack;                     // 点击小图  显示大图
}


@end

@implementation ChatViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)_initializeRecordConfig {
    _recorderVC = [[ChatVoiceRecorderVC alloc] init]; // 初始化播放VC
    _recorderVC.vrbDelegate = self;
    
    
    // 初始化播放器
    _player = [[AVAudioPlayer alloc] init];
    _voiceInput = NO;
   
    // 拿到缓存的所有video 数组
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 1, YES)[0];
    _cacheVideosArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (id obj in _cacheVideosArr) {
        NSLog(@"cache audio:%@",obj);
    }
    
}
// 医生端用
// 创建点击‘+’后弹出的更多按钮
- (void)createMoreButtons {
    NSArray *titlesArr = @[@"照片",@"拍摄",@"快速回复",@"门诊时间",@"日程提醒",@"加号",@"随访计划",@"病情调查"];
    NSArray *imgsArr = @[@"120 copy.png"];
    CGFloat w = kScreenWidth / 4 - 10;
    CGFloat h = kScreenHeight / 3 / 2 - 10;
    for (int i = 0; i < titlesArr.count; i++) {
        CustomMoreSeletoerButton *btn = [[CustomMoreSeletoerButton alloc] initWithFrame:CGRectMake(5 + (w+5)*(i % 4),5 + (h+5) *(i/4), w, h)];
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgsArr[0]] forState:UIControlStateNormal];
        [_moreBackView addSubview:btn];
    }
}

// 初始化toolbar
- (void)createToolbar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - kNavigationBarMaxY, kScreenWidth, 64)];
    
    
    CGFloat width = _toolBar.frame.size.height - 10 - 20;
    
    
    _statusBtn = [[CustomRoundnessButton alloc] initWithFrame:CGRectMake(SPACING_MIN * 2, SPACING_MIN + 10, width, width)];
    [_statusBtn setImage:[UIImage imageNamed:@"14_07"] forState:UIControlStateNormal];
    [_statusBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:64];
    [_toolBar addSubview:_statusBtn];
    
    
    _talkBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, SPACING_MIN + 10, kScreenWidth - 70 * 2 - width, width)];
    [_talkBtn setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
    [_talkBtn setTitle:@"Hold to Talk" forState:UIControlStateNormal];
    [_talkBtn setTitle:@"Release to Send" forState:UIControlStateHighlighted];
    _talkBtn.hidden = YES;
    [_talkBtn addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchDown];
    [_talkBtn addTarget:self action:@selector(stopTalk) forControlEvents:64];
    _talkBtn.layer.cornerRadius = 8;
    _talkBtn.layer.borderWidth = 2;
    _talkBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_toolBar addSubview:_talkBtn];
    
    
    _textView = [[HHTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_statusBtn.frame) + SPACING_MIN * 2, SPACING_MIN + 10, kScreenWidth - width * 3 - SPACING_MIN, width)];
    _textView.placeHolder = @" 输入你想回复的内容";
    _textView.delegate = self;
    _textView.layer.cornerRadius = 8;
    _textView.keyboardType = UIKeyboardTypeNamePhonePad;
   [_toolBar addSubview:_textView];
    
//    _giftBtn = [[CustomRoundnessButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + SPACING_MIN, SPACING_MIN + 10, width, width)];
//    [_giftBtn addTarget:self action:@selector(giftBtnClick) forControlEvents:64];
//    [_giftBtn setImage:[UIImage imageNamed:@"10_31"] forState:UIControlStateNormal];
//    [_toolBar addSubview:_giftBtn];
    
    _addBtn = [[CustomRoundnessButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + SPACING_MIN + 5, SPACING_MIN + 10, width, width)];
    [_addBtn addTarget:self action:@selector(moreSelectorBtnClick) forControlEvents:64];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"14_09"] forState:UIControlStateNormal];
    [_toolBar addSubview:_addBtn];
   
    
    
    
    [_toolBar setBackgroundColor:[UIColor colorWithRed:0.87 green:0.59 blue:0.6 alpha:1]];
    [self.view addSubview:_toolBar];
    _originalToolbarRect = _toolBar.frame;
}

// 送礼物
- (void)giftBtnClick {
    [ShowAlertView showAlertViewWithTitle:@"Tips" message:@"送礼物" leftbtn:nil rightBtn:@"sure"];
}
//  通知方法   
- (void)changeToUserJid:(NSNotification *)note {
    if (_inquiryID) {
        return;
    }
    _inquiryID = [(MessageModel *)[[[_currentMessageArr lastObject] allObjects] firstObject] inquiryID];
//    _doctorID = [(MessageModel *)[[[_currentMessageArr lastObject] allObjects] firstObject] doctorID];

}
- (void)leftBarButtonItemClick {  [self.navigationController popToRootViewControllerAnimated:YES]; }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提问详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToUserJid:) name:kReceiveMessageNotification object:nil];
    _isSendTextMessage = NO;
    [self  _initializeRecordConfig];

    if (!_toUser) {
//        _toUser = [[UserModel alloc] init];
//        _toUser.jid = @"test5@182.254.222.156";
        // 从提交问诊过来的对话都没有_toUser
    }
    
    
    
    // 取数据
    if ([[DBManager sharedManager] isExists:[NSString stringWithFormat:@"%ld",(long)_inquiryID ]]) {
             _allMessageArr =  [[NSMutableArray alloc] init];
        NSMutableArray *arr =  [[DBManager sharedManager] fetchAll];
        for (MessageModel *model in arr) {
            if ([model.messageId isEqualToString:[NSString stringWithFormat:@"%ld", (long)_inquiryID ]]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:model forKey:model.toOrFrom];
                [_allMessageArr addObject:dic];
                _currentMessageArr = _allMessageArr;
            }
        }
    } else {
    _currentMessageArr = [NSMutableArray array]; // 消息数组  如果本地已有消息，则加入此数组即可
//    [self saveMessage:_firstStr WithMode:kMessageToUser];
        // 要不要吧第一条问诊消息发送IM呢。。
      [self saveMessage:_firstStr withToOrFromMode:kMessageToUser chatmode:chatModeString chatCategory:chatCatagoryNormal];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    // 接收信息
    [[LXXMPPManager shareXMPPManager] registerForMessage:^(MessageModel *oneMessage){
//        [self saveMessage:oneMessage WithMode:kMessageFormUser];
        if ([oneMessage.messageId isEqualToString:[NSString stringWithFormat:@"%ld",(long) _inquiryID]]) {
            [self saveMessage:oneMessage withToOrFromMode:kMessageFormUser chatmode:chatModeNone chatCategory:chatCatagoryNormal];
            [self scrollToBottom];
            _doctorID = oneMessage.doctorID;
        }
        
    }];
    
    
    [self createToolbar];
//    [_tableView reloadData];
    [self scrollToBottom];

}

- (void)talk {
    // 设置文件名
    _originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    _convertAmr = [VoiceRecorderBaseVC getPathByFileName:_originWav ofType:@"amr"];
    // 开始录音
    _receiveAmrPath = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_rec",_originWav] ofType:@"amr"];
    _playWavPath    = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_play",_originWav] ofType:@"wav"];
   
    [_recorderVC beginRecordByFileName:_originWav];
}

- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName{
//    NSLog(@"录音完成，文件路径:%@",_filePath);
    BOOL convert = [VoiceConverter wavToAmr:_filePath amrSavePath:_convertAmr];
   if(convert == 0) [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];// 删除wav
//        NSLog(@"delete item:%d",ret);
//        NSLog(@"convert :%d",convert);
    [self sendVoice];
    [self scrollToBottom];
}
- (void)stopTalk {
    
    [_recorderVC stopRecord];
    
}
- (void)sendMessage {
    [self sendMessageText];
    [self scrollToBottom];
}

- (void)sendMessageText {
    
    if (_textView.text == nil || [_textView.text  isEqual: @""]) {
        [self showAlertViewWithMessage:@"发送内容不能为空，请输入你想发送的文字"];
        return;
    }
    NSString *mes = _textView.text;
    
    [[LXXMPPManager shareXMPPManager] sendMessage:mes withType:chatModeString senderID:[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] integerValue] senderRole:chatRolePatient receiveID:_doctorID receiveRole:chatRoleDoctor chatCatagory:chatCatagoryNormal inquiryID:_inquiryID withCompletion:^(BOOL ret) {
        if (ret) {
            NSLog(@"发送成功");
        } else [self showAlertViewWithMessage:@"发送失败，请检查网络或登录状态"];
    }];
    
    
    [self scrollToBottom];
//    [self saveMessage:mes WithMode:kMessageToUser];
    [self saveMessage:mes withToOrFromMode:kMessageToUser chatmode:chatModeString chatCategory:chatCatagoryNormal];
    
    _textView.text = nil;
    [self changeSendBtnWithPhoto:YES];
    [_textView resignFirstResponder];
}

- (void)sendPicture:(UIImage *)img {

    NSData *data = UIImageJPEGRepresentation(img, 0.75);


    [[LXXMPPManager shareXMPPManager] sendMessage:data withType:chatModePicture senderID:[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] integerValue] senderRole:chatRolePatient receiveID:_doctorID receiveRole:chatRoleDoctor chatCatagory:chatCatagoryNormal inquiryID:_inquiryID withCompletion:^(BOOL ret) {
        if (ret) {
            NSLog(@"发送成功");
        } else [self showAlertViewWithMessage:@"发送失败，请检查网络或登录状态"];
    }];
      [self scrollToBottom];
//    [self saveMessage:dataBase64 WithMode:kMessageToUser];
    
    // 保存图片路径
    NSString *timeStr = [NSString getCurrentTimeString];
//    NSString *picPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/pic_%@",timeStr]];
//    NSLog(@"picPath:%@",picPath);
    if ([data writeToFile:[[NSString getDocumentPathWithSuffixCompoment:timeStr] stringByAppendingString:@"_pic"] atomically:YES]) {
        [self saveMessage:[timeStr stringByAppendingString:@"_pic"] withToOrFromMode:kMessageToUser chatmode:chatModePicture chatCategory:chatCatagoryNormal];
    }     
}
- (void)sendVoice {
//    NSString *recordPath = [VoiceRecorderBaseVC getPathByFileName:_convertAmr ofType:@"amr"];
    NSData *data = [NSData dataWithContentsOfFile:_convertAmr];
//    NSLog(@"---%@---",data); // 2321414d 520a3c6a f86a3842 318188ec c1dcf651
    

    [[LXXMPPManager shareXMPPManager] sendMessage:data withType:chatModeVideo senderID:[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] integerValue] senderRole:chatRolePatient receiveID:_doctorID receiveRole:chatRoleDoctor chatCatagory:chatCatagoryNormal inquiryID:_inquiryID withCompletion:^(BOOL ret) {
        if (ret) {
            NSLog(@"发送成功");
        } else [self showAlertViewWithMessage:@"发送失败，请检查网络或登录状态"];
    }];
    
    [self scrollToBottom];
//    [self saveMessage:dataBase64 WithMode:kMessageToUser];
    // 缓存语音路径
//    NSString *timeStr = [NSString getCurrentTimeString];
//    NSString *path = [timeStr stringByAppendingString:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/audio_%@",timeStr]]];
    [self saveMessage:[_originWav stringByAppendingString:@".amr"] withToOrFromMode:kMessageToUser chatmode:chatModeVideo chatCategory:chatCatagoryNormal];
}


#pragma  mark -
#pragma  mark ActionSheet delegate  && 相机 && 图库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self addCamera];
    } else if (buttonIndex == 1) {
        [self openPicLibrary];
    }

}
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        
        }];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)openPicLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [self sendPicture:editImage];
        [self scrollToBottom];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark 改变发送按钮
- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    _isSendTextMessage = !isPhoto;
    [_addBtn setTitle:isPhoto?@"":@"发送" forState:UIControlStateNormal];
//    _addBtn.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
    UIImage *image = [UIImage imageNamed:isPhoto?@"14_09":@"chat_send_message"];
    [_addBtn setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark toolbar 按钮事件
- (void)moreSelectorBtnClick { // 用户板   相机按钮
//    _isKeyBoard = !_isKeyBoard;
//    if (!_isKeyBoard) {
//        _moreBackView.hidden = YES;
//        _textView.inputView = nil;
//    } else {
//        CGFloat height = kScreenHeight / 3;
//        if (_moreBackView != nil) {
//            _moreBackView.hidden = NO;
//        } else {
//        _moreBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - height, kScreenWidth, height)];
//        _moreBackView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
//            [self createMoreButtons];
//        }
//        
//        _textView.inputView = _moreBackView;
//    }
//    [_textView resignFirstResponder];
//    [_textView becomeFirstResponder];
    if (_isSendTextMessage) {
        [self sendMessage];
    } else {
        [_textView resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images", nil];
        [actionSheet showInView:self.view.window];
    }
}
- (void)statusBtnClick {
    _talkBtn.hidden = !_talkBtn.hidden;
    _textView.hidden  = !_textView.hidden;
    _isbeginVoiceRecord = !_isbeginVoiceRecord;
    if (_isbeginVoiceRecord) {
        [_statusBtn setImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [_textView resignFirstResponder];
    }else{
        [_statusBtn setImage:[UIImage imageNamed:@"14_07"] forState:UIControlStateNormal];
        [_textView becomeFirstResponder];
    }
}
#pragma mark -
#pragma mark 键盘高度变化
- (void)chatKeyboardFrameChange:(NSNotification *)aNotification {
    _tbRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self changToolbarAndTableviewPositionWithKeyboardPosition:NO];
}
- (void)keyboardWillhide:(NSNotification *)bNotification {
     _tbRect = [[bNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self changToolbarAndTableviewPositionWithKeyboardPosition:YES];
}
- (void)changToolbarAndTableviewPositionWithKeyboardPosition:(BOOL)isHidden {
    [UIView animateWithDuration:0.35 animations:^{
        CGRect rect = _toolBar.frame;
        rect.origin.y = _tbRect.origin.y - rect.size.height * 2;
        _toolBar.frame = rect;
        if (isHidden) {
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight - CGRectGetMinY(_toolBar.frame) - CGRectGetHeight(_toolBar.frame), 0);
        } else {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, _tableView.frame.size.height - _tbRect.origin.y + CGRectGetHeight(_toolBar.frame) + kNavigationBarMaxY, 0);
        }
        
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
}

#pragma mark -
#pragma mark textview delegate

- (void)textViewDidChange:(UITextView *)textView {
    [self changeSendBtnWithPhoto:textView.text.length > 0?NO : YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (1 == range.length) { //  按下回格键
        return YES;
    }
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark  触摸事件
//触摸取消textview的第一响应者   被tableview覆盖   待改进
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}


#pragma mark -
#pragma mark 滚动tableview   与自动滚动冲突  待改进
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == _tableView) {
//        [_textView resignFirstResponder];
//    }
//}

#pragma mark -
#pragma mark 弹窗
- (void)showAlertViewWithMessage:(NSString *)mes {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:mes delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark -
#pragma mark 滚动到最新一条聊天数据
- (void)scrollToBottom {
      [_tableView reloadData];
    if (_currentMessageArr.count == 0) {
        return;
    }
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentMessageArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
   
}

#pragma mark -
#pragma mark 聊天数据缓存
- (void)saveMessage:(id)oneMessage WithMode:(NSString *)mode {
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([oneMessage isKindOfClass:[MessageModel class]]) {
//        [(MessageModel *)oneMessage setToOrFrom:mode];
//        [(MessageModel *)oneMessage setMessageId:[NSString stringWithFormat:@"%ld", (long)_inquiryID ]];
        [dict setObject:oneMessage forKey:mode];
        
        if ([mode isEqualToString:kMessageToUser]) { // 接收的在manager中已缓存
            if (!_inquiryID) {
                
            } else
            [[DBManager sharedManager] insertModel:oneMessage];
        }
        
    } else {
        MessageModel *Msg = [[MessageModel alloc] init];
        Msg.message = oneMessage;
        Msg.toOrFrom = mode;
        Msg.messageId = [NSString stringWithFormat:@"%ld", (long)_inquiryID ];
        NSDate *date = [NSDate date];
        NSDateFormatter *da = [[NSDateFormatter alloc] init];
        [da setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [da stringFromDate:date];
        
        Msg.mesTime = timeStr;
        [dict setObject:Msg forKey:mode];
        
        if ([mode isEqualToString:kMessageToUser]) { // 接收的在manager中已缓存
            if (!_inquiryID) {
                
            } else
            [[DBManager sharedManager] insertModel:Msg];
        }
    }
    
    
    [_currentMessageArr addObject:dict];
}
- (void)saveMessage:(id)oneMessage withToOrFromMode:(NSString *)mode chatmode:(chatMode)cmode chatCategory:(chatCatagory)category {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([oneMessage isKindOfClass:[MessageModel class]]) {// 这里没用到嘛--暂时
        [dict setObject:oneMessage forKey:mode];
        
        if ([mode isEqualToString:kMessageToUser]) { // 接收的在manager中已缓存
            if (!_inquiryID) {// 没有messageID （等于inquiryid）就不缓存--存了也查不到
                
            } else [[DBManager sharedManager] insertModel:oneMessage];
        }
    } else {
        MessageModel *Msg = [[MessageModel alloc] init];
        Msg.messageBody = oneMessage;
        Msg.toOrFrom = mode;
        Msg.messageId = [NSString stringWithFormat:@"%ld", (long)_inquiryID ];
        Msg.senderid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] integerValue];
        Msg.senderrole = chatRolePatient;
        Msg.receiveid = _doctorID;
        Msg.receiverole = chatRoleDoctor;
        Msg.doctorID = _doctorID;
        Msg.inquiryID = _inquiryID;
        NSDate *date = [NSDate date];
        NSDateFormatter *da = [[NSDateFormatter alloc] init];
        [da setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [da stringFromDate:date];
        
        Msg.mesTime = timeStr;
        Msg.cmode = cmode;
        Msg.ccategory = category;
        [dict setObject:Msg forKey:mode];
        
        if ([mode isEqualToString:kMessageToUser]) { // 接收的在manager中已缓存
            if (!_inquiryID) {
                
            } else [[DBManager sharedManager] insertModel:Msg];
        }
    }
    [_currentMessageArr addObject:dict];
}
- (void)viewWillDisappear:(BOOL)animated {
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 1, YES)[0];
    
    [(RootTabbarController *)self.tabBarController hiddenMyTabbar:NO];
}


#pragma mark -
#pragma mark 隐藏tabbar && 添加键盘通知
- (void)viewWillAppear:(BOOL)animated {
    [(RootTabbarController *)self.tabBarController hiddenMyTabbar:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardFrameChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark -
#pragma mark tableView  Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentMessageArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _currentMessageArr[indexPath.row];
    MessageModel *mm = [dic allValues][0];
    
    if (_currentMessageArr.count == 1) {
        mm.isFirstMes = YES;
    }
    CGFloat cellHeight = 0.0;
    if (mm.cmode == chatModeString) {  // 文字
         NSString *str = mm.messageBody;
     CGSize size = [str boundingRectWithSize:CGSizeMake(200, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        cellHeight = mm.isShowTime? size.height + 50 + 20 + 20 : size.height + 50 + 20;
    }   else if (mm.cmode == chatModeVideo) {            //   语音
        cellHeight = mm.isShowTime? 40 + 40 + 20 : 40 + 40;
    }   else {                              // 图片
//        return mm.image.size.height + 10;
        cellHeight = mm.isShowTime? 240 + 20 + 20 : 240 + 20;
    }
    
    if (indexPath.row == 0 ) {
        cellHeight += _isHasPic ? 90 : 20;
    }
    if (indexPath.row == 1) {
        cellHeight +=30;
    }
   
    
    if (mm.ccategory == chatCatagoryPrediagnosisReport) {
        cellHeight = 263;
    }
    
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"friendCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //清除上一次的视图
    for(UIView *view in cell.contentView.subviews){
        
        if(view.tag==1001 || view.tag==1002 || view.tag == 1004 || view.tag ==1005 || view.tag == 1006 || view.tag == 1007 || view.tag == 1008 || view.tag == 1009 || view.tag == 1010 )
            [view removeFromSuperview];
    }
    
    //头像
    UIImageView *headImgV = [[UIImageView alloc]init];
    headImgV.layer.cornerRadius = 7;
    headImgV.layer.masksToBounds = YES;
    headImgV.tag=1001;
    //气泡
    UIImageView *chatBackGroundImgV = [[UIImageView alloc]init];
    chatBackGroundImgV.tag=1002;
    // 图片
    UIImageView *pic = [[UIImageView alloc]init];
    pic.tag=1004;
    //文字
    UILabel *label = [[UILabel alloc]init];
    label.tag=1003;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    // time lable
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.tag = 1005;
    timeLable.numberOfLines = 1;
    timeLable.textAlignment = NSTextAlignmentCenter;
    timeLable.font = [UIFont systemFontOfSize:12];
    timeLable.textColor = [UIColor whiteColor];
    
    // 第一条信息 提示lable
    UILabel *noticeLable = [[UILabel alloc] init];
    noticeLable.tag = 1006;
    noticeLable.numberOfLines = 2;
    noticeLable.textAlignment = NSTextAlignmentCenter;
    noticeLable.font = [UIFont systemFontOfSize:12];
    noticeLable.textColor = [UIColor whiteColor];
    
    
    //  提示lable
    UILabel *hintLable = [[UILabel alloc] init];
    hintLable.tag = 1007;
    hintLable.numberOfLines = 2;
    hintLable.textAlignment = NSTextAlignmentCenter;
    hintLable.font = [UIFont systemFontOfSize:12];
    hintLable.textColor = [UIColor whiteColor];
    
    UIImageView *imgVBackView = [[UIImageView alloc] init];
    imgVBackView.userInteractionEnabled = YES;
    imgVBackView.tag = 1008;
    imgVBackView.backgroundColor = [UIColor clearColor];
    
    // 叹号
    UIImageView *noticeImgV = [[UIImageView alloc] init];
    noticeImgV.tag = 1010;
  
    
    NSDictionary *dict = _currentMessageArr[indexPath.row];
    MessageModel *mm = [dict allValues][0];
    
    
    // 结束问诊view
    EndPrediagnosisView *endV = [[EndPrediagnosisView alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 243)];
    endV.tag = 1009;
        
    
    

    
    CGSize size;
    if (mm.cmode == chatModeString) {
        NSString *str = (NSString*)mm.messageBody;
        size = [str boundingRectWithSize:CGSizeMake(200, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    } else if (mm.cmode == chatModeVideo) {
        size = CGSizeMake(kScreenWidth / 3, 5);
    } else size = CGSizeMake(180, 240);
    
    label.text = (NSString*)mm.messageBody;
    label.frame = CGRectMake(20, 3, size.width + 20, size.height + 40);

    
    CGFloat width;
    if ([[dict allKeys][0] isEqualToString:kMessageToUser]) { // 发
//        headImgV.frame = CGRectZero;
        headImgV.image = [UIImage imageNamed:@"1.jpg"];
        headImgV.frame = CGRectMake(kScreenWidth - 50 - 5, 25 + iphone6? 25 : 22, 50, 50);
        headImgV.layer.cornerRadius = headImgV.frame.size.width / 2;

        chatBackGroundImgV.image = [UIImage imageNamed:@"chatto_bg_normal"];
//        chatBackGroundImgV.frame = CGRectMake(kScreenWidth  - size.width - 60 - 2 - 30, 20,size.width  + 30, size.height + 50);
//        width = 10.0;
//        
//        
//        label.frame = CGRectMake(8, 3, size.width + 1, size.height + 40);

        chatBackGroundImgV.frame = CGRectMake(kScreenWidth  - size.width - 60 - 2 - 35, 20,size.width  + 40, size.height + 50);
        width = 10.0;
        
        
        label.frame = CGRectMake(8, 3, size.width + 20, size.height + 40);

        // 时间lable
//        timeLable.frame = CGRectMake(0, 20, 60, 40);
    }
    else { // 收
        headImgV.image = [UIImage imageNamed:@"0.jpg"];
        headImgV.frame = CGRectMake(5,iphone6? 25 : 22, 50, 50);
        headImgV.layer.cornerRadius = headImgV.frame.size.width / 2;
        chatBackGroundImgV.image = [UIImage imageNamed:@"chatfrom_bg_normal"];
        chatBackGroundImgV.frame = CGRectMake(62, 20,size.width + 60 , size.height + 50);
       width = 20.0;
        
        // 时间lable
//        timeLable.frame = CGRectMake(kScreenWidth - 60, 20, 60, 40);
    }
    
//    label.text = (NSString*)mm.messageBody;
//    label.frame = CGRectMake(20, 3, size.width + 20, size.height + 40);
    
    if (0 == indexPath.row) {
        if (_isHasPic && _picArr.count != 0) {
            imgVBackView.frame = CGRectMake(0, CGRectGetMaxY(chatBackGroundImgV.frame) + 5, kScreenWidth, 60);
            for (int i = 0; i < _picArr.count; i ++) {
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(50 + 70 * i, 0, 60, 60)];
                imgV.layer.cornerRadius = 5;
                imgV.layer.masksToBounds = YES;
                imgV.image = _picArr[i];
                imgV.userInteractionEnabled = YES;
                imgV.tag = 120 + i;
                [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inquiryImageTap:)]];
                [imgVBackView addSubview:imgV];
            }
        }
        
        
        if (_isHasPic)  noticeLable.frame = CGRectMake(60, CGRectGetMaxY(imgVBackView.frame) + 5, kScreenWidth - 120, 40);
         else   noticeLable.frame = CGRectMake(60, CGRectGetMaxY(chatBackGroundImgV.frame) + 5, kScreenWidth - 120, 40);
       
        noticeLable.text = [NSString stringWithFormat:@"发送成功,%@前将会有专业医生为您接诊",[self getFifteenminutesLaterTimeString]];
      
    }
    
    if (indexPath.row == 1) {
        hintLable.frame = CGRectMake(60, CGRectGetMaxY(chatBackGroundImgV.frame) + 5, kScreenWidth - 120, 40);
        hintLable.text = @"医生使用休息时间为您预诊的，如未能及时回复，还请见谅";
    }
    
    CGFloat centerY = 0.0;
    if (noticeLable.text.length > 5) centerY = noticeLable.center.y - (iphone6? 8 : 15);
    if (hintLable.text.length > 5)   centerY = hintLable.center.y   - 15;
    
    noticeImgV.frame = CGRectMake(60 - 22,centerY, 15, 15);
    noticeImgV.image = [UIImage imageNamed:@"01_03"];
    
    if (mm.isShowTime) { // 是否显示时间
        NSString *timeStr = [mm showTime];
        CGSize size = [timeStr boundingRectWithSize:CGSizeMake(kScreenWidth / 2, 10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        timeLable.frame = CGRectMake(0, 10, size.width  + 10, 15);
        timeLable.center = CGPointMake(self.view.center.x, 10);
//        timeLable.backgroundColor = [UIColor lightGrayColor];
        timeLable.layer.cornerRadius = 3;
        timeLable.layer.masksToBounds = YES;
        timeLable.text = timeStr;
    }
//    NSLog(@"接收时间:%@",[mm showTime]);
    
    CGFloat top = 50; // 顶端盖高度
    CGFloat bottom = 50 ; // 底端盖高度
    CGFloat left = 50; // 左端盖宽度
    CGFloat right = 50; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    chatBackGroundImgV.image = [chatBackGroundImgV.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    cell.backgroundColor = [UIColor clearColor];
    [chatBackGroundImgV addSubview:label];
    [cell.contentView addSubview:chatBackGroundImgV];
    [cell.contentView addSubview:headImgV];
    [cell.contentView addSubview:timeLable];
    if (indexPath.row == 0) [cell.contentView addSubview:noticeLable];
    if (indexPath.row == 1) [cell.contentView addSubview:hintLable];
    if (indexPath.row == 0) [cell.contentView addSubview:imgVBackView];
    [chatBackGroundImgV addSubview:pic];
    if (indexPath.row == 0 || indexPath.row == 1) [cell.contentView addSubview:noticeImgV];
    
    if (mm.cmode == chatModePicture) {          // 图片
        label.text = nil;
        CGRect rect =  chatBackGroundImgV.frame;
        rect.size.width = 240;
        rect.size.height = 240;
      if ([mm.toOrFrom  isEqual: kMessageToUser])   rect.origin.x -= 30;
        chatBackGroundImgV.frame = rect;
        pic.frame = CGRectMake(5 + width, 12, chatBackGroundImgV.frame.size.width - 40, chatBackGroundImgV.frame.size.height - 30);
        
        if ([mm.toOrFrom  isEqual: kMessageFormUser]) {
            [pic setImageWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:mm.messageBody]] placeholderImage:[UIImage imageNamed:@"userinfo_status_icon_prepare.png"]];
        } else {
            
                pic.image = [UIImage imageWithContentsOfFile:[ NSString getDocumentPathWithSuffixCompoment:mm.messageBody ]];
          }
        

    } else if(mm.cmode == chatModeVideo){  // 语音
        label.text = nil;
        pic.frame = CGRectMake(40, 8, 30, 30);
        pic.image = [UIImage imageNamed:@"chat_bottom_voice_press"];
    } else {                 // 文字
    
    }
    
    
    
    // 结束问诊
    if (mm.ccategory == chatCatagoryPrediagnosisReport) {
        NSDictionary *contentDic = mm.reportDic;
        NSString *problemS = contentDic[@"problem"];
        NSString *suggestS = contentDic[@"suggest"];
        
        
        for (id obj  in cell.contentView.subviews) {
            [obj removeFromSuperview];
        }
        
//        NSLog(@"probelm:%@",problemS);
//        NSLog(@"suggest:%@",suggestS);
        endV.problem = problemS;
        endV.suggest = suggestS;
        
        ThanksDrVC *vc =[[ThanksDrVC alloc] init];
        [endV setGetScore:^{
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        endV.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:endV];
    }
    
    
    return cell;
}

- (NSString *)getFifteenminutesLaterTimeString {
    NSDate *date=  [NSDate date];
    NSTimeInterval interval = 15*60;
    
    NSDate *theDate;
    theDate = [date initWithTimeIntervalSinceNow:interval];
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *str = [fm stringFromDate:theDate];
    return str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
//    NSString *str;
    NSDictionary *dict = _currentMessageArr[indexPath.row];
    MessageModel *mm = [dict allValues][0];
    if (mm.cmode == chatModeVideo) {
        NSData *data;
        NSString *audioPath;
        if ([mm.toOrFrom isEqualToString:kMessageFormUser]) {
            NSString *s = mm.messageBody;
            NSString *suffix = [[s componentsSeparatedByString:[NSString stringWithFormat:@"%@",@"/"]] lastObject];
            audioPath = suffix;
            NSString *existPath = [NSString getDocumentPathWithSuffixCompoment:audioPath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:existPath]) {
                
            } else {
                NSURL *url = [NSURL URLWithString:[@"http://115.159.49.31:9000" stringByAppendingString:mm.messageBody]];
                data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:existPath atomically:YES];
            }
            
        } else {
            audioPath = mm.messageBody ;
        }
        [self playAudioWithPathSuffix:audioPath];
    }
}

// 问诊页上传图片点击  显示大图?
- (void)inquiryImageTap:(UIGestureRecognizer *)ges {
    NSInteger index = ges.view.tag - 120;
    _bigImgVBack = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bigImgVBack.backgroundColor = [UIColor lightGrayColor];
    _bigImgVBack.userInteractionEnabled = YES;
    [_bigImgVBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImgV)]];
    [self.view addSubview:_bigImgVBack];
    
    UIImage *img = _picArr[index];
    CGSize size = img.size;
    CGSize s;
    if (size.width > kScreenWidth) {
        s.width = kScreenWidth;
    } else s.width = size.width;
    
    s.height =size.height / size.width * s.width;
    UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, s.width, s.height)];
    IV.center = _bigImgVBack.center;
    IV.image = img;

    [_bigImgVBack addSubview:IV];
}
- (void)removeImgV {
    [_bigImgVBack removeFromSuperview];
}
#pragma mark -
#pragma mark 点击播放录音
- (void)recordPlayWithData:(NSData *)data {
    
    NSString *str = [VoiceRecorderBaseVC getCurrentTimeString];
    
    _receiveAmrPath = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_rec",str] ofType:@"amr"];
    _playWavPath    = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_play",str] ofType:@"wav"];

//    NSLog(@"_playWavPath:%@",_playWavPath);
    
    [data writeToFile:_receiveAmrPath atomically:YES];
    [VoiceConverter amrToWav:_receiveAmrPath wavSavePath:_playWavPath];
    NSData *wavData = [NSData dataWithContentsOfFile:_playWavPath];
    if (!_player) {
        _player  = [[AVAudioPlayer alloc] init];
    }
    _player = [_player initWithData:wavData error:nil];
    _player.volume = 8;
    [_player prepareToPlay];
    [_player play];
}
- (void)playAudioWithPathSuffix:(NSString *)path {
    NSString *audiopath = [NSString getDocumentPathWithSuffixCompoment:path];
    _playWavPath    = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_play",[NSString getCurrentTimeString]] ofType:@"wav"];
    [VoiceConverter amrToWav:audiopath wavSavePath:_playWavPath];
    NSData *wavData = [NSData dataWithContentsOfFile:_playWavPath];
    if (!_player) {
        _player  = [[AVAudioPlayer alloc] init];
    }
    _player = [_player initWithData:wavData error:nil];
    _player.volume = 8;
    [_player prepareToPlay];
    [_player play];
    [[NSFileManager defaultManager] removeItemAtPath:_playWavPath error:nil];
}
@end
