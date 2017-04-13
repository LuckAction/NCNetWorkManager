//
//  DownTableViewCell.m
//  NCNetWorkManagerDemo
//
//  Created by luck chen on 2017/4/13.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import "DownTableViewCell.h"
#import "UIView+Tap.h"

@interface DownTableViewCell ()
@property (nonatomic,weak) NSURLSessionDownloadTask *task;
@property (nonatomic,strong) UILabel *label;

@end

@implementation DownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupProgressView3];
    self.proView.didSelectBlock = ^(UAProgressView *progressView){
        [self selectedAction];
    };
    
}
- (void)setupProgressView3 {
    self.proView.tintColor = [UIColor purpleColor];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(2, 15, 46.0, 20.0)];
    _label.font = [UIFont systemFontOfSize:10];
    [_label setTextAlignment:NSTextAlignmentCenter];
    _label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    
    [self.proView addSubview:_label];
}
- (void)selectedAction{
    
    
    if (self.proView.selected) {
        [self.task suspend];
    }else{
        if (!self.task) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            self.task = [NCNetWorkDownloadManager downWithUrl:[NSURL URLWithString:self.name.text] saveUrl:documentsDirectoryURL progress:^(CGFloat progress) {
                NSLog(@"%.5f",progress);

                [self.proView setProgress:progress animated:true];
                dispatch_async(dispatch_get_main_queue() , ^{
                    [self.label setText:[NSString stringWithFormat:@"%.2f%%", progress * 100]];
                });

            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                
            }];

        }
        [self.task resume];

    }

    self.proView.selected = !self.proView.selected;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
