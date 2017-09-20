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

static char UINavigationBarOverlayKey;

- (UIView *)overlay {
    return objc_getAssociatedObject(self, &UINavigationBarOverlayKey);
}

- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &UINavigationBarOverlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sl_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        CGFloat stausbarH = 20;
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0) {
            stausbarH = 44; // iOS11系统版本
        }
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -stausbarH, UIScreen.mainScreen.bounds.size.width, CGRectGetHeight(self.bounds) + stausbarH)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)sl_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
