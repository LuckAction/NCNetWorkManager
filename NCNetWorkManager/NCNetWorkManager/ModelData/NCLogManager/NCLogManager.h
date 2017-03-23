//
//  NCLogManager.h
//  NCNetWorkManager
//
//  Created by luck chen on 2017/3/23.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCLogManager : NSObject
- (instancetype)initWithUrl:(NSString*)url maxTotal:(NSInteger)total;
-(void)addErrorLog:(NSMutableDictionary*)dictionary;
@end
