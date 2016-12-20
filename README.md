# NCNetWorkingManager
网络管理和数据自动解析
NCNetWorkManager

NCNetWorkManager 居于AFNWorking和MJExtension 进行二次封装的类库，更简便的请求与封装解析，不用再去理会繁琐的回调与数据的解析封装。 主要功能与使用步骤： 
1.将要进行网络交互的信息封装成自定义的结构，
2.利用NCNetWorkNetManager发送请求与接收结果

使用案例：

//NCNetWorkWrapStruct.h 文件里 @interface UpdateServer : PostSend//发送结构

@end @interface Re_UpdateServer : BaseRecvInfo//接收结构
@property(nonatomic,assign) BOOL sex; 
@property(nonatomic,assign) NSInteger age; 
@property(nonatomic,strong) NSString *name; 
@property(nonatomic,strong) ServerModel *data;//自定义的结构 
@property(nonatomic,strong) NCNSMutableArray *userList;//自定义的UserData对象数组

@end

//NCNetWorkWrapStruct.m 文件里 @implementation UpdateServer RETURN_MODEL(Re_UpdateServer) @end

@implementation Re_UpdateServer RETURN_MODEL_FUNC(Re_UpdateServer)

-(instancetype)init { self = [super init]; 
		self.userList = [NCNSMutableArray arrayWithObjectClass:UserData.class]; return self; }

-(void)update_info:(id)send_struct { if(self){} } @end

//请求案例 
//1.同步请求 
//同步请求测试用例 
UpdateServer *update = [[UpdateServer alloc]init]; 
update.url = @"http://www.baidu.com"; NSError *error = nil;
Re_UpdateServer *result = [NCNetWorkNetManager connectSyncUrl:update error:&error]; 
if (error) { NSLog(@"%@",error); } 
if (result) { NSLog(@"%@",result); }

//1.异步请求 
//异步请求测试用例
[NCNetWorkNetManager connectUrl:update progress:^(NSProgress * _Nonnull progress) { 
NSLog(@"请求进度 ------ %@",progress); 
} OnSuccess:^(Re_UpdateServer* _Nonnull result) {
NSLog(@"%@",result); 
} onfail:^(NSError * _Nonnull result) {
NSLog(@"%@",result); 
}];
