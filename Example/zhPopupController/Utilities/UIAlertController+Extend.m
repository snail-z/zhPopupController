//
//  UIAlertController+Extend.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "UIAlertController+Extend.h"
#import <zhPopupController/zhPopupController.h>

@implementation UIAlertController (Extend)

+ (void)showAlert:(NSString *)text {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, 270, 70);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    label.text = text;
    label.font = [UIFont fontWithName:@"palatino-boldItalic" size:20];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:label size:label.bounds.size];
    popupController.dismissAfterDelay = 1;
    popupController.maskType = zhPopupMaskTypeBlackOpacity;
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.layoutType = zhPopupLayoutTypeTop;
    popupController.offsetSpacing = 90;
    
    UIView *window = UIApplication.sharedApplication.keyWindow;
    [popupController showInView:window duration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
}

@end
