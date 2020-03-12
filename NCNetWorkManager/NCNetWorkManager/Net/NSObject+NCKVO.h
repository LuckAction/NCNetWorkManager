//
//  NSObject+NCKVO.h
//  NSOperationDemo
//
//  Created by luck chen on 2017/4/5.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^NCObservingBlock)(id observedObject, NSString *observekey, id oldValue, id newValue);

@interface NSObject (NCKVO)
- (void)addNCObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath withBlock:(NCObservingBlock)block;
- (void)removeNCObserver:(NSObject *)observer forKey:(NSString *)key;

@end
