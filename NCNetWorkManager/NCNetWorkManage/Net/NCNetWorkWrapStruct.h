//
//  WrapStruct.h
//  Miaow
//
//  Created by chenhenian on 16/4/5.
//  Copyright (c) 2016年 Miaow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface BaseSendInfoGJM : NCNetModel
@property (assign,nonatomic,readonly) NSInteger mode;
@property (strong,nonatomic) NSString *portStr;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic,readonly) NSString *selStr;
@property (strong,nonatomic) NSMutableArray *media_data;
@property (nonatomic, assign) BOOL isSynchronous; // 是否用同步方式发送请求
@property (nonatomic,strong) void (^OnSuccessFunc)(id result);
@property (nonatomic,strong) void (^OnFailFunc)(NSError *);
@property (nonatomic,strong) void (^UploadProgress)(NSProgress *);

- (instancetype)initWith:(NSInteger)model;
- (NSData *)pack_to_nsdata;
- (NSString *)CodeName;
- (id)return_unpack_wrap:(NSDictionary *)dic;
- (NSMutableDictionary*)getParameters;
- (NSMutableDictionary*)wrap_pack:(NSMutableDictionary*)dic;
- (NSURL *)connect_url;

@end

@interface PostSend : BaseSendInfoGJM

@end

@interface GetSend : BaseSendInfoGJM

@end

@interface PutSend : BaseSendInfoGJM

@end

@interface DeleteSend : BaseSendInfoGJM

@end


@interface RecvStruct : NCNetModel

+(instancetype)wrap_unpack:(NSDictionary *)dic;
-(BOOL)unpack_nsdic:(NSDictionary *)dic;
-(void)update_info:(id)send_struct;

@end


