//
//  NCNetWorkNetManager.m
//  Miaow
//
//  Created by chenhenian on 16/4/5.
//  Copyright (c) 2016年 Miaow. All rights reserved.
//


#import "NCNetWorkNetManager.h"
#import "NCNetWorkWrapStruct.h"
#import "NCNetWorkSendManager.h"

@implementation NCNetMediaCakeData

-(NSData *)out_data
{
    NSString *pcontent_string = [NSString stringWithFormat:@"Content-Disposition: from-data; name=%@; filename=%@\r\nContent-Type: %@\r\n\r\n",self.name_key,self.file_name,self.content_type];
    NSMutableData *pout_data = [NSMutableData data];
    [pout_data appendData:[pcontent_string dataUsingEncoding:NSUTF8StringEncoding]];
    [pout_data appendData:self.content_data];
    return pout_data;
}

@end


@implementation NCNetConnData


- (instancetype)initInfo:(BaseSendInfoGJM*)info
{
    self = [super init];
    if (self) {
        self.url = [info connect_url];
        self.over_time = OVERTIME;
        self.task_time = time(NULL);
        self.http_mode = info.mode;
        self.send_wrap = info;
        self.isSynchronous = info.isSynchronous;
        self.Content_Type = @"application/json";
        self.OnSuccessFunc = info.OnSuccessFunc;
        self.OnFailFunc = info.OnFailFunc;
    }
    return self;
}

- (instancetype)initWithBaseSendInfo:(BaseSendInfoGJM*)info
{
    self = [self initInfo:info];
    if (self) {
        if (info.mode != 0) {
            self.updata_data = [info pack_to_nsdata];
            self.media_data = info.media_data;
        }else{
        }
        
    }
    return self;
}

- (instancetype)initWithSynchronousBaseSendInfo:(BaseSendInfoGJM*)info
{
    self = [self initInfo:info];
    if (self) {
        if (info.mode != 0) {
            if (info.media_data.count >0) {
                [self addMedia:info];//写表单
            }else{
                self.updata_data = [info pack_to_nsdata];
                self.media_data = nil;
            }
        }
    }
    return self;
}


- (void)addMedia:(BaseSendInfoGJM*)info
{
    NSDictionary *dic = [info getParameters];
    NSMutableData *pns_data = [NSMutableData data];

    NSArray *keys = [dic allKeys];
    long space_rand = random();
    NSData *pspace_str = [[NSString stringWithFormat:@"--Jf@WlKj$#*%lX",space_rand] dataUsingEncoding:NSUTF8StringEncoding]; //间隔符
    NSData *pspace_fu = [@"--" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *return_char = [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    
    for (NSString *key in keys) {
        NSString *value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber*)value stringValue];
        }else if (![value isKindOfClass:[NSString class]]){
            value = nil;
        }
        if (value.length>0) {
            NSData *jsonData= [value dataUsingEncoding:NSUTF8StringEncoding];
            [pns_data appendData:pspace_fu];
            [pns_data appendData:pspace_str];
            [pns_data appendData:return_char];
            [pns_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            [pns_data appendData:jsonData];
            [pns_data appendData:return_char];
        }
    }
    for(NCNetMediaCakeData *pnet_data in info.media_data)
    {
        [pns_data appendData:return_char];
        [pns_data appendData:pspace_fu];
        [pns_data appendData:pspace_str];
        [pns_data appendData:return_char];
        [pns_data appendData:[pnet_data out_data]];
    }
    
    //结束
    [pns_data appendData:return_char];
    [pns_data appendData:pspace_fu];
    [pns_data appendData:pspace_str];
    [pns_data appendData:pspace_fu];
    
    self.updata_data = pns_data;
}

- (void)clean
{
    self.OnFailFunc = nil;
    self.OnSuccessFunc = nil;
    self.UploadProgress = nil;
    self.updata_data = nil;
    self.download_data = nil;
    self.resultsDic = nil;
}
@end


