//
//  LXXMPPManager.h
//  chatdemo
//
//  Created by lixuan on 15/2/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "UserModel.h"
#import "MessageModel.h"
#import "XMPPReconnect.h"
typedef enum {
    kMsgText = 1,
    kMsgImage = 2,
    kMsgVoice = 3,
    kMsgImageUrl = 4,
    kMsgVoiceUrl = 5,
}MessageType;

@interface LXXMPPManager : NSObject <XMPPStreamDelegate,XMPPReconnectDelegate>
{
    XMPPStream *_xmppStream; // xmpp流 一个连接对应一个流（或者说一个账号对应一个流）
    XMPPReconnect *_reconnect;
    NSMutableArray *_userListArr;
}
@property (nonatomic, copy) void(^saveRegisterSucessCallBcak)(BOOL , NSError *);
@property (nonatomic, copy) void(^saveLoginSucessCallBcak)(BOOL , NSError *);
@property (nonatomic, copy) void(^saveGetFriendListSucessCallBcak)(NSArray *);
@property (nonatomic, copy) void(^saveMessageCallBcak)(MessageModel *);
@property (nonatomic, copy) void(^saveSendMessageCallBcak)(BOOL);

@property (nonatomic, assign) BOOL isInRegister;
@property (nonatomic, strong) UserModel *currentUser;

+ (id)shareXMPPManager;

// 注册
- (void)registerUser:(NSString *)userName
        withPassword:(NSString *)password
        withCompletion:( void(^)(BOOL ret, NSError *error))callBack;

// 登陆
- (void)loginUser:(NSString *)jid
        withPassword:(NSString *)password
        withCompletion:(void (^)(BOOL ret, NSError *error))callBack;

// 上线
- (void)goonline;

// 查询到所有好友时回调好友列表
- (void)getAllFriends:(void(^)(NSArray *))callBack;

// 管理消息分发 每一个用户应该收到的消息全体  在不同的地方解析不同的消息内容（body 和number）进行显示
- (void)registerForMessage:(void(^)(MessageModel *mm))callback;

// 发送消息（ type - 文字、语音、图片）
- (void)sendMessage:(NSString *)message withType:(MessageType)type toUser:(UserModel *)user withCompletion:(void (^)(BOOL ret))callBack;


// 断开连接
- (void)offlineWithXMPP;
- (BOOL) isConnect;



// 发送信息到服务器
- (void)sendMessage:(id)message
           withType:(chatMode)cmode
           senderID:(NSInteger)sender
         senderRole:(chatRole)senderRole
          receiveID:(NSInteger)receive
        receiveRole:(chatRole)receiverole
       chatCatagory:(chatCatagory)catagory
          inquiryID:(NSInteger)inquiryID
     withCompletion:(void(^)(BOOL ret))callBack;
@end


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
 
 /*
     普通信息：
 {"sender":{"id":21,"role":0,"name":"kin","avatar":null},
 "receiver":{"id":1,"role":1,"name":"test1","avatar":null},
 "inquiryID":81,
 "category":1,
 "subCategory":1,
 "content":"接诊成功自动推送第一条信息。。。"}
 
 */