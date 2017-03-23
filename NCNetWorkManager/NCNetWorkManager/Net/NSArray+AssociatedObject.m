//
//  NSArray+AssociatedObject.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/20.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "NSArray+AssociatedObject.h"

#define ADDMODEL(obj)\
{\
id modelData = [NCNetModel nc_objectWithKeyValuesWith:self.childClass value:obj];\
ADDMODELDATA(modelData)\
}

#define ADDMODELDATA(obj)\
{\
if (obj) [(NSMutableArray *)self addObject:obj];\
}

#define PASING(object,key)\
{\
if (self.childClass) {\
id value = object[key];\
for (id obj in value) {\
if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {\
NSMutableArray *array = obj;\
for (id childData in array) {\
ADDMODEL(childData);\
}\
}else if([obj isKindOfClass:[NSDictionary class]]){\
ADDMODEL(obj)\
}else{\
ADDMODELDATA(obj)\
}\
}\
}\
return self;\
}
@implementation NSArray (AssociatedObject)


- (id)pasing:(id)object key:(NSString*)key{
    PASING(object,key)
}

@end
