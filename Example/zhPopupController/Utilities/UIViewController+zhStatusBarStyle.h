//
//  UIViewController+zhStatusBarStyle.h
//  categoryKitDemo
//
//  Created by zhanghao on 2017/5/30.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (zhStatusBarStyle)

@property (nonatomic, assign) BOOL zh_statusBarHidden;
@property (nonatomic, assign) UIStatusBarStyle zh_statusBarStyle;
- (void)zh_statusBarRestoreDefaults;

@end
