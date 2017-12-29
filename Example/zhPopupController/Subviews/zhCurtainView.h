//
//  zhCurtainView.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhCurtainView : UIView

@property (nonatomic, strong) NSArray<zhImageButtonModel *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<zhImageButton *> *items;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, copy) void (^closeClicked)(UIButton *closeButton);
@property (nonatomic, copy) void (^didClickItems)(zhCurtainView *curtainView, NSInteger index);

@end
