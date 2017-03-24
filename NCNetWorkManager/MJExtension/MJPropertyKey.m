//
//  MJPropertyKey.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJPropertyKey.h"
#import "MJExtension.h"
#import "NCNetModel.h"
#import "NSArray+AssociatedObject.h"
#define GETMODELARRAY(shuxing)\
{\
modelArray = (NCNSMutableArray*)(father.shuxing);\
\}

@implementation MJPropertyKey

- (id)valueInObject:(id)object
{
    if ([self.modelClass isSubclassOfClass:[NCNetModel class]]) {
        return [NCNetModel nc_objectWithKeyValuesWith:self.modelClass value:[(NSDictionary*)object objectForKey:self.name]];
    }
    if ([object isKindOfClass:[NSDictionary class]] && self.type == MJPropertyKeyTypeDictionary) {
        id father = [[self.fatherClass alloc]init];
        NSMutableArray *modelArray = [father valueForKey:self.name];
        if ([modelArray isKindOfClass:[NSArray class]] || [modelArray isKindOfClass:[NSMutableArray class]]) {
            return [modelArray pasing:object key:self.name];
        }
        return object[self.name];
    } else if ([object isKindOfClass:[NSArray class]] && self.type == MJPropertyKeyTypeArray) {
        
        //判断是否是自定义的对象结构
        NSArray *array = object;
        NSUInteger index = self.name.intValue;
        if (index < array.count) return array[index];
        return nil;
    }
    
    return nil;
}
@end
