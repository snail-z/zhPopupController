//
//  NSArray+zh_SafeAccess.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSArray+zh_SafeAccess.h"

@implementation NSArray (zh_SafeAccess)

- (NSUInteger)zh_indexOfObject:(id)anObject {
    NSParameterAssert(self.count);
    if ([self containsObject:anObject]) {
        return [self indexOfObject:anObject];
    }
    return 0;
}

@end
