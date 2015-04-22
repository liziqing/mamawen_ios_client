//
//  MessageModel.h
//  chatdemo
//
//  Created by lixuan on 15/2/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MessageModel : NSObject
@property (nonatomic, copy) NSString *messageId;  // 消息标识   用inquiry

@property (nonatomic, copy) NSString *message;// -
@property (nonatomic, copy) NSString *mesFrom;// -
@property (nonatomic, copy) NSString *mesTo  ;// -


@property (nonatomic, copy) NSString *mesTime;
@property (nonatomic, assign) BOOL   isShowTime;
@property (nonatomic, assign) BOOL   isFirstMes;
@property (nonatomic, assign) BOOL   isEndMes;  // -   // 预诊结束结果信息；
- (UIImage *)image;   // -
- (BOOL)isVideo;     // -
- (NSString *)showTime;

@property (nonatomic,copy)  NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;

//-------------

@property (nonatomic, strong) NSDictionary *senderDic;
@property (nonatomic, strong) NSDictionary *receiveDic;// 字典不好写缓存，分开写成下面的形式

@property (nonatomic, assign)   NSInteger senderid;
@property (nonatomic, assign)   int senderrole;
@property (nonatomic, assign)  NSInteger receiveid;
@property (nonatomic, assign)   int receiverole;

@property (nonatomic, copy) NSString *toOrFrom; //
@property (nonatomic, assign) NSInteger doctorID; // 医生id
@property (nonatomic, assign) NSInteger inquiryID;

@property (nonatomic, assign) chatCatagory ccategory;
@property (nonatomic, strong) NSDictionary *reportDic;  // 拆分成问题和建议   -- 方便缓存
@property (nonatomic, copy)  NSString *problem;
@property (nonatomic, copy)   NSString *suggestion;
@property (nonatomic, strong) id messageBody;
@property (nonatomic, assign) chatMode cmode;
@end
