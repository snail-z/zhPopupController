//
//  UIView+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PKFrameAdjust)

@property (nonatomic, assign) CGFloat pk_left;
@property (nonatomic, assign) CGFloat pk_top;
@property (nonatomic, assign) CGFloat pk_right;
@property (nonatomic, assign) CGFloat pk_bottom;
@property (nonatomic, assign) CGFloat pk_width;
@property (nonatomic, assign) CGFloat pk_height;
@property (nonatomic, assign) CGFloat pk_centerX;
@property (nonatomic, assign) CGFloat pk_centerY;
@property (nonatomic, assign) CGPoint pk_origin;
@property (nonatomic, assign) CGSize  pk_size;

@end


typedef NS_OPTIONS(NSUInteger, PKEdgeLinePosition) {
    PKEdgeLinePositionLeft          = 1 << 0,
    PKEdgeLinePositionRight         = 1 << 1,
    PKEdgeLinePositionTop           = 1 << 2,
    PKEdgeLinePositionBottom        = 1 << 3,
    PKEdgeLinePositionAllEdgeLines  = ~0UL
};

@interface UIView (PKVisuals)

/** 为视图指定部分添加圆角 */
- (void)pk_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

/**
 * @brief 为视图指定位置添加边框线
 *
 * @param position 边线所在位置
 * @param width 边线宽度
 * @param color 边线颜色
 */
- (void)pk_addEdgeLineWidth:(CGFloat)width color:(UIColor *)color byEdgePosition:(PKEdgeLinePosition)position;

/**
 * @brief 为视图指定位置添加默认值边框线
 *
 * @param position 边线所在位置
 *
 * 默认值 lineWidth => 1 / [UIScreen mainScreen].scale
 * 默认值 lineColor => [UIColor grayColor]
 */
- (void)pk_addDefaultEdgeLineByPosition:(PKEdgeLinePosition)position;

@end


@interface UIView (PKExtend)

/** 删除视图的所有子视图 */
- (void)pk_removeAllSubviews;

/** 返回视图所在的视图控制器或nil */
@property (nullable, nonatomic, readonly) UIViewController *pk_inViewController;

@end


@interface UIView (PKBadge)

@property (nonatomic, assign, readonly) BOOL pk_badgeShowing;
@property (nonatomic, strong, readonly, nullable) UILabel *pk_badgeLabel;

/** 为视图添加badge并设置文本 */
- (void)pk_showBadgeWithText:(nullable NSString *)text;

/** 隐藏badge */
- (void)pk_badgeHide;

/** 移除badge */
- (void)pk_badgeRemove;

/**
 * @brief 设置badge的偏移位置, 其中心点默认为父视图的右上角
 * offset.horizontal > 0，向右偏移，反之向左偏移
 * offset.vertical > 0，向下偏移，反之向上偏移
 */
- (void)pk_badgeOffset:(UIOffset)offset;

/** 是否圆角显示badge，默认NO */
- (void)pk_badgeAlwaysRound:(BOOL)isRound;

/**
 * @brief 用于等比例调整badge的大小
 * 注意：若需要同时设置圆角，应在调用`-pk_badgeAlwaysRound`该方法后再调用，否则该方法将无效!!!
 */
- (void)pk_badgeTransformHeight:(CGFloat)height;

@end


@interface UIView (PKIndicatorLoading)

/** 指示器是否加载中 */
@property (nonatomic, assign, readonly) BOOL pk_isIndicatorLoading;

/** 指示器开始加载 */
- (void)pk_beginIndicatorLoading;

/** 自定义指示器颜色并开始加载 */
- (void)pk_beginIndicatorLoading:(UIColor *)tintColor;

/** 设置指示器文本并开始加载 */
- (void)pk_beginIndicatorLoadingText:(NSString *)message;

/** 自定义指示器颜色及文本并开始加载 */
- (void)pk_beginIndicatorLoadingText:(nullable NSString *)message tintColor:(UIColor *)tintColor;

/** 指示器结束加载 */
- (void)pk_endIndicatorLoading;

@end


@interface UIView (PKTipToast)

/** 文本提示窗是否显示中 */
@property (nonatomic, assign, readonly) BOOL pk_isToastShowing;

/** 显示文本提示窗，默认在1.5s后消失 */
- (void)pk_showToastText:(NSString *)message;

/** 显示文本提示窗，将在delay时间后消失 */
- (void)pk_showToastText:(NSString *)message delay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
