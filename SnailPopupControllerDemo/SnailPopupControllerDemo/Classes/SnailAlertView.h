//
//  SnailAlertView.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SnailAlertButton : UIButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType NS_UNAVAILABLE;

+ (instancetype)buttonWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(SnailAlertButton *button))handler;

@property (nonatomic, assign) UIEdgeInsets edgeInset; // top -> 间距 / bottom -> 最底部留白

@end

@interface SnailAlertView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message width:(CGFloat)width;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, nullable) UIColor *linesColor; // All the line color.
@property (nonatomic, assign) BOOL linesHidden;

- (void)addAction:(nonnull SnailAlertButton *)action;
// Horizontal two views
- (void)addAdjoinWithCancelAction:(nonnull SnailAlertButton *)cancelAction okAction:(nonnull SnailAlertButton *)okAction;

@end

NS_ASSUME_NONNULL_END
