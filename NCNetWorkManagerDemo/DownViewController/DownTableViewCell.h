//
//  DownTableViewCell.h
//  NCNetWorkManagerDemo
//
//  Created by luck chen on 2017/4/13.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

@interface DownTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UAProgressView *proView;
@end
