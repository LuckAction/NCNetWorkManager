//
//  NSArray+AssociatedObject.h
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/20.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+AssociatedObject.h"
@interface NSArray (AssociatedObject)

- (id)pasing:(id)object key:(NSString*)key;//model 解析
@end
