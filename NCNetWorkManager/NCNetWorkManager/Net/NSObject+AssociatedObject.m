//
//  NSObject+AssociatedObject.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/20.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>
@implementation NSObject (AssociatedObject)

- (void)setChildClass:(Class)childClass
{
    objc_setAssociatedObject(self, @selector(childClass), childClass, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (Class)childClass
{
    return objc_getAssociatedObject(self, _cmd);
}

- (instancetype)initWithChildClass:(Class)childClass
{
    self = [self init];
    self.childClass = childClass;
    return self;
}

+ (instancetype)objChildClass:(Class)childClass
{
    return [[self.class alloc]initWithChildClass:childClass];
}

@end
