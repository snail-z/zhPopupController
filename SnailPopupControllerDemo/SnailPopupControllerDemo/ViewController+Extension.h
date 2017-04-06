//
//  ViewController+Extension.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "ViewController.h"
#import "SnailAlertView.h"
#import "SnailCurtainView.h"
#import "SnailSidebarView.h"
#import "SnailFullView.h"
#import "SnailSheetView.h"

@interface ViewController (Extension)

- (SnailAlertView *)alertView1;
- (SnailAlertView *)alertView2;
- (SnailCurtainView *)curtainView;
- (SnailSidebarView *)sidebarView;
- (SnailFullView *)fullView;

- (SnailSheetView *)sheetViewWithConfig:(id<SnailSheetViewConfig>)config;
- (NSArray *)sheetModels;

@end
