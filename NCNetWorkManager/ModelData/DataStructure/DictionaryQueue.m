//
//  DictionaryQueue.m
//  MiaowStudentPro
//
//  Created by luck chen on 2016/12/6.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "DictionaryQueue.h"

@interface DictionaryQueue()
@property (nonatomic,strong) NSMutableArray *queueArray;
@property (nonatomic,strong) NSMutableDictionary *queueDic;
@end
@implementation DictionaryQueue

- (NSMutableDictionary *)queueDic
{
    if (_queueDic == nil) {
        _queueDic = [[NSMutableDictionary alloc]init];
    }
    return _queueDic;
}
- (NSMutableArray *)queueArray
{
    if (_queueArray == nil) {
        _queueArray = [[NSMutableArray alloc]init];
    }
    return _queueArray;
}


+ (instancetype)creatQueue
{
    DictionaryQueue *queue = [[DictionaryQueue alloc]init];
    queue->_maxCount = powf(10, 10);

    return queue;
}
+ (instancetype)creatQueueMaxCount:(NSInteger)maxCount
{
    DictionaryQueue *queue = [[DictionaryQueue alloc]init];
    queue->_maxCount = maxCount;
    return queue;
    
}
- (BOOL)cleanQueue
{
    [self.queueArray removeAllObjects];
    [self.queueDic removeAllObjects];
    return true;
}

- (NSInteger)queueCount
{
    return self.queueArray.count;
}

- (BOOL)queueFill
{
    return (self.maxCount <= self.queueCount);
}
- (id)queueTop{
    if (self.queueArray.count > 0) {
        NSString *key = [self.queueArray firstObject];
        id obj = [self.queueDic objectForKey:key];
        return obj;
    }
    return nil;
}

- (id)queueBottom
{
    if (self.queueArray.count > 0) {
        NSString *key = [self.queueArray lastObject];
        id obj = [self.queueDic objectForKey:key];
        return obj;
    }
    return nil;

}

- (BOOL)pushQueue:(id)obj
{
    if (self.queueCount >= self.maxCount) {
        return false;
    }
    NSInteger index = 0;
    if (self.queueBottom) {
        while (index <= [[self.queueArray lastObject] integerValue]) {
            index ++;
        }
    }
    [self.queueArray addObject:[[NSString stringWithFormat:@"%ld",(long)index] copy]];
    [self.queueDic setObject:obj forKey:[NSString stringWithFormat:@"%ld",(long)index]];
    return true;
}

- (id)popQueue
{
    if (self.queueArray.count >0) {
        NSString *key = self.queueTop;
        id obj = [self popQueueKey:key];
        [self.queueArray removeObjectAtIndex:0];
        return obj;

    }else{
        return false;
    }
}
- (BOOL)popQueue:(NSInteger)index
{
    NSString *key = [self getQueueObj:index];
    [self popQueueKey:key];
    return [self popQueue:index];
}
- (id)popQueueKey:(NSString*)key
{
    id obj = [self.queueDic objectForKey:key];
    [self.queueDic removeObjectForKey:key];
    return obj;
}
- (BOOL)popQueueObj:(id)obj
{
    if (obj == nil) {
        return false;
    }
    NSString *removeKey ;
    for (NSString *key in [self.queueDic allKeys]) {
        if ([self.queueDic objectForKey:key] == obj) {
            [self.queueArray removeObject:key];
            removeKey = key;
            continue;
        }
    }
    [self.queueDic removeObjectForKey:removeKey];
    return true;
}

- (id)getQueueObj:(NSInteger)index
{
    if (!self.queueNULL && index <self.queueCount-1) {
        return [self.queueArray objectAtIndex:index];
    }
    return false;
    
}

- (BOOL)reverse
{
    NSArray *array = [[self.queueArray reverseObjectEnumerator] allObjects];
    self.queueArray = [[NSMutableArray alloc]initWithArray:array];
    return true;
}

@end
