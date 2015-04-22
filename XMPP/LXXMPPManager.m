//
//  LXXMPPManager.m
//  chatdemo
//
//  Created by lixuan on 15/2/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "LXXMPPManager.h"
#import "DBManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation LXXMPPManager  
- (instancetype)init {
    self = [super init];
    if (self) {
        _userListArr = [NSMutableArray array];
        _currentUser = [[UserModel alloc] init];
        _xmppStream = [[XMPPStream alloc] init];
//        _xmppStream.enableBackgroundingOnSocket = NO;
        
        
        [_xmppStream setHostName:@"182.254.222.156"];
        [_xmppStream setHostPort:5222];
        _reconnect = [[XMPPReconnect alloc] init];
//        _reconnect.autoReconnect = YES;
        [_reconnect activate:_xmppStream];
        
        // 这里尚未开始连接
        
        // addDelegate  多代理 一个事件需要有一个delegate （多用于注册机制，类似广播机制）
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags {
    NSLog(@"auto reconnect");
    return YES;
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
//    判断是否是进入后台
    NSLog(@"xmpp disconnect");
//    static int connectNum;
//    
//    connectNum ++;
//    
//    
//    if (connectNum >= 10) {
//        [_xmppStream disconnect];
//        return;
//    } 
    [ViewController reconnect];

}

// 单例  只能同时有一个账号
+(id)shareXMPPManager {
    static id _s;
    if (nil == _s) {
        _s = [[LXXMPPManager alloc] init];
    }
    return _s;
}

// 好友列表回调
- (void)getAllFriends:(void (^)(NSArray *))callBack {
    _saveGetFriendListSucessCallBcak = callBack;
    if (_saveGetFriendListSucessCallBcak) {
        _saveGetFriendListSucessCallBcak(_userListArr);
    }
   
}
- (BOOL)isConnect {
    return [_xmppStream isConnecting];
}
#pragma mark - 注册
- (void)registerUser:(NSString *)userName
        withPassword:(NSString *)password
      withCompletion:(void (^)(BOOL, NSError *))callBack {
    _saveRegisterSucessCallBcak = callBack; // 保存回调函数
    _isInRegister = YES; // 初始为注册状态
    
    if ([_xmppStream isConnecting]) {
        [_xmppStream disconnect];
    }
    
    // 这里开始注册
    _currentUser.jid = userName;
    _currentUser.password = password;
    
    XMPPJID *myJID = [XMPPJID jidWithString:userName];
    [_xmppStream setMyJID:myJID];
    NSError *error = nil;
    
 // 连接只能连接一次
    BOOL ret = [_xmppStream connectWithTimeout:-1 error:&error];
    if (ret == NO) {
        if (_saveRegisterSucessCallBcak) {
            _saveRegisterSucessCallBcak(NO,error);
        }
    }
}
#pragma mark - 登陆
- (void)loginUser:(NSString *)jid withPassword:(NSString *)password withCompletion:(void (^)(BOOL, NSError *))callBack {
    _saveLoginSucessCallBcak = callBack;
    _isInRegister = NO;
    // login : two steps jid -- > password
    _currentUser.jid = jid;
    _currentUser.password = password;
    XMPPJID *myJID = [XMPPJID jidWithString:jid];
    
    if ([_xmppStream isConnecting]) {
        [_xmppStream disconnect];
    }
    [_xmppStream setMyJID:myJID];
    NSError *err = nil;
    BOOL ret = [_xmppStream connectWithTimeout:-1 error:&err];
    if (NO == ret) {
        _saveLoginSucessCallBcak(NO,err);
    }
}


#pragma mark - actions 
// 上线
- (void)goonline {
    XMPPPresence *presence = [XMPPPresence presence]; // 缺省为上线   设置type改变状态
    [_xmppStream sendElement:presence];
}

// 获取好友
- (void)getAllFriends {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    
//    NSLog(@"all friends : %@",iq);
    [_xmppStream sendElement:iq];
}

// 新上线或更新状态时  数组数据的增改
- (void)addOrUpdateUser:(NSString *)user withStatus:(NSString *)status needToChangeStatus:(BOOL)change {
    for (UserModel *un in _userListArr) {
        if ([un.jid isEqualToString:user]) {
            return;
        }
    }
    [self addOrUpdateUser:user withStatus:status];
}
- (void)addOrUpdateUser:(NSString *)user withStatus:(NSString *)status {

    for (UserModel *un in _userListArr) {
        if ([un.jid isEqualToString:user]) {
            un.status = status;
            if (_saveGetFriendListSucessCallBcak) {
                _saveGetFriendListSucessCallBcak(_userListArr);
            }
            return;
        }
    }
    UserModel *um = [[UserModel alloc] init];
    um.jid = user;
    um.status = status;
    [_userListArr addObject:um];
    
    //  只要有好友上线就会调用
    if (_saveGetFriendListSucessCallBcak) {
        _saveGetFriendListSucessCallBcak(_userListArr);
    }
}

//  注册消息分发
- (void)registerForMessage:(void (^)(MessageModel *))callback {
    _saveMessageCallBcak = callback;
}



#pragma mark - XMPP delegate

// 注册和登陆 连接成功都会回调此方法
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"已连接上 %@",NSStringFromSelector(_cmd));
    // 第一次连接上服务器
    
    // 向服务器(这里用的是openfire)注册 密码
    NSError *err = nil;
    if (_isInRegister) {
        [_xmppStream registerWithPassword:_currentUser.password error:&err];
        [_xmppStream disconnect];  //注册后马上登陆会报错 ： Attempting to connect while already connected or connecting
    } else {
        [_xmppStream authenticateWithPassword:_currentUser.password error:&err];
    }
}


