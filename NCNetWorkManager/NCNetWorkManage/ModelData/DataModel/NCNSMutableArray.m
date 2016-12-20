//
//  NCNSMutableArray.m
//
//  Created by luck chen on 2016/12/15.
//  Copyright © 2016年 kewaimiao.com. All rights reserved.
//

#import "NCNSMutableArray.h"
#import "MJExtension.h"

@interface NCNSMutableArray ()
@property (nonatomic,strong) NSMutableArray *objArray;
@end

@implementation NCNSMutableArray

+ (instancetype)array
{
    NCNSMutableArray *ncObj = [[NCNSMutableArray alloc]init];
    return ncObj;
}
+ (instancetype)arrayWithObjectClass:(Class)class
{
    NCNSMutableArray *ncObj = [NCNSMutableArray array];
    ncObj->_objClass = class;
    return ncObj;
}
+ (instancetype)arrayWithArray:(NSArray*)array
{
    NCNSMutableArray *ncObj = [NCNSMutableArray array];
    ncObj.objArray = [[NSMutableArray alloc]initWithArray:array];
    return ncObj;
}

+ (instancetype)arrayWithObjectClass:(Class)class array:(NSArray*)array
{
    NCNSMutableArray *ncObj = [NCNSMutableArray arrayWithObjectClass:class];
    ncObj.objArray = [[NSMutableArray alloc]initWithArray:array];
    return ncObj;
}

- (NSMutableArray *)objArray
{
    if (_objArray == nil) {
        _objArray = [[NSMutableArray alloc]init];
    }
    return _objArray;
}

-(NSInteger)count
{
    return self.objArray.count;
}
- (id)objectAtIndex:(NSUInteger)index
{
    return [self.objArray objectAtIndex:index];
}

- (void)addObject:(id)anObject
{
    [self.objArray addObject:anObject];
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    [self.objArray insertObject:anObject atIndex:index];
}
- (void)removeLastObject
{
    if (self.objArray.count > 0) {
        [self.objArray removeLastObject];
    }
}
- (void)removeObjectAtIndex:(NSUInteger)index
{
    if (self.objArray.count > index) {
        [self.objArray removeObjectAtIndex:index];
    }

}
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (self.objArray.count > index) {
        [self.objArray replaceObjectAtIndex:index withObject:anObject];
    }

}

- (void)addObjectsFromArray:(NSArray<id> *)otherArray
{
    [self.objArray addObjectsFromArray:otherArray];
}
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    [self.objArray exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}
- (void)removeAllObjects
{
    [self.objArray removeAllObjects];
}
- (void)removeObject:(id)anObject inRange:(NSRange)range
{
    [self.objArray removeObject:anObject inRange:range];
}
- (void)removeObject:(id)anObject
{
    [self.objArray removeObject:anObject];
}
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range
{
    [self.objArray removeObjectIdenticalTo:anObject inRange:range];
}
- (void)removeObjectIdenticalTo:(id)anObject
{
    [self.objArray removeObjectIdenticalTo:anObject];
}
- (void)removeObjectsInArray:(NSArray<id> *)otherArray
{
    [self.objArray removeObjectsInArray:otherArray];
}
- (void)removeObjectsInRange:(NSRange)range
{
    [self.objArray removeObjectsInRange:range];
}
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray range:(NSRange)otherRange
{
    [self.objArray replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray
{
    [self.objArray replaceObjectsInRange:range withObjectsFromArray:otherArray];
}
- (void)setArray:(NSArray<id> *)otherArray
{
    [self.objArray setArray:otherArray];
}

- (void)insertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes
{
    [self.objArray insertObjects:objects atIndexes:indexes];
}
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    [self.objArray removeObjectsAtIndexes:indexes];
}
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<id> *)objects
{
    [self.objArray replaceObjectsAtIndexes:indexes withObjects:objects];
}

- (BOOL)containsObject:(id)anObject
{
    return [self.objArray containsObject:anObject];
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.objArray countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)pasing:(id)object key:(NSString*)key{
    if (self.objClass) {
        id child = object[key];
        if ([child isKindOfClass:[NSArray class]] || [child isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *array = child;
            for (id childData in array) {
                NCNetModel *resultsObj = [self.objClass mj_objectWithKeyValues:childData];
                [resultsObj unpack_nsdic:child];
                [self addObject:resultsObj];
            }
            
        }else if([object isKindOfClass:[NSDictionary class]]){
            child = [self.objClass mj_objectWithKeyValues:child];
            [child unpack_nsdic:child];
            if (child) [self addObject:child];
        }else{
            return child;
        }
        return self;
    }
    return nil;
}
@end
