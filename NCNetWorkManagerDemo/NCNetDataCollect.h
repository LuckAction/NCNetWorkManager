//
//  CNNetModel.h
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/17.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCNetModel.h"
@class UserData;
@class People;
@class ServerModel;

@interface NCNetDataCollect : NSObject

@end
/*
 NCNetWorkData
 全局数据管理类
 */
@interface NCNetWorkData : NSObject
@property(nonatomic,strong) UserData *userData;
@property(nonatomic,readonly) ServerModel *server;

+(NCNetWorkData *)shareNCNetWorkData;
- (void) setServer:(ServerModel*)model;
@end


#pragma mark -ServerModel
@interface ServerModel: NCNetModel
@property (nonatomic,strong) NSString* api_host;
@property (nonatomic,strong) NSString* img_host;
@property (nonatomic,strong) NSString* upgrade_link;
@property (nonatomic,strong) NSString* maintenance_message;
@property (nonatomic,assign) NSInteger maintenance_mode;
@property (nonatomic,strong) NSString* upgrade_message;
@property (nonatomic,assign) BOOL isShowQuestionAnswer;
@property (nonatomic,strong) People *user;
@property (nonatomic,strong) NSMutableArray* userList;

@end

#pragma mark -UserData

/*
 People
 基础的人物结构
 */
@interface People : NCNetModel
@property(nonatomic,assign) NSInteger customer_id;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* sex;

@end
/*
 UserData
 用户结构
 */
@interface UserData : People
@property (nonatomic,strong) NSMutableArray* userList;
@property (nonatomic,strong) UserData *child;
@property (nonatomic,strong) NSMutableArray* carList;

@end
/*
 Car
 汽车结构
 */
@interface Car : NCNetModel
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* color;
@property (nonatomic,strong) NSMutableArray* userList;//汽车的使用者列表People

@end
