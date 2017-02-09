//
//  UIAlertController+SnailUse.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2017/2/9.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "UIAlertController+SnailUse.h"

@implementation UIAlertController (SnailUse)

+ (void)showAlert:(NSString *)text {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
#pragma clang diagnostic pop
}

@end
