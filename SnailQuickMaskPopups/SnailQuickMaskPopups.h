//
//  SnailQuickMaskPopups.h
//  <https://github.com/snail-z/SnailQuickMaskPopups.git>
//
//  Created by zhanghao on 2016/11/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 蒙版样式
typedef NS_ENUM(NSUInteger, MaskStyle) {
    // 黑色半透明效果
    MaskStyleBlackTranslucent = 0,
    // 黑色半透明模糊效果
    MaskStyleBlackBlur,
    // 白色半透明模糊效果
    MaskStyleWhiteBlur,
    // 白色不透明的效果
    MaskStyleWhite,
    // 全透明的效果
    MaskStyleClear
};

// 呈现样式
typedef NS_ENUM(NSUInteger, PresentationStyle) {
    // 居中显示，类似UIAlertView
    PresentationStyleCentered = 0,
    // 显示在底部，类似UIActionSheet
    PresentationStyleBottom,
    // 显示在顶部
    PresentationStyleTop,
    // 显示在左边，类似侧滑栏
    PresentationStyleLeft,
    // 显示在右面
    PresentationStyleRight
};

// 过渡样式
/// ! 若PresentationStyle不是'居中样式(Centered)' 该设置是无效的
typedef NS_ENUM(NSInteger, TransitionStyle) {
    // 淡入淡出
    TransitionStyleCrossDissolve = 0,
    // 轻微缩放效果
    TransitionStyleZoom,
    // 从顶部滑出
    TransitionStyleFromTop,
    // 从底部滑出
    TransitionStyleFromBottom,
    // 从左部滑出
    TransitionStyleFromLeft,
    // 从右部滑出
    TransitionStyleFromRight
};

@protocol SnailQuickMaskPopupsDelegate;

@interface SnailQuickMaskPopups : NSObject

@property (nonatomic, weak) id <SnailQuickMaskPopupsDelegate> _Nullable delegate;

@property (nonatomic, assign) PresentationStyle presentationStyle;  // 呈现样式，默认值是PresentationStyleCentered
@property (nonatomic, assign) TransitionStyle transitionStyle;      // 过渡样式，默认值是TransitionStyleCrossDissolve
@property (nonatomic, assign) CGFloat maskAlpha;                    // 蒙版透明度，默认值0.5
@property (nonatomic, assign) CGFloat springDampingRatio;           // 视图呈现时是否设置回弹动画效果，默认值1.0 (当'springDampingRatio'值为1.0时没有动画回弹效果；当该值小于1.0时，则开启回弹动画效果)
@property (nonatomic, assign) NSTimeInterval animateDuration;       // 动画持续时间，默认值0.25
@property (nonatomic, assign) BOOL isAllowMaskTouch;                // 蒙版是否可以响应事件，默认值YES
@property (nonatomic, assign) BOOL isAllowPopupsDrag;               // 是否允许弹出视图响应拖动事件，默认值NO
@property (nonatomic, assign) BOOL isDismissedOppositeDirection;    // 是否反方向消失，默认值NO

/**
 popupsWithMaskStyle: aView:
 
 - parameter maskStyle: 设置蒙版样式
 - parameter aView:     设置要弹出的视图
 */
+ (instancetype)popupsWithMaskStyle:(MaskStyle)maskStyle
                              aView:(UIView *)aView;

/**
 presentInView: withAnimated: completion
 
 - parameter superview: 在superview上显示
 - parameter animated: 显示时是否需要动画
 */
- (void)presentInView:(UIView *)superview
         withAnimated:(BOOL)animated
           completion:(void (^ __nullable)(BOOL finished, SnailQuickMaskPopups *popups))completion;

/**
 presentWithAnimated: completion
 ! 默认显示在window上
 
 - parameter animated: 显示时是否需要动画
 */
- (void)presentWithAnimated:(BOOL)animated
                 completion:(void (^ __nullable)(BOOL finished, SnailQuickMaskPopups *popups))completion;

/**
 dismissWithAnimated: completion
 
 - parameter animated: 隐藏时是否需要动画
 */
- (void)dismissWithAnimated:(BOOL)animated
                 completion:(void (^ __nullable)(BOOL finished, SnailQuickMaskPopups *popups))completion;

@end


@protocol SnailQuickMaskPopupsDelegate <NSObject>

@optional
/**
 SnailQuickMaskPopupsDelegate
 
 如果想在视图将要呈现之前或将要消失前或者完成后doSomething，可以实现以下代理方法:
 - snailQuickMaskPopupsWillPresent: 视图将要呈现
 - snailQuickMaskPopupsWillDismiss: 视图将要消失
 ! 若在'present'或'dismiss'方法中实现completion回调方法，以下两个方法则不起作用
 - snailQuickMaskPopupsDidPresent: 视图已经呈现
 - snailQuickMaskPopupsDidDismiss: 视图已经消失
 */
- (void)snailQuickMaskPopupsWillPresent:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsWillDismiss:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsDidPresent:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsDidDismiss:(SnailQuickMaskPopups *)popups;

@end

NS_ASSUME_NONNULL_END
