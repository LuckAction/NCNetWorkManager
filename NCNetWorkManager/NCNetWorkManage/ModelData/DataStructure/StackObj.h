//
//  StackObj.h
//  MiaowStudentPro
//
//  Created by luck chen on 2016/12/5.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BINARY 2
#define OCTAL 8
#define DECIMALISM 10
#define Hexadecimal 16

@class StackObj;


@interface StackObj : NSObject

@property (nonatomic,readonly) NSInteger stackCount;
@property (nonatomic,readonly) NSUInteger maxCount;
@property (nonatomic,readonly) BOOL stackNULL;
@property (nonatomic,readonly) id stackTop;
@property (nonatomic,readonly) NSInteger currentSubscript;
@property (nonatomic,readonly) id stackBottom;

+ (instancetype)creatStack;
- (BOOL)cleanStack;
- (BOOL)pushStack:(id)obj;
- (BOOL)popStack;
- (BOOL)reverse;
@end
