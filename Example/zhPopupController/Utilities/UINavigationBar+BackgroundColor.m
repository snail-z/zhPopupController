//
//  UINavigationBar+BackgroundColor.m
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

@implementation UINavigationBar (BackgroundColor)

- (UIView *)zh_backgroundView {
    UIView *backgroundView = objc_getAssociatedObject(self, _cmd);
    if (!backgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        backgroundView = [[UIView alloc] init];
        CGFloat statusBarHeight = 20;
        if ([NSStringFromCGSize([UIScreen mainScreen].bounds.size) isEqualToString:@"{375, 812}"]) {
            statusBarHeight = 44; // iphone X
        }
        backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        objc_setAssociatedObject(self, _cmd, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // _UIBarBackground is first subView for navigationBar
        [self.subviews.firstObject insertSubview:backgroundView atIndex:0];
    }
    return backgroundView;
}

- (void)zh_setBackgroundColor:(UIColor *)backgroundColor {
    self.zh_backgroundView.backgroundColor = backgroundColor;
}

- (void)zh_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.zh_backgroundView removeFromSuperview];
}

@end
