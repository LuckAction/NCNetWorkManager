//
//  NetManage.h
//  Miaow
//
//  Created by chenhenian on 16/4/5.
//  Copyright (c) 2016年 Miaow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueueObj.h"
#import "DictionaryQueue.h"
#import "NCLogManager.h"

#define MAXREQUESTCOUNT 10
#define MAXWAITCOUNT    10
#define OVERTIME        30

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@class NCNetWorkSendManager;

typedef enum : NSUInteger
{
    eHttpGet = 0,
    eHttpPost = 1,
    eHttpPut = 2,
    eHttpDelete = 3
    
} HootMode;



@interface NCNetMediaCakeData : NSObject

@property(nonatomic,copy) NSString *name_key; //键值
@property(nonatomic,copy) NSString *content_type; //内容
@property(nonatomic,copy) NSString *file_name; //来源文件名
@property(nonatomic,strong) NSData *content_data; //内容
//-(NSData *)out_data;

@end
#import "NCNetWorkWrapStruct.h"

@interface NCNetConnData : NSObject
@property (nonatomic,strong) NSURL *url; //网路地址
@property (nonatomic,assign) BOOL isNeedStore_id; //是否需要站点
@property (nonatomic,copy) NSString *Content_Type;
@property (nonatomic,assign) unsigned level; //优先级(0,最高)
@property (nonatomic,assign) uint64_t task_time; //任务时间
@property (nonatomic,assign) unsigned over_time; //超时时间
@property (nonatomic,assign) BOOL isSynchronous;//是否同步
@property (nonatomic,strong) void (^OnSuccessFunc)(id result);
@property (nonatomic,strong) void (^OnFailFunc)(NSError *);
@property (nonatomic,strong) void (^UploadProgress)(NSProgress * );
@property (nonatomic,strong) id send_wrap; //发送结构
@property (nonatomic,strong) id recv_wrap; //接收结构
@property (nonatomic,strong) NSData *updata_data; //上传数据
@property (nonatomic,strong) NSMutableArray *media_data; //媒体数据
@property (nonatomic,strong) NSMutableData *download_data; //下载数据
@property (nonatomic,assign) HootMode http_mode; //http mode
@property (nonatomic,copy) NSDictionary* resultsDic; //结果

- (instancetype)initWithBaseSendInfo:(BaseSendInfoGJM*)info;
- (instancetype)initWithSynchronousBaseSendInfo:(BaseSendInfoGJM*)info;
- (void)clean;
@end

typedef NS_ENUM(NSInteger,NetManageState) {
    NetManageActivce,
    NetManagePasue,
    NetManageWaitReset
};

@interface NCNetWorkNetManager : NSObject
@property (nonatomic,readonly) DictionaryQueue *requestQueue;
@property (nonatomic,readonly) NCLogManager *logManager;
@property (nonatomic,readonly) QueueObj *waitQueue;
@property (nonatomic,assign)   NSInteger afnCount; //当前连接数
@property (nonatomic,readonly) NetManageState netState;
@property (nonatomic,assign,readonly) BOOL openTest;
@property (nonatomic,assign,readonly) BOOL openLogin;
@property (nonatomic,assign,readonly) Class testClass;
@property (copy,nonatomic,readonly) NSString *url;
@property (assign,nonatomic,readonly) NSInteger total;


- (instancetype)init;
+ (NCNetWorkNetManager*)shareNCNetWorkNetManager;
+ (void)openWrapTest:(BOOL)open testClass:(Class)_class;
+ (void)openLog:(BOOL)open;
+ (void)setErrorLog:(NSString*)url maxTotal:(NSInteger)total;


NS_ASSUME_NONNULL_BEGIN
+ (void)connectUrl:(BaseSendInfoGJM *)send_struct;
+ (id)connectSyncUrl:(BaseSendInfoGJM *)send_struct error:(NSError**)error;
+ (void)connectUrl:(BaseSendInfoGJM *)send_struct OnSuccess:(void (^)(id result))Onsuccess onfail:(void (^)(NSError *result))Onfail;
+ (void)connectUrl:(BaseSendInfoGJM *)send_struct progress:(nullable void (^)(NSProgress *   progress))uploadProgress OnSuccess:(void (^  )(id   result))Onsuccess onfail:(void (^  )(NSError *   result))Onfail;
//回调
+ (void)AFNCompleteSuccess:(NCNetConnData * )connData responseObject:(id  )responseObject;
+ (void)AFNCompleteProgress:(NCNetConnData *)connData progress:(NSProgress * )uploadProgress;
+ (void)AFNCompleteFail:(NCNetConnData *)connData error:(NSError * )error;

+ (void)addError:(NSDictionary*)dic postNsme:(NSString*)url;

//down & up

NS_ASSUME_NONNULL_END


@end
