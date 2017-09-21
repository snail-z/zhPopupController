//
//  UIDevice+zhDeviceType.m
//  zhPopupController_Example
//
//  Created by zhanghao on 2017/9/21.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIDevice+zhDeviceType.h"

@implementation UIDevice (zhDeviceType)

+ (zhDeviceType)deviceType {
   
    NSString *stringSize = NSStringFromCGSize([UIScreen mainScreen].bounds.size);
    
    if ([stringSize isEqualToString:@"{320, 480}"]) { // iphone 4/4s
        return __IPHONE_4;
    } else if ([stringSize isEqualToString:@"{320, 568}"]) { // iphone 5/5c/5s/SE
        return __IPHONE_5;
    } else if ([stringSize isEqualToString:@"{375, 667}"]) { // iphone 6/6s/7/8
        return __IPHONE_6;
    } else if ([stringSize isEqualToString:@"{414, 736}"]) { // iphone 6p/6sp/7p/8p
        return __IPHONE_6P;
    } else if ([stringSize isEqualToString:@"{375, 812}"]) { // iphone X
        return __IPHONE_X;
    } else {
        return __UNKNOWN;
    }
}

@end
