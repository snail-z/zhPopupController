//
//  NSObject+AssociatedObject.m
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import  <objc/runtime.h>

@implementation NSObject (AssociatedObject)

- (id)sl_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

// Association Policy - OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)sl_setAssociatedValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Association Policy - OBJC_ASSOCIATION_ASSIGN
- (void)sl_setAssignValue:(id)value withKey:(SEL)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

// Association Policy - OBJC_ASSOCIATION_COPY_NONATOMIC
- (void)sl_setCopyValue:(id)value withKey:(SEL)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)sl_removeAssociatedObjects {
    objc_removeAssociatedObjects(self);
}

@end
