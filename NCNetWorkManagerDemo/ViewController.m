//
//  ViewController.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/17.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "ViewController.h"
#import "NCNetModel.h"
#import "NCNetCollection.h"
#import "NCNetWorkDownloadManager.h"
#import "NSObject+NCKVO.h"
#import "DownViewController.h"

@interface ViewController ()
@property (nonatomic,weak) NSURLSessionDownloadTask *task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    
//
//    _task = [NCNetWorkDownloadManager downWithUrl:[NSURL URLWithString:@"https://codeload.github.com/rs/SDWebImage/zip/master"] saveUrl:documentsDirectoryURL progress:^(CGFloat progress) {
//        NSLog(@"%.5f",progress);
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        
//    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)puase:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [self.task suspend];
//    }else{
//        [self.task resume];
//    }
    
    DownViewController *vc = [[DownViewController alloc]initWithNibName:@"DownViewController" bundle:nil];
    
    [self presentViewController:vc animated:true completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
