//
//  UIView+Tap.h
//  MiaowTeach
//
//  Created by luck chen on 2016/11/22.
//  Copyright © 2016年 kewaimiao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapAction)(void);

@interface UIView (Tap)

@property (weak,nonatomic) UIViewController *fatherVC;

-(void)TapAction:(TapAction)back;
+ (id)loadViewFromXib;
+ (UIViewAutoresizing)autoresizingWith:(NSInteger)index;
@end
