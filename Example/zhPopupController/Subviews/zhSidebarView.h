//
//  zhSidebarView.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhSidebarView : UIView

@property (nonatomic, strong) NSArray<NSString *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<zhImageButton *> *items;
@property (nonatomic, copy) void (^didClickItems)(zhSidebarView *sidebarView, NSInteger index);

@end
