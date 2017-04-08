//
//  SnailCurtainView.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnailCurtainView : UIView

@property (nonatomic, strong) NSArray<SnailIconLabelModel *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<SnailIconLabel *> *items;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, copy) void (^closeClicked)(UIButton *closeButton);
@property (nonatomic, copy) void (^didClickItems)(SnailCurtainView *curtainView, NSInteger index);

@end
