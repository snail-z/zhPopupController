//
//  UIViewController+zhStatusBarStyle.m
//  categoryKitDemo
//
//  Created by zhanghao on 2017/5/30.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIViewController+zhStatusBarStyle.h"
#import <objc/runtime.h>

@implementation UINavigationController (zh_StatusBarStyle)

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end

@implementation UIViewController (zhStatusBarStyle)

- (BOOL)zh_statusBarHidden {
    id value = objc_getAssociatedObject(self, _cmd);
    return [value boolValue];
}

- (void)setZh_statusBarHidden:(BOOL)zh_statusBarHidden {
    objc_setAssociatedObject(self, @selector(zh_statusBarHidden), @(zh_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self statusBarAppearanceCheck]) {
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:zh_statusBarHidden];
#pragma clang diagnostic pop
    }
}

- (UIStatusBarStyle)zh_statusBarStyle {
    id value = objc_getAssociatedObject(self, _cmd);
    return [value integerValue];
}

- (void)setZh_statusBarStyle:(UIStatusBarStyle)zh_statusBarStyle {
    objc_setAssociatedObject(self, @selector(zh_statusBarStyle), @(zh_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self statusBarAppearanceCheck]) {
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:zh_statusBarStyle];
#pragma clang diagnostic pop
    }
}

- (void)zh_statusBarRestoreDefaults {
    if ([self statusBarAppearanceCheck]) {
        self.zh_statusBarStyle = UIStatusBarStyleDefault;
        self.zh_statusBarHidden = NO;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
#pragma clang diagnostic pop
    }
}

- (BOOL)prefersStatusBarHidden {
    return self.zh_statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.zh_statusBarStyle;
}

- (BOOL)statusBarAppearanceCheck {
    NSDictionary *appInfo = [NSBundle mainBundle].infoDictionary;
    if ([appInfo.allKeys containsObject:@"UIViewControllerBasedStatusBarAppearance"]) {
        return [appInfo[@"UIViewControllerBasedStatusBarAppearance"] integerValue];
    }
    return YES;
}

@end
