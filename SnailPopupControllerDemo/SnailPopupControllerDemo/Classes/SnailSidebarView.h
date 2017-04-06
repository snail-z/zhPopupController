//
//  SnailSidebarView.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnailSidebarView : UIView

@property (nonatomic, strong) NSArray<NSString *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<SnailIconLabel *> *items;
@property (nonatomic, copy) void (^didClickItems)(SnailSidebarView *sidebarView, NSInteger index);

@end
