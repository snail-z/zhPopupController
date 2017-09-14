//
//  UIAlertController+Extend.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "UIAlertController+Extend.h"

@implementation UIAlertController (Extend)

+ (void)showAlert:(NSString *)text {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
#pragma clang diagnostic pop
}

@end
