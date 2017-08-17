//
//  zh_ViewController+Extension.h
//  zhPopupController
//
//  Created by zhanghao on 2016/8/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zh_ViewController.h"
#import "zhAlertView.h"
#import "zhCurtainView.h"
#import "zhSidebarView.h"
#import "zhFullView.h"
#import "zhSheetView.h"

@interface zh_ViewController (Extension)

- (zhAlertView *)alertView1;
- (zhAlertView *)alertView2;
- (zhCurtainView *)curtainView;
- (zhSidebarView *)sidebarView;
- (zhFullView *)fullView;

- (zhSheetView *)sheetViewWithConfig:(id<zhSheetViewConfigDelegate>)config;
- (NSArray *)sheetModels;

@end
