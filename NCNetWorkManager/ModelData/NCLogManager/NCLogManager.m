//
//  NCLogManager.m
//  NCNetWorkManager
//
//  Created by luck chen on 2017/3/23.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import "NCLogManager.h"

@interface NCLogManager ()
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *logPath;
@property (assign,nonatomic) NSInteger total;
@end

@implementation NCLogManager

- (instancetype)initWithUrl:(NSString*)url maxTotal:(NSInteger)total
{
    self = [super init];
    self.url = url;
    self.total = (total == 0)?20:total;
    [self initPlist];
    return self;
}

- (NSString *)logPath
{
    if (_logPath == nil) {
        NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
        _logPath =[doucumentsDirectiory stringByAppendingPathComponent:@"log.plist"];
    }
    return _logPath;
}

-(void)initPlist{
    
    //如果plist文件不存在，将工程中已建起的plist文件写入沙盒中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:self.logPath]) {
        
        //从自己建立的plist文件 复制到沙盒中 ，方法一
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"log" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:self.logPath error:&error];
    }
}

//增加一个错误日志
-(void)addErrorLog:(NSMutableDictionary*)dictionary{
    
    NSMutableArray *array = [self readPlist];
    //如果已存在则读取现有数据
    if (!array) {
        array = [[NSMutableArray alloc]init];
    }
    
    [array addObject:dictionary];
    
    if([array writeToFile:self.logPath atomically:YES]){
        NSLog(@"errorLog add ok!");
    }else{
        NSLog(@"errorLog add NO");
    }
    if(array.count >= self.total){
        NSLog(@"errorLog full");
        [self updateLog];
    }
}

-(NSMutableArray *)readPlist{
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[[NSArray alloc]initWithContentsOfFile:self.logPath]];
    return array;
}

- (void)updateLog
{
    if (!self.url) {
        return;
    }
    NSMutableArray *array = [self readPlist];
    if (array) {
        ErrorLogUpdate *update = [[ErrorLogUpdate alloc]init];
        update.url = self.url;
        update.errorArray = array;

        __weak typeof(self) weakSelf = self;
        [NCNetWorkNetManager connectUrl:update OnSuccess:^(Re_ErrorLogUpdate *result) {
            if (result.success) {
                [weakSelf deletePlist];
            }
            
        } onfail:^(NSError * _Nonnull result) {
            
        }];
    }
}
- (void)deletePlist
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if([array writeToFile:self.logPath atomically:YES]){
        NSLog(@"errorLog clean ok!");
    }else{
        NSLog(@"errorLog clean NO");
    }
}
@end
