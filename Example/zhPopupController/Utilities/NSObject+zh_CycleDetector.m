//
//  NSObject+zh_CycleDetector.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSObject+zh_CycleDetector.h"
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>

@implementation NSObject (zh_CycleDetector)

- (void)zh_findRetainCycles {
    
    FBGraphEdgeFilterBlock filterBlock = ^(FBObjectiveCGraphElement *_Nullable fromObject,
                                           NSString *_Nullable byIvar,
                                           Class _Nullable toObjectOfClass){
        
        if (![[fromObject classNameOrNull] hasPrefix:@"UINavi"])
        {
            return FBGraphEdgeValid;
        }
        return FBGraphEdgeInvalid;
        
    };
    
    FBObjectGraphConfiguration *configuration = [[FBObjectGraphConfiguration alloc]
                                                 initWithFilterBlocks:@[filterBlock]
                                                 shouldInspectTimers:NO];
    
    FBRetainCycleDetector *detector = [[FBRetainCycleDetector alloc] initWithConfiguration:configuration];
    [detector addCandidate:self];
    NSSet *retainCycles = [detector findRetainCycles];
    
    if (retainCycles.count) {
        NSLog(@"findRetainCycles (%@) ===> %@", NSStringFromClass(self.class), retainCycles);
    }
    
}

@end
