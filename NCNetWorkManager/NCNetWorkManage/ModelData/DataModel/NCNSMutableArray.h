//
//  NCNSMutableArray.h
//
//  Created by luck chen on 2016/12/15.
//  Copyright © 2016年 kewaimiao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCNSMutableArray : NSObject
@property (assign,nonatomic,readonly) NSInteger count;
@property (nonatomic,strong,readonly) Class objClass;

+ (instancetype)array;
+ (instancetype)arrayWithArray:(NSArray*)array;
+ (instancetype)arrayWithObjectClass:(Class)class;
+ (instancetype)arrayWithObjectClass:(Class)class array:(NSArray*)array;
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray<id> *)otherArray;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)removeAllObjects;
- (void)removeObject:(id)anObject inRange:(NSRange)range;
- (void)removeObject:(id)anObject;
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsInArray:(NSArray<id> *)otherArray;
- (void)removeObjectsInRange:(NSRange)range;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray range:(NSRange)otherRange;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray;
- (void)setArray:(NSArray<id> *)otherArray;

- (void)insertObjects:(NSArray<id> * _Nonnull)objects atIndexes:(NSIndexSet *_Nonnull)indexes;
- (void)removeObjectsAtIndexes:(NSIndexSet *_Nonnull)indexes;
- (void)replaceObjectsAtIndexes:(NSIndexSet *_Nonnull)indexes withObjects:(NSArray<id> *_Nonnull)objects;

//
- (BOOL)containsObject:(id _Nonnull)anObject;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState * _Nonnull)state objects:(id _Nonnull __unsafe_unretained [])buffer count:(NSUInteger)len;

- (id _Nonnull)pasing:(id _Nonnull)object key:(NSString* _Nonnull)key;
@end