/**
 * This method is called after registration of a new user has successfully finished.
 * If registration fails for some reason, the xmppStream:didNotRegister: method will be called instead.
 **/
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"注册成功 func - %@",NSStringFromSelector(_cmd));
    if (_saveRegisterSucessCallBcak) {
        _saveRegisterSucessCallBcak(YES,nil);
    }

}
//
///**
// * This method is called if registration fails.
// **/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    NSLog(@"注册失败 err - %@",error);
    if (_saveRegisterSucessCallBcak) {
        NSError *err = [NSError errorWithDomain:error.description code:-1 userInfo:nil];
        _saveRegisterSucessCallBcak(NO,err);
    }
}

/**
 * This method is called after authentication has successfully finished.
 * If authentication fails for some reason, the xmppStream:didNotAuthenticate: method will be called instead.
 **/
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
   NSLog(@"授权成功 func - %@",NSStringFromSelector(_cmd));
    
    // 授权成功相关操作  e.g. - go online
    if (_saveLoginSucessCallBcak) {
        _saveLoginSucessCallBcak(YES,nil);
    }
    [self goonline];
    [self getAllFriends];
}

/**
 * This method is called if authentication fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"授权失败 func - %@",NSStringFromSelector(_cmd));
    if (_saveLoginSucessCallBcak) {
        NSError *err = [NSError errorWithDomain:error.description code:-1 userInfo:nil];
        _saveLoginSucessCallBcak(NO,err);
    }
}


// 收到好友信息  不包括上、离线等状态
// 通过delegate返回所有的好友，且默认都是不在线的
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq { // iq : infomation query
    
//    NSLog(@"func : %@ - IQ : %@",NSStringFromSelector(_cmd),iq);
    
            NSXMLElement *query = iq.childElement;
            NSArray *items = [query children];
    
            for (NSXMLElement *item in items) {
                NSString *jid = [item attributeStringValueForName:@"jid"];
//                UserModel *um = [[UserModel alloc] init];
//                um.jid = jid;
//                [_userListArr addObject:um];
                [self addOrUpdateUser:jid withStatus:@"unavailable" needToChangeStatus:NO];
                NSLog(@"jid is %@",jid);
            }

    return YES;
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    // 接收消息时调用（其实在开始输入就会调用一次--qq正在输入功能）
//    NSLog(@"func : %@ - message : %@",NSStringFromSelector(_cmd),message);
//    NSLog(@"%@",message.description);
    
    if ([message isChatMessage]) {
        if ([message isChatMessageWithBody]) {
            [self analysisWithMessageBody:message];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveMessageNotification object:nil];
//    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
//        
//    }
//    [self registerLocalNotification]; // 注册本地推送
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    // 数组中某个人的信息、状态改变
    // 好友有多少  此方法就会调几次
    // 改变状态也会调用

//    NSLog(@"func : %@ - presence : %@",NSStringFromSelector(_cmd),presence);
    
    NSArray *arr = presence.children;
    NSString *jid = [presence attributeStringValueForName:@"from"];
    NSString *status = @"online";
//    NSLog(@"--%@",jid); // 上线或者离线的用户
    
    for (NSXMLElement *oneChild in arr) {
        if ([oneChild.name isEqualToString:@"show"]) {
            status = @"away";
        }
    }
    /*
     *  + (XMPPJID *)jidWithUser:(NSString *)user domain:(NSString *)domain resource:(NSString *)resource;
     
     *     jid中有三个属性 user/domain/resource
     */
    XMPPJID *oneJID = [XMPPJID jidWithString:jid];
    jid = [NSString stringWithFormat:@"%@@%@",oneJID.user,oneJID.domain];
