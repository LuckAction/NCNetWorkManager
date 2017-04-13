//
//  UIView+Tap.m
//  MiaowTeach
//
//  Created by luck chen on 2016/11/22.
//  Copyright © 2016年 kewaimiao.com. All rights reserved.
//

#import "UIView+Tap.h"
#import <objc/runtime.h>
static char viewTap;
@implementation UIView (Tap)
-(void)TapAction:(TapAction)back
{
    objc_setAssociatedObject(self, &viewTap, back, OBJC_ASSOCIATION_COPY);
    
    self.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTouch)];
    [self addGestureRecognizer:tap];
}

- (void)viewTouch{
    
    __weak typeof(self) weakSelf = self;
    TapAction block = objc_getAssociatedObject(weakSelf, &viewTap);
    
    if (block) {
        block();
    }
}

- (void)setFatherVC:(UIViewController *)fatherVC
{
    objc_setAssociatedObject(self, @selector(fatherVC), fatherVC, OBJC_ASSOCIATION_ASSIGN);
}

-(UIViewController *)fatherVC
{
    return objc_getAssociatedObject(self, _cmd);
}

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner
{

    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:fileOwner options:nil];
    if (array && [array count]) {
        return [array objectAtIndex:0];
    }else {
        return nil;
    }
}


+ (id)loadViewFromXib
{
    return [self loadViewFromXibNamed:NSStringFromClass([self class]) withFileOwner:self];
}

+ (UIViewAutoresizing)autoresizingWith:(NSInteger)index
{
    switch (index) {
        case 0:
            return UIViewAutoresizingNone;
        case 1:
            return UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        case 2:
            return UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin ;
        case 3:
            return UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin ;

        case 4:
            return UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin ;
            
        case 5:
            return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        case 6:
            return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;

        default:
            break;
    }
    return UIViewAutoresizingNone;
}
@end
