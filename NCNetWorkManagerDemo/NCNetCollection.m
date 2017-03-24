//
//  CNNetCollection.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/17.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "NCNetCollection.h"
#import "NSArray+AssociatedObject.h"
@implementation NCNetCollection

@end
@interface UpdateServer()
@property(nonatomic,strong,readonly) NSString *name;
@end

@implementation UpdateServer

RETURN_MODEL(Re_UpdateServer)
@end

@implementation Re_UpdateServer
RETURN_MODEL_FUNC(Re_UpdateServer)
/*
 初始化，非必需方法，有定义对象数组时需要实现并初始化对象数组，指定类型
 */
- (instancetype)init
{
    self = [super init];
    self.userList = [[NSMutableArray alloc]initWithChildClass:UserData.class];
    NSLog(@"self.userList class = %@",self.userList.childClass);

    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSLog(@"array class = %@",array.childClass);
    return self;
}
/*
 解析方法，(json -> dic) - > model ，非必需方法，需要特殊处理时才重写
 */
- (BOOL)unpack_nsdic:(NSDictionary *)dic
{
    return [super unpack_nsdic:dic];
}
/*
 数据解析完成后回调，可以在此作业务逻辑的视线（数据持久化之类）
 */
- (void)update_info:(id)send_struct
{
    [[NCNetWorkData shareNCNetWorkData] setServer:self.data];
}
@end