//    NSLog(@"------%@",jid);
    
    [self addOrUpdateUser:jid withStatus:status];
}

// 发送消息成功回调
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    if (_saveSendMessageCallBcak) {
        _saveSendMessageCallBcak(YES);
    }
//    NSLog(@"%@",message.description);
}
- (void)offlineWithXMPP {
    [_xmppStream disconnect];
}




#pragma mark -
#pragma mark 本地推送
//- (void)registerLocalNotification {
//    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
//        [self addLocalNotification];
//    } else {
//    if (IOS8) {
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1";
//        action1.title = @"Accept";
//        action1.activationMode = UIUserNotificationActivationModeForeground;
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
//        action2.identifier = @"action2";
//        action2.title = @"overLook";
//        action2.activationMode = UIUserNotificationActivationModeBackground;
//        
//        action1.authenticationRequired = YES;
//        action1.destructive = YES;
//       
//    
//        
//        UIMutableUserNotificationCategory *categotys = [[UIMutableUserNotificationCategory alloc] init];
//        categotys.identifier = @"alert";
//        [categotys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextMinimal)];
//        
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categotys, nil]];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
//    }
//    }
//}
//- (void)addLocalNotification {
//    UILocalNotification *notify = [[UILocalNotification alloc] init];
//    
//    notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
//    notify.repeatInterval = 1;
//    
//    notify.alertBody = @"打开应用";
//    notify.applicationIconBadgeNumber += 1;
//    notify.alertAction = @"打开应用";
//    notify.alertLaunchImage = @"Default";
//    notify.soundName = UILocalNotificationDefaultSoundName;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
//    
//}
- (void)analysisWithMessageBody:(XMPPMessage *)message {

    NSLog(@"receive messageBody:%@",message.description);
    
    NSString *body = message.body;
    
//    NSString *from = message.from.bare;
//    NSString *to = message.to.bare;
//    
//    //
//    //            NSString *timeStr = [message attributeStringValueForName:@"msg_time"];
//    //            NSLog(@"%@",timeStr); //2015-03-09 13:36:31
//    MessageModel *mm = [[MessageModel alloc] init];
//    mm.message = body;
//    mm.mesFrom = from;
//    mm.mesTo = to;
//    //            mm.mesTime = timeStr;
//    mm.messageId = from;
//    mm.toOrFrom = kMessageFormUser;
//    
//    
//
//    [[DBManager sharedManager] insertModel:mm];
//    if (_saveMessageCallBcak) {
//        _saveMessageCallBcak(mm);
//    } else {
//#warning 离线消息   目前全部存在message里面   图片和语音
//        // 存在离线数据数组中   直到点击读取
//        //to="test6@182.254.222.156/892a4d95" from="test5@182.254.222.156/
//        
//    }
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
   
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"receive messageBody:%@",dic);
    MessageModel *mm = [[MessageModel alloc] init];
    
    NSDictionary *senderDic = dic[@"sender"];
    NSDictionary *receiverDic = dic[@"receiver"];
    
    chatCatagory category = [dic[@"category"] integerValue];
    chatMode cmode = [dic[@"subCategory"] integerValue];
    
    
    
    mm.ccategory = category;
    mm.toOrFrom = kMessageFormUser;
    mm.senderDic = senderDic;
    mm.receiveDic = receiverDic;
    mm.doctorID = [senderDic[@"id"] integerValue];
    mm.inquiryID = [dic[@"inquiryID"] integerValue];
//    NSLog(@"message content:%@",dic[@"content"]);
    switch (category) {
        case chatCatagoryNormal:
            mm.cmode = cmode;
            mm.messageId = [dic[@"inquiryID"] stringValue];
            mm.messageBody = dic[@"content"];
            
            if (cmode == chatModeString) {// 文字聊天
               
            } else if (cmode == chatModePicture) {// 图片聊天
            
            }else if (cmode == chatModeVideo) {// 语言聊天
            
            
            }
            break;
            /*
             接诊信息：
             {"sender":{"id":21,"role":0,"name":"kin","avatar":null},
             "receiver":{"id":1,"role":1,"name":"test1","avatar":null},
             "inquiryID":81,
             "category":2,
             "doctorID":null,
             "name":"kin",
             "title":"主任医师",
             "hospital":"上海中医药大学附属岳阳中西医结合医院","department":"儿科"}
             */

        case chatCatagoryAdmissions:
//            mm.doctorID = [senderDic[@"id"] integerValue];
//            mm.inquiryID =
            break;
        case chatCatagoryPrediagnosisReport:
            mm.messageId = [dic[@"inquiryID"] stringValue];
            mm.reportDic = @{@"problem":dic[@"description"],@"suggest":dic[@"suggestion"]};
            break;
            
        default:
            break;
    }
    if (mm.messageId) {
        [[DBManager sharedManager] insertModel:mm];
    }
    if (_saveMessageCallBcak) {
            _saveMessageCallBcak(mm);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveMessageNotification object:nil];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark -
