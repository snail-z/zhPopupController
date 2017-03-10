//
//  UIView+SnailUse.h
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2017/2/9.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnailTooltipView.h"
#import "SnailCurtainView.h"
#import "SnailSidebarView.h"
#import "SnailFullScreenView.h"

@interface UIView (SnailUse)

+ (id)cityTooltip;
+ (id)wechatTooltip;
+ (id)slogan;
+ (id)qzoneCurtain;
+ (id)sharedCurtain;
+ (id)sidebar;
+ (id)fullScreen;

@end
