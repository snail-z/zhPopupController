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

+ (instancetype)buttonWithType:(UIButtonType)buttonType __attribute__ ((unavailable("You cannot initialize through buttonWithType - please use buttonWithTitle:")));
+ (instancetype)buttonWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(SnailAlertButton *button))handler;

@property (nonatomic, assign) UIEdgeInsets edgeInset; // top -> 间距 / bottom -> 最底部留白

@end

@interface SnailAlertView : UIView

- (nonnull instancetype)init __attribute__ ((unavailable("You cannot initialize through init - please use initWithTitle:")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__ ((unavailable("You cannot initialize through initWithCoder: - please use initWithTitle:")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__ ((unavailable("You cannot initialize through initWithFrame: - please use initWithTitle:")));

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message fixedWidth:(CGFloat)width;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, nullable) UIColor *linesColor; // All the line color.
@property (nonatomic, assign) BOOL linesHidden;

// The vertical views
- (void)addAction:(nonnull SnailAlertButton *)action;
// Horizontal two views
- (void)addAdjoinWithCancelAction:(nonnull SnailAlertButton *)cancelAction okAction:(nonnull SnailAlertButton *)okAction;

@end

NS_ASSUME_NONNULL_END
