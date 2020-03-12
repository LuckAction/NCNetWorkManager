//
//  NCNetWorkDownloadManager.m
//  NCNetWorkManagerDemo
//
//  Created by luck chen on 2017/4/13.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import "NCNetWorkDownloadManager.h"
#import "AFNetworking.h"
#import <objc/runtime.h>
@implementation NSURLSessionTask(BLOCK)

- (void)setProgressBlock:(ProgressBlock)progressBlock
{
    objc_setAssociatedObject(self, @selector(progressBlock), progressBlock, OBJC_ASSOCIATION_COPY);
}

- (ProgressBlock)progressBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@interface NCNetWorkDownloadManager ()
{
    
}

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end


@implementation NCNetWorkDownloadManager
static NCNetWorkDownloadManager *manager ;

+ (NCNetWorkDownloadManager*)shareDownloadManager
{
    if (!manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[NCNetWorkDownloadManager alloc]init];
        });
    }
    return manager;
}

- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
         _manager.requestSerializer.timeoutInterval = 30.0;
        [_manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            if (downloadTask.progressBlock) {
                downloadTask.progressBlock((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
            }
            NSLog(@"%.2f / %.2f",(float)totalBytesWritten/1024.0/1024.0,(float)totalBytesExpectedToWrite/1024.0/1024.0);
        }];

    }
    return _manager;
}

+ (NSURLSessionDownloadTask *)downWithUrl:(NSURL*)url saveUrl:(NSURL*)saveUrl progress:(ProgressBlock)progressBlock completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [[NCNetWorkDownloadManager shareDownloadManager].manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [saveUrl URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
    }];
    
    downloadTask.progressBlock = progressBlock;
    
    [downloadTask resume];
    return downloadTask;

}
@end