#pragma mark - 发送信息
// 发送xmpp
- (void)sendMessage:(NSString *)message withType:(MessageType)type toUser:(UserModel *)user withCompletion:(void (^)(BOOL))callBack {
    _saveSendMessageCallBcak = callBack;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *da = [[NSDateFormatter alloc] init];
    [da setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [da stringFromDate:date];
    
    
    if (1) { // 发送文字
        XMPPJID *toJid = [XMPPJID jidWithString:user.jid];
        XMPPMessage *onemessage = [[XMPPMessage alloc] initWithType:@"chat" to:toJid];
        if (type == kMsgImage) { // 发送图片
            [onemessage addAttributeWithName:@"msg_type" stringValue:@"pic"];
            
        } else if (type == kMsgVoice) { // 发送声音
            [onemessage addAttributeWithName:@"msg_type" stringValue:@"voice"];
        }
        [onemessage addAttributeWithName:@"msg_time" stringValue:timeStr];
        [onemessage addBody:message];
        [_xmppStream sendElement:onemessage];
    }
}

// 发送HTTP服务器

- (void)sendMessage:(id)message // 消息体
           withType:(chatMode)cmode  // 消息类型：文字？语言？图片
           senderID:(NSInteger)sender //
         senderRole:(chatRole)senderRole //
          receiveID:(NSInteger)receive
        receiveRole:(chatRole)receiverole
       chatCatagory:(chatCatagory)catagory // 普通聊天？预诊报告？接诊
          inquiryID:(NSInteger)inquiryID
     withCompletion:(void (^)(BOOL))callBack { // 发送成功回调
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *senderDic  = [NSMutableDictionary dictionary];
    NSMutableDictionary *receiveDic = [NSMutableDictionary dictionary];
    
    [senderDic setObject:@(sender) forKey:@"id"];
    [senderDic setObject:@(senderRole) forKey:@"role"];
    
    [receiveDic setObject:@(receive) forKey:@"id"];
    [receiveDic setObject:@(receiverole) forKey:@"role"];
    
    [param setObject:@(catagory) forKey:@"category"];
    [param setObject:senderDic forKey:@"sender"];
    [param setObject:receiveDic forKey:@"receiver"];
    
    
    switch (catagory) {
        case chatCatagoryNormal:
            [param setObject:@(inquiryID) forKey:@"inquiryID"];
            [param setObject:@(cmode) forKey:@"subCategory"];
            if (cmode == chatModeString) {
                [param setObject:(NSString*)message forKey:@"content"];
            }
            break;
        case chatCatagoryAdmissions:
            
            break;
        case chatCatagoryPrediagnosisReport: // 发送发放中不用，医生端发送报告
            [param setObject:[(NSDictionary*)message objectForKey:@"problem"] forKey:@"description"];
            [param setObject:[(NSDictionary*)message objectForKey:@"suggestion"] forKey:@"suggestion"];
            break;
            
        default:
            break;
    }
#if 1
    // 发起请求
    NSLog(@"%@",param);
    [manager         POST:[kBaseURL stringByAppendingString:[NSString stringWithFormat:@"/im/user/send?uid=%@&sessionkey=1",[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]]]
               parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    // data部分
        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil] name:@"message"];
    // file部分
    if (cmode == chatModePicture) {
        [formData appendPartWithFileData:message name:@"file" fileName:@"picture.jpeg" mimeType:@"image/jpeg"];
    } else if (cmode == chatModeVideo)
        [formData appendPartWithFileData:(NSData *)message name:@"file" fileName:@"audio.amr" mimeType:@"audio/*"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"send succes  :%@",responseObject);
      
        callBack(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callBack(NO);
    }];
    
#elif 0
    
    [param setObject:message forKey:@"xxx"];

    NSData *d = [ NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil ];
    NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    _saveSendMessageCallBcak = callBack;
    XMPPJID *tojid = [XMPPJID jidWithString:@"test4@182.254.222.156"];
    XMPPMessage *oneMessage = [[XMPPMessage alloc] initWithType:@"chat" to:tojid];
    [oneMessage addBody:str];
    [_xmppStream sendElement:oneMessage];
#endif
}
@end
