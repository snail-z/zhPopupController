//
//  NSObject+zh_CycleDetector.h
//  zhPopupController
//
//  Created by zhanghao on 2017/9/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (zh_CycleDetector)

- (void)zh_findRetainCycles;

@end