@implementation NCNetWorkNetManager
static NCNetWorkNetManager *shareNCNetWorkNetManager = nil;
@synthesize requestQueue = _requestQueue, waitQueue = _waitQueue;

+(NCNetWorkNetManager*)shareNCNetWorkNetManager;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNCNetWorkNetManager = [[self alloc]init];
    });
    return shareNCNetWorkNetManager;
}
-(instancetype)init
{
    [self reachability];
    return self;
}
- (DictionaryQueue *)requestQueue
{
    if (_requestQueue == nil) {
        _requestQueue = [DictionaryQueue creatQueueMaxCount:MAXREQUESTCOUNT];
    }
    return _requestQueue;
}

- (QueueObj *)waitQueue
{
    if (_waitQueue == nil) {
        _waitQueue = [QueueObj creatQueueMaxCount:MAXWAITCOUNT];
    }
    return _waitQueue;
}
+ (void)openWrapTest:(BOOL)open testClass:(Class)class
{
    [NCNetWorkNetManager shareNCNetWorkNetManager]->_openTest = open;
    [NCNetWorkNetManager shareNCNetWorkNetManager]->_testClass = class;
}
+ (void)openLog:(BOOL)open
{
    [NCNetWorkNetManager shareNCNetWorkNetManager]->_openLogin = open;
}
#pragma mark ------ 网络监控 ------
- (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        if (status >0) {
            if ([NCNetWorkNetManager shareNCNetWorkNetManager].netState != NetManageWaitReset) {
                [NCNetWorkNetManager shareNCNetWorkNetManager]->_netState = NetManageActivce;
            }
        }else{
            [NCNetWorkNetManager shareNCNetWorkNetManager]->_netState = NetManagePasue;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

#pragma mark ------ 接收请求 ------
//同步请求
+(id)connectSyncUrl:(BaseSendInfoGJM *)send_struct error:(NSError**)error
{
    NCNetConnData *pnet_data = [[NCNetConnData alloc]initWithSynchronousBaseSendInfo:send_struct];
    return [[NCNetWorkSendManager shareAFNManager] startSyncConnect:pnet_data error:error];//开始请求
}
//异步请求
+(void)connectUrl:(BaseSendInfoGJM *)send_struct OnSuccess:(void (^)(id result))Onsuccess onfail:(void (^)(NSError *result))Onfail
{
    send_struct.OnSuccessFunc = Onsuccess;
    send_struct.OnFailFunc = Onfail;
    //服务器交互状态
    if ([NCNetWorkNetManager shareNCNetWorkNetManager].netState == NetManageActivce) {
        if ([[NCNetWorkNetManager shareNCNetWorkNetManager] chickWaitQueue]) {
            BOOL sendtNow = [[NCNetWorkNetManager shareNCNetWorkNetManager].requestQueue pushQueue:send_struct];
            if(sendtNow)
            {
                [[NCNetWorkNetManager shareNCNetWorkNetManager] connectUrl:send_struct];//开始请求 进入请求队列
            }else
            {
                [[NCNetWorkNetManager shareNCNetWorkNetManager].waitQueue pushQueue:send_struct];//进入等待队列
            }

        }else{
            [[NCNetWorkNetManager shareNCNetWorkNetManager].waitQueue pushQueue:send_struct];//进入等待队列
        }

    }else{
         [[NCNetWorkNetManager shareNCNetWorkNetManager].waitQueue pushQueue:send_struct];//进入等待队列
    }
    
}
+(void)connectUrl:(BaseSendInfoGJM *)send_struct progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress OnSuccess:(void (^ _Nonnull)(id _Nonnull result))Onsuccess onfail:(void (^ _Nonnull)(NSError * _Nonnull result))Onfail
{
    send_struct.UploadProgress = uploadProgress;
    [self connectUrl:send_struct OnSuccess:Onsuccess onfail:Onsuccess];
}

#pragma mark ------ 发送请求 ------
//异步
-(void)connectUrl:(BaseSendInfoGJM *)send_struct
{
    NCNetConnData *pnet_data = [[NCNetConnData alloc]initWithBaseSendInfo:(BaseSendInfoGJM *)send_struct];
    [[NCNetWorkSendManager shareAFNManager] startConnect:pnet_data];//开始请求
}

#pragma mark ------ 请求结果 ------

+(void)AFNCompleteProgress:(NCNetConnData *)connData progress:(NSProgress * )uploadProgress
{
    if(connData.UploadProgress) (connData.UploadProgress)(uploadProgress);
}

+(void)AFNCompleteSuccess:(NCNetConnData *)connData responseObject:(id)responseObject
{
    [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount--;
    [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount = MAX(0,[NCNetWorkNetManager shareNCNetWorkNetManager].afnCount);

    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount++;
        [NCNetWorkNetManager AFNCompleteFail:connData error:err];
        return;
    }
    
    //检测是否替换测试数据
    if ([NCNetWorkNetManager shareNCNetWorkNetManager].openTest) {
        //检测是否替换测试数据
        SEL testSel = NSSelectorFromString(NSStringFromClass(((BaseSendInfoGJM*)connData.send_wrap).class)) ;
        SuppressPerformSelectorLeakWarning(dic = [[NCNetWorkNetManager shareNCNetWorkNetManager].testClass performSelector:testSel withObject:dic]); //替换成测试数据
    }

    id return_data = [connData.send_wrap return_unpack_wrap:dic];
    if(return_data != nil)
    {
        connData.recv_wrap = return_data;
        [return_data update_info:connData.send_wrap];
        if(connData.OnSuccessFunc) (connData.OnSuccessFunc)(return_data);
    }else{
        err = [[NSError alloc]initWithDomain:@"解析出错" code:-1000 userInfo:[[NSDictionary alloc]initWithObjectsAndKeys:@"找不到回调",@"NSDebugDescription", nil]];

        [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount++;
        [NCNetWorkNetManager AFNCompleteFail:connData error:err];
        return;
    }
    [[NCNetWorkNetManager shareNCNetWorkNetManager].requestQueue popQueueObj:connData.send_wrap];
    connData = nil;
    [[NCNetWorkNetManager shareNCNetWorkNetManager] chickWaitQueue];
}
+(void)AFNCompleteFail:(NCNetConnData *)connData error:(NSError *)error
{
    [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount--;
    [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount = MAX(0,[NCNetWorkNetManager shareNCNetWorkNetManager].afnCount);
    if(connData.OnFailFunc) (connData.OnFailFunc)(error);
    if (error.userInfo[@"NSDebugDescription"]) {
        NSLog(@"%@",error.userInfo[@"NSDebugDescription"]);
    }
    [[NCNetWorkNetManager shareNCNetWorkNetManager].requestQueue popQueueObj:connData.send_wrap];
    connData = nil;
    [[NCNetWorkNetManager shareNCNetWorkNetManager] chickWaitQueue];
}

#pragma mark ------ 检测等待队列 ------

- (BOOL)chickWaitQueue
{
    if (self.waitQueue.queueCount > 0) {
        if (![NCNetWorkNetManager shareNCNetWorkNetManager].requestQueue.queueFill) {
            id sendObj = [self.waitQueue popQueue];//移出队列
            NSLog(@"\n --- 从等待队列拿出 %@ --------\n 进行请求",[sendObj debugDescription]);
            BOOL sendtNow = [[NCNetWorkNetManager shareNCNetWorkNetManager].requestQueue pushQueue:sendObj];
            if (sendtNow) {
                [[NCNetWorkNetManager shareNCNetWorkNetManager] connectUrl:sendObj];//开始请求
            }
        }
        return false;
    }else{
        return true;
    }
}



@end
