//
//  SnailPopupController.h
//  <https://github.com/snail-z/SnailPopupController.git>
//
//  Created by zhanghao on 2016/11/15.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Control mask view of style.
// 控制蒙版视图的样式
typedef NS_ENUM(NSUInteger, PopupMaskType) {
    PopupMaskTypeBlackBlur = 0, // 黑色半透明模糊效果
    PopupMaskTypeWhiteBlur, // 白色半透明模糊效果
    PopupMaskTypeWhite, // 纯白色
    PopupMaskTypeClear, // 全透明
    PopupMaskTypeDefault, // 默认黑色半透明效果
};

// Control popup view display position.
// 控制弹出视图的显示位置
typedef NS_ENUM(NSUInteger, PopupLayoutType) {
    PopupLayoutTypeTop = 0, // 在顶部显示
    PopupLayoutTypeBottom,
    PopupLayoutTypeLeft,
    PopupLayoutTypeRight,
    PopupLayoutTypeCenter // 默认居中显示
};

// Controls how the popup will be presented.
// 控制弹出视图将以哪种样式呈现
typedef NS_ENUM(NSInteger, PopupTransitStyle) {
    PopupTransitStyleFromTop = 0, // 从上部滑出
    PopupTransitStyleFromBottom, // 从底部滑出
    PopupTransitStyleFromLeft,  // 从左部滑出
    PopupTransitStyleFromRight, // 从右部滑出
    PopupTransitStyleSlightScale, // 轻微缩放效果
    PopupTransitStyleShrinkInOut, // 从中心点扩大或收缩
    PopupTransitStyleDefault // 默认淡入淡出效果
};

@protocol SnailPopupControllerDelegate;

@interface SnailPopupController : NSObject

@property (nonatomic, weak) id <SnailPopupControllerDelegate> _Nullable delegate;

@property (nonatomic, assign) PopupMaskType maskType; // 设置蒙版样式，default = PopupMaskTypeDefault

@property (nonatomic, assign) PopupLayoutType layoutType; // 视图显示位置，default = PopupLayoutTypeCenter

// Must set layoutType = PopupLayoutTypeCenter
@property (nonatomic, assign) PopupTransitStyle transitStyle; // 视图呈现方式，default = PopupTransitStyleDefault

// Must set maskType = PopupMaskTypeTranslucent
@property (nonatomic, assign) CGFloat maskAlpha; // 设置蒙版视图的透明度，default = 0.5

// Must set layoutType = PopupLayoutTypeCenter
@property (nonatomic, assign) BOOL dismissOppositeDirection; // 是否反方向消失，default = NO

@property (nonatomic, assign) BOOL dismissOnMaskTouched; // 点击蒙版视图是否响应dismiss事件，default = YES

@property (nonatomic, assign) BOOL allowPan; // 是否允许视图拖动，default = NO

@property (nonatomic, assign) BOOL dropTransitionAnimated; // 视图倾斜掉落动画，当transitStyle为PopupTransitStyleFromTop样式时可以设置为YES使用掉落动画，default = NO

@property (nonatomic, assign, readonly) BOOL isPresenting; // 视图是否正在显示中

// Block gets called when mask touched. 蒙版触摸事件block，主要用来自定义dismiss动画时间及弹性效果
@property (nonatomic, copy) void (^maskTouched)(SnailPopupController *popupController);

// Should implement this block before the presenting. 应该在present前实现的block
@property (nonatomic, copy) void (^willPresent)(SnailPopupController *popupController); // ContentView will present. 视图将要呈现

@property (nonatomic, copy) void (^didPresent)(SnailPopupController *popupController); // ContentView Did present. 视图已经呈现

@property (nonatomic, copy) void (^willDismiss)(SnailPopupController *popupController); // ContentView Will dismiss. 视图将要消失

@property (nonatomic, copy) void (^didDismiss)(SnailPopupController *popupController); // ContentView Did dismiss. 视图已经消失

/*
 - parameter contentView: 需要弹出的视图 // This is the view that you want to appear in popup.
 - parameter duration: 动画时间
 - parameter isElasticAnimated: 是否使用弹性动画
 - parameter sView: 在sView上显示
 */
- (void)presentContentView:(nullable UIView *)contentView
                  duration:(NSTimeInterval)duration
           elasticAnimated:(BOOL)isElasticAnimated
                    inView:(nullable UIView *)sView;

// inView = nil, 在Window显示
- (void)presentContentView:(nullable UIView *)contentView duration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated;

/*
 - duration = 0.25
 - isElasticAnimated = NO
 - inView = nil, 在Window显示
 */
- (void)presentContentView:(nullable UIView *)contentView;

/*
 - parameter duration: 动画时间
 - parameter isElasticAnimated: 是否使用弹性动画
 */
- (void)dismissWithDuration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated;

// - parameters等于present时对应设置的values
- (void)dismiss;

// Convenience method for creating popupController with custom values. 便利构造popupController并设置相应属性值
+ (instancetype)popupControllerWithLayoutType:(PopupLayoutType)layoutType
                                     maskType:(PopupMaskType)maskType
                         dismissOnMaskTouched:(BOOL)dismissOnMaskTouched
                                     allowPan:(BOOL)allowPan;

// When layoutType = PopupLayoutTypeCenter
+ (instancetype)popupControllerLayoutInCenterWithTransitStyle:(PopupTransitStyle)transitStyle
                                                     maskType:(PopupMaskType)maskType
                                         dismissOnMaskTouched:(BOOL)dismissOnMaskTouched
                                     dismissOppositeDirection:(BOOL)dismissOppositeDirection
                                                     allowPan:(BOOL)allowPan;

@end

@protocol SnailPopupControllerDelegate <NSObject>

@optional
// - Block对应的Delegate方法，block优先
- (void)popupControllerWillPresent:(nonnull SnailPopupController *)popupController;
- (void)popupControllerDidPresent:(nonnull SnailPopupController *)popupController;
- (void)popupControllerWillDismiss:(nonnull SnailPopupController *)popupController;
- (void)popupControllerDidDismiss:(nonnull SnailPopupController *)popupController;

@end

@interface NSObject (SnailPopupController)

// 因为SnailPopupController内部子视图是默认添加在keyWindow上的，所以如果popupController是局部变量的话不会被任何引用，生命周期也只在这个方法内。为了使内部视图正常响应，所以应将popupController声明为全局属性，保证其生命周期，也可以直接使用sl_popupController
@property (nonatomic, strong) SnailPopupController *sl_popupController;

@end

NS_ASSUME_NONNULL_END
