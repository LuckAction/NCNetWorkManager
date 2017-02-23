//
//  NSArray+AssociatedObject.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/20.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "NSArray+AssociatedObject.h"

@implementation NSArray (AssociatedObject)

- (id)pasing:(id)object key:(NSString*)key{
    if (self.childClass) {
        id value = object[key];
        for (id child in value) {
            if ([child isKindOfClass:[NSArray class]] || [child isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray *array = child;
                for (id childData in array) {
                    id modelData = [NCNetModel nc_objectWithKeyValuesWith:self.childClass value:childData];
                    if (modelData) [(NSMutableArray *)self addObject:modelData];
                }
            }else if([object isKindOfClass:[NSDictionary class]]){
                id modelData = [NCNetModel nc_objectWithKeyValuesWith:self.childClass value:child];
                if (modelData) [(NSMutableArray *)self addObject:modelData];
            }else{
                if (child) [(NSMutableArray *)self addObject:child];
            }
        }
    }
    return self;
}
@end
