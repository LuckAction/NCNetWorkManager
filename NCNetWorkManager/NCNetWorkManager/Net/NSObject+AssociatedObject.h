//
//  NSObject+AssociatedObject.h
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/20.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObject)
@property (assign, nonatomic,readonly) Class childClass;
- (instancetype)initWithChildClass:(Class)childClass;
+ (instancetype)objChildClass:(Class)childClass;
@end
