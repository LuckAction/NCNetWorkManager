//
//  NCNetWorkDownloadManager.h
//  NCNetWorkManagerDemo
//
//  Created by luck chen on 2017/4/13.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^ProgressBlock)(CGFloat progress);

@interface NSURLSessionTask(SCALE)
@property (nonatomic,copy) ProgressBlock progressBlock;
@end

@interface NCNetWorkDownloadManager : NSObject
{
}

+ (NCNetWorkDownloadManager*)shareDownloadManager;

+ (NSURLSessionDownloadTask *)downWithUrl:(NSURL*)url saveUrl:(NSURL*)saveUrl progress:(ProgressBlock)progressBlock completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

NS_ASSUME_NONNULL_END
@end
