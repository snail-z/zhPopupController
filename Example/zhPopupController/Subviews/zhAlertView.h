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

@property (nonatomic, assign) UIEdgeInsets edgeInset; // top -> 间距 / bottom -> 最底部留白

@end

@interface zhAlertView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message width:(CGFloat)width;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, nullable) UIColor *linesColor; // All the line color.
@property (nonatomic, assign) BOOL linesHidden;

- (void)addAction:(nonnull zhAlertButton *)action;
// Horizontal two views
- (void)addAdjoinWithCancelAction:(nonnull zhAlertButton *)cancelAction okAction:(nonnull zhAlertButton *)okAction;

@end

NS_ASSUME_NONNULL_END
