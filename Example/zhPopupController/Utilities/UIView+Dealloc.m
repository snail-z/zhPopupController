//
//  UIView+Dealloc.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "UIView+Dealloc.h"
#import <objc/runtime.h>

@implementation UIView (Dealloc)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(sl_dealloc);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL isSuccess = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (isSuccess) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)sl_dealloc {

//    NSLog(@"%@ - dealloc", self);
    
//    NSLog(@"%@ - dealloc", NSStringFromClass(self.class));
    
    if ([NSStringFromClass([self class]) rangeOfString:@"Snail"].location != NSNotFound) {
        NSLog(@"%@ - dealloc", NSStringFromClass(self.class));
    }
    
    [self sl_dealloc];
}

@end
