//
//  UIDevice+zhDeviceType.h
//  zhPopupController_Example
//
//  Created by zhanghao on 2017/9/21.
//  Copyright © 2017年 snail-z. All rights reserved.
//

/** <最新官方设计指南: https://developer.apple.com/ios/human-interface-guidelines/overview/iphone-x/>
 根据设备屏幕尺寸确定当前设备型号
 iphone 4/4s => {320, 480}
 iphone 5/5c/5s/SE => {320, 568}
 iphone 6/6s/7/8 => {375, 667}
 iphone 6p/6sp/7p/8p =>  {414, 736}
 iphone X => {375, 812}
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, zhDeviceType) {
    __IPHONE_4 = 0,
    __IPHONE_5,
    __IPHONE_6,
    __IPHONE_6P,
    __IPHONE_X,
    __UNKNOWN
};

@interface UIDevice (zhDeviceType)

@property (class, nonatomic, assign, readonly) zhDeviceType deviceType;

@end
