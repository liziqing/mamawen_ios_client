//
//  HQHttpManager.m
//  妈妈问
//
//  Created by lixuan on 15/3/20.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "HQHttpManager.h"
#import "AFHTTPRequestOperationManager.h"


@implementation HQHttpManager
{
    AFHTTPRequestOperationManager *_manager;
}

+(instancetype)shareManager {
    static HQHttpManager *_m;
    if (nil == _m) {
        _m = [[HQHttpManager alloc] init];
    }
    return _m;
}

- (instancetype)init {
    if (self == [super init]) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}
- (void)JsonPost:(NSString *)urlStr para:(id)para sucess:(void (^)(id responseObject))sucess fail:(void (^)(NSError *error))fail {
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    urlStr = [kBaseURL stringByAppendingString:urlStr];
    [_manager POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}
@end
