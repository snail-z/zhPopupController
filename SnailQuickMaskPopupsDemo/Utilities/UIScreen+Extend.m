//
//  UIScreen+Extend.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UIScreen+Extend.h"

@implementation UIScreen (Extend)

+ (CGSize)size {
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGSize)sizeSwap {
    return CGSizeMake([self size].height, [self size].width);
}

+ (CGFloat)width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)scale {
    return [UIScreen mainScreen].scale;
}

@end
