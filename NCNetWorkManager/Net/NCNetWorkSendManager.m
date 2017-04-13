 //
//  GuanjiaMiaoAFHManager.m
//  MiaowStudentPro
//
//  Created by luck chen on 2016/12/7.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCNetWorkSendManager.h"
#import "MJExtension.h"
//#import "NSURLSession.h"

static NCNetWorkSendManager * shareAFNManager = nil;
@implementation NCNetWorkSendManager

+ (NCNetWorkSendManager*)shareAFNManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAFNManager = [[NCNetWorkSendManager alloc]init];
    });
    return shareAFNManager;
}

- (NSString*)getHttpAction:(NSInteger)mode
{
    NSArray *array = @[@"getAction:",@"postAction:",@"putAction:",@"delAction:"];
    return (mode < array.count)?array[mode]:nil;
}
- (NSString*)getSyncMode:(NSInteger)mode
{
    NSArray *array = @[@"GET",@"POST",@"PUT",@"DELETE"];
    return (mode < array.count)?array[mode]:nil;
}

/*
 http头文件编辑
 */
- (NSDictionary*)headerFields:(NCNetConnData *)pnet_data
{
    NSMutableDictionary *headerField = [[NSMutableDictionary alloc]init];

    NSString *model = [[NSString alloc]initWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
    
    [headerField setValue:@"application/json" forKey:@"Accept"];
    [headerField setValue:model forKey:@"X-Oc-Os-Model"];
    [headerField setValue:pnet_data.Content_Type forKey:@"Content-Type"];
    
    return headerField;
}
//同步请求
- (id)startSyncConnect:(NCNetConnData *)pnet_data error:(NSError **)error
{
    [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount++;
    
    return [self syncRequest:pnet_data headerFields:[self headerFields:pnet_data] error:error];
}

//异步请求
- (void)startConnect:(NCNetConnData *)pnet_data
{
    NSDictionary* headerFields =[self headerFields:pnet_data];
     [NCNetWorkNetManager shareNCNetWorkNetManager].afnCount++;

    unsigned over_time = pnet_data.over_time;
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.requestSerializer.timeoutInterval = over_time;
    for (NSString *key in [headerFields allKeys]) {
        [self.requestSerializer setValue:headerFields[key] forHTTPHeaderField:key];
    }
    NSString *smlSTR = [self getHttpAction:pnet_data.http_mode];
    SuppressPerformSelectorLeakWarning([self performSelector:NSSelectorFromString(smlSTR) withObject:pnet_data]);
}


- (void)getAction:(NCNetConnData *)pnet_data
{
    __strong typeof(pnet_data) strongPnet_data = pnet_data;
    [shareAFNManager GET:[pnet_data.url absoluteString]  parameters:[pnet_data.send_wrap getParameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        [NCNetWorkNetManager AFNCompleteProgress:strongPnet_data progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NCNetWorkNetManager AFNCompleteSuccess:strongPnet_data responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NCNetWorkNetManager AFNCompleteFail:strongPnet_data error:error];
    }];
}

- (void)postAction:(NCNetConnData *)pnet_data
{
    __strong typeof(pnet_data) strongPnet_data = pnet_data;
    //图文/媒体上传
    [self POST:[pnet_data.url absoluteString] parameters:[pnet_data.send_wrap getParameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        for(NCNetMediaCakeData *pnet_data in strongPnet_data.media_data)
        {
            [formData appendPartWithFileData:pnet_data.content_data name:pnet_data.name_key fileName:pnet_data.file_name mimeType:pnet_data.content_type];

        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [NCNetWorkNetManager AFNCompleteProgress:strongPnet_data progress:uploadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NCNetWorkNetManager AFNCompleteSuccess:strongPnet_data responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NCNetWorkNetManager AFNCompleteFail:strongPnet_data error:error];
    }];
}

- (void)putAction:(NCNetConnData *)pnet_data
{
    __strong typeof(pnet_data) strongPnet_data = pnet_data;
    [self PUT:[pnet_data.url absoluteString]  parameters:[pnet_data.send_wrap getParameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NCNetWorkNetManager AFNCompleteSuccess:strongPnet_data responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NCNetWorkNetManager AFNCompleteFail:strongPnet_data error:error];
    }];
}

- (void)delAction:(NCNetConnData *)pnet_data
{
    __strong typeof(pnet_data) strongPnet_data = pnet_data;
    [self DELETE:[pnet_data.url absoluteString]  parameters:[pnet_data.send_wrap getParameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [NCNetWorkNetManager AFNCompleteSuccess:strongPnet_data responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [NCNetWorkNetManager AFNCompleteFail:strongPnet_data error:error];

    }];
}

#pragma mark - 同步请求
-(id)syncRequest:(NCNetConnData *)pnet_data headerFields:(NSDictionary*)headerFields error:(NSError**)error
{
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:pnet_data.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:pnet_data.over_time];
    request.allHTTPHeaderFields = headerFields;
    [request setHTTPMethod:[self getSyncMode:pnet_data.http_mode]];//设置请求方式，默认为GET
    [request setHTTPBody:pnet_data.updata_data];
    
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    //
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSData *received;
    __block NSError *err = nil;

    /**
     参数一:请求对象
     参数二:block块
     data :响应体
     response:响应头
     error :错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable erro) {
        received = data;
        err = erro;
        dispatch_semaphore_signal(semaphore);   //发送信号
    }];
    
    [dataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    if (err) {
        *error = err;
        [NCNetWorkNetManager addError:err.userInfo postNsme:pnet_data.url.absoluteString];
    }

    NSLog(@"数据加载完成！");
    
    return [self upData:pnet_data responseObject:received error:error];
}

- (id)upData:(NCNetConnData *)connData responseObject:(NSData*)responseObject error:(NSError**)error
{
    NSError *err;

    if (!responseObject) {
        err = [[NSError alloc]initWithDomain:@"获取不到数据" code:-1000 userInfo:[[NSDictionary alloc]initWithObjectsAndKeys:@"数据为空",@"NSDebugDescription", nil]];
        *error = err;
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSString *json = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (error) {
            *error = err;
        }
        return json;
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
    }
    if (err) {
        *error = err;
    }
    return return_data;
}
@end
