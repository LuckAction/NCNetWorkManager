//
//  GuanjiaMiaoAFHManager.h
//  MiaowStudentPro
//
//  Created by luck chen on 2016/12/7.
//  Copyright © 2016年 luck chen. All rights reserved.
//
#import "AFNetworking.h"
#import "NCNetWorkNetManager.h"
@interface NCNetWorkSendManager : AFHTTPSessionManager
+ (NCNetWorkSendManager*)shareAFNManager;
//同步请求
- (id)startSyncConnect:(NCNetConnData *)pnet_data error:(NSError **)error;
- (void)startConnect:(NCNetConnData *)pnet_data;
@end
