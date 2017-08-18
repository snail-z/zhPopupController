//
//  NSObject+AssociatedObject.h
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObject)

- (id)sl_getAssociatedValueForKey:(void *)key;

// Association Policy - OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)sl_setAssociatedValue:(id)value withKey:(void *)key;

// Association Policy - OBJC_ASSOCIATION_ASSIGN
- (void)sl_setAssignValue:(id)value withKey:(SEL)key;

// Association Policy - OBJC_ASSOCIATION_COPY_NONATOMIC
- (void)sl_setCopyValue:(id)value withKey:(SEL)key;

- (void)sl_removeAssociatedObjects;

@end
