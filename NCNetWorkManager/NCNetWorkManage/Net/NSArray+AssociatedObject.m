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
                    NCNetModel *resultsObj = [self.childClass mj_objectWithKeyValues:childData];
                    [resultsObj unpack_nsdic:childData];
                    [(NSMutableArray *)self addObject:resultsObj];
                }
                
            }else if([object isKindOfClass:[NSDictionary class]]){
                id modelData = [self.childClass mj_objectWithKeyValues:child];
                [modelData unpack_nsdic:child];
                if (child) [(NSMutableArray *)self addObject:modelData];
            }else{
                if (child) [(NSMutableArray *)self addObject:child];

            }

        }
    }
    return self;
}
@end
