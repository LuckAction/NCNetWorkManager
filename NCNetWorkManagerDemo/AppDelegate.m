//
//  AppDelegate.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/17.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "AppDelegate.h"
#import "NCNetCollection.h"
#import "NCNetWorkNetManager.h"
#import "NCNetDataCollect.h"

#define XcodeAppBundle [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //打开测试模式，默认为关闭，传入测试案例的类
    [NCNetWorkNetManager openWrapTest:TRUE testClass:NCNetTest.class];
    //打开日志
    [NCNetWorkNetManager openLog:TRUE];
    //设置错误日志的上报路径和上报条数
    [NCNetWorkNetManager setErrorLog:@"http://urlv2.kewaimiao.com" maxTotal:20];

    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //同步请求测试用例
    UpdateServer *update = [[UpdateServer alloc]init];
    update.url = @"http://urlv2.kewaimiao.com?appid=com.kewaimiao.iosapp&version=3.0.312";
    update.age = 18;
    NSString *name;
    name = [update setpeopelName:@"chenhenian" age:@"26" sex:@"1"];
    SuppressPerformSelectorLeakWarning(
                                       name = [update performSelector:NSSelectorFromString(@"method:::") withObject:@"15" withObject:@"chenhenian"];
    );

    [update setIvarValue:name forkey:@"name"];
    NSError *error = nil;
    Re_UpdateServer *result = [NCNetWorkNetManager connectSyncUrl:update error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    if (result) {
        NSLog(@"%@",result);
    }
    
    //异步请求测试用例
    [NCNetWorkNetManager connectUrl:update progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"请求进度 ------ %@",progress);
    } OnSuccess:^(Re_UpdateServer*  _Nonnull result) {
        NSLog(@"%@",result);
    } onfail:^(NSError * _Nonnull result) {
        NSLog(@"%@",result);
    }];
    

    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
