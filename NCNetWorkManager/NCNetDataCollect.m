//
//  CNNetModel.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/17.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "NCNetDataCollect.h"

@implementation NCNetDataCollect

@end

@implementation NCNetWorkData
+(NCNetWorkData *)shareNCNetWorkData
{
    static NCNetWorkData *shareNCNetWorkData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNCNetWorkData = [[self alloc]init];
    });
    return shareNCNetWorkData;
}

- (void)setServer:(ServerModel*)model
{
    self->_server = model;
}
@end


@implementation People
@end

@implementation UserData
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userList = [NCNSMutableArray arrayWithObjectClass:UserData.class];//初始化，指定数组里的对象类型UserData.class
        self.carList = [NCNSMutableArray arrayWithObjectClass:Car.class];//初始化，指定carList数组里的对象类型Car
        
    }
    return self;
}

@end

@implementation ServerModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userList = [NCNSMutableArray arrayWithObjectClass:UserData.class];
    }
    return self;
}

@end

@implementation Car

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userList = [NCNSMutableArray arrayWithObjectClass:People.class];
    }
    return self;
}

@end
