//
//  QueueObj.m
//  MiaowStudentPro
//
//  Created by luck chen on 2016/12/6.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "QueueObj.h"
@interface QueueObj ()
@property (nonatomic,strong) NSMutableArray *queueArray;
@end
@implementation QueueObj

+ (instancetype)creatQueue
{
    QueueObj *queue = [[QueueObj alloc]init];
    if (queue) {
        if (queue) {
            queue->_maxCount = powf(10, 10);
        }

    }
    return queue;
}

+ (instancetype)creatQueueMaxCount:(NSInteger)maxCount
{
    QueueObj *queue = [[QueueObj alloc]init];
    queue->_maxCount = maxCount;
    return queue;
}


- (NSMutableArray *)queueArray
{
    if (_queueArray == nil) {
        _queueArray = [[NSMutableArray alloc]init];
    }
    return _queueArray;
}

- (id)queueTop
{
    if (!self.queueNULL) {
        return [self.queueArray firstObject];
    }
    return nil;
}

- (id)queueBottom
{
    if (!self.queueNULL) {
        return [self.queueArray lastObject];
    }
    return nil;
    
}

- (BOOL)queueNULL
{
    return !(self.queueArray.count >0);
}

- (NSInteger)queueCount
{
    return self.queueArray.count;
}

- (BOOL)cleanQueue
{
    [self.queueArray removeAllObjects];
    return true;
}
- (BOOL)pushQueue:(id)obj
{
    if (self.queueCount >= self.maxCount) {
        return false;
    }
    if (obj) {
        [self.queueArray addObject:obj];
        return true;
    }
    return false;
}
- (id)popQueue
{
    if (!self.queueNULL) {
        id obj = [self.queueArray objectAtIndex:0];
        [self.queueArray removeObjectAtIndex:0];
        return obj;
    }
    return nil;
}

- (BOOL)reverse
{
    NSArray *array = [[self.queueArray reverseObjectEnumerator] allObjects];
    self.queueArray = [[NSMutableArray alloc]initWithArray:array];
    return true;
}

@end
