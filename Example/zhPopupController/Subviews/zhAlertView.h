//
//  zhAlertView.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface zhAlertButton : UIButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType NS_UNAVAILABLE;
+ (instancetype)buttonWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(zhAlertButton *button))handler;

@property (nonatomic, assign) UIColor *lineColor;   // 线条颜色
@property (nonatomic, assign) CGFloat lineWidth;    // 线宽
@property (nonatomic, assign) UIEdgeInsets edgeInsets; //边缘留白 top -> 间距 / bottom -> 最底部留白(根据不同情况调整不同间距)

@end

@interface zhAlertView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                constantWidth:(CGFloat)constantWidth;

/// 子视图按钮(zhOverflyButton)的高度，默认49
@property (nonatomic, assign) CGFloat subOverflyButtonHeight;

/// 纵向依次向下添加
- (void)addAction:(nonnull zhAlertButton *)action;

/// 水平方向两个button
- (void)adjoinWithLeftAction:(zhAlertButton *)leftAction rightAction:(zhAlertButton *)rightAction;

@end

NS_ASSUME_NONNULL_END
