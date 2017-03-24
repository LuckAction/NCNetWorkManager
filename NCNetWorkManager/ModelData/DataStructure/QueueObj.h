//
//  QueueObj.h
//  MiaowStudentPro
//
//  Created by luck chen on 2016/12/6.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueObj : NSObject
@property (nonatomic,readonly) NSInteger queueCount;
@property (nonatomic,readonly) NSInteger maxCount;
@property (nonatomic,readonly) BOOL queueNULL;
@property (nonatomic,readonly) id queueTop;
@property (nonatomic,readonly) id queueBottom;

+ (instancetype)creatQueue;
+ (instancetype)creatQueueMaxCount:(NSInteger)maxCount;
- (BOOL)cleanQueue;
- (BOOL)pushQueue:(id)obj;
- (id)popQueue;
//拓展方法，不属于队列的定义
- (BOOL)reverse;

@end
