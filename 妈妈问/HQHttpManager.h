//
//  HQHttpManager.h
//  妈妈问
//
//  Created by lixuan on 15/3/20.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQHttpManager : NSObject
+ (instancetype)shareManager;

- (void)JsonPost:(NSString *)urlStr
            para:(id)para
          sucess:(void(^)(id responseObject))sucess
            fail:(void(^)(NSError *error))fail;
@end
