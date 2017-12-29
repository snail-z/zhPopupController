//
//  zh_ViewController+Extension.h
//  zhPopupController
//
//  Created by zhanghao on 2016/8/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zh_SecondViewController.h"
#import "zhAlertView.h"
#import "zhOverflyView.h"
#import "zhCurtainView.h"
#import "zhSidebarView.h"
#import "zhFullView.h"
#import "zhWallView.h"
#import "zh_KeyboardView.h"
#import "zhPickerView.h"

@interface zh_SecondViewController (Extension)

- (zhAlertView *)alertView1;
- (zhAlertView *)alertView2;
- (zhOverflyView *)overflyView;
- (zhCurtainView *)curtainView;
- (zhSidebarView *)sidebarView;
- (zhFullView *)fullView;
- (zhWallView *)wallView;

- (NSArray *)wallModels;

@end
