//
//  StackObj.m
//  MiaowStudentPro
//
//  Created by luck chen on 2016/12/5.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "StackObj.h"

@interface StackObj ()
@property (nonatomic,strong) NSMutableArray *stackArray;

@end
@implementation StackObj

+ (instancetype)creatStack
{
    StackObj *stack = [[StackObj alloc]init];
    if (stack) {
        stack->_maxCount = 1000;
    }
    return stack;
}
+ (instancetype)creatQueueMaxCount:(NSInteger)maxCount
{
    StackObj *stack = [[StackObj alloc]init];
    stack->_maxCount = maxCount;
    return stack;
}


- (NSMutableArray *)stackArray
{
    if (_stackArray == nil) {
        _stackArray = [[NSMutableArray alloc]init];
    }
    return _stackArray;
}

- (id)stackTop
{
    if (!self.stackNULL) {
        return [self.stackArray lastObject];
    }
    return nil;
}

- (id)stackBottom
{
    if (!self.stackNULL) {
        return [self.stackArray firstObject];
    }
    return nil;

}

- (BOOL)stackNULL
{
    return !(self.stackArray.count >0);
}

- (NSInteger)stackCount
{
    return self.stackArray.count;
}

- (NSInteger)currentSubscript
{
    return MAX(0, self.stackArray.count -1);
}

- (BOOL)cleanStack
{
    [self.stackArray removeAllObjects];
    return true;
}
- (BOOL)pushStack:(id)obj
{
    if (self.stackCount >= self.maxCount) {
        return false;
    }
    if (obj) {
        [self.stackArray addObject:obj];
        return true;
    }
    return false;
}
- (BOOL)popStack
{
    if (!self.stackNULL) {
        [self.stackArray removeLastObject];
        return true;
    }
    return false;
}
- (BOOL)reverse
{
    self.stackArray = [[NSMutableArray alloc]initWithArray:[[self.stackArray reverseObjectEnumerator] allObjects]];
    return true;
}
@end
