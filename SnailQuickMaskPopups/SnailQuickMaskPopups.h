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
    TransitionStyleFromRight,
    // 从中心点变大
    TransitionStyleFromCenter
};

@protocol SnailQuickMaskPopupsDelegate;

@interface SnailQuickMaskPopups : NSObject

@property (nonatomic, weak) id <SnailQuickMaskPopupsDelegate> _Nullable delegate;

@property (nonatomic, assign) PresentationStyle presentationStyle;  // 呈现样式，默认值PresentationStyleCentered

@property (nonatomic, assign) TransitionStyle transitionStyle;      // 过渡样式，默认值TransitionStyleCrossDissolve

@property (nonatomic, assign) CGFloat maskAlpha;                    // 蒙版透明度，默认值0.5

@property (nonatomic, assign) CGFloat dampingRatio;                 // 弹性动画阻尼比，0~1之间有效

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
 presentInView: animated: completion
 
 - parameter superview:  将蒙版添加在superview上，若superview为nil，则显示在window上
 - parameter animated:   显示时是否需要动画，默认YES
 - parameter completion: 视图显示完成的回调
 */
- (void)presentInView:(nullable UIView *)superview
             animated:(BOOL)animated
           completion:(void (^ __nullable)(SnailQuickMaskPopups *popups))completion;

/**
 presentAnimated: completion
 ! 视图显示在window上
 
 - parameter animated:   显示时是否需要动画
 - parameter completion: 视图显示完成的回调
 */
- (void)presentAnimated:(BOOL)animated
             completion:(void (^ __nullable)(SnailQuickMaskPopups *popups))completion;

/**
 dismissAnimated: completion
 
 - parameter animated:   隐藏时是否需要动画
 - parameter completion: 视图已经消失的回调
 */
- (void)dismissAnimated:(BOOL)animated
             completion:(void (^ __nullable)(SnailQuickMaskPopups *popups))completion;

@end


@protocol SnailQuickMaskPopupsDelegate <NSObject>

@optional
/**
 SnailQuickMaskPopupsDelegate
 
 - snailQuickMaskPopupsWillPresent: 视图将要呈现
 - snailQuickMaskPopupsWillDismiss: 视图将要消失
 ! 这两个是'present'和'dismiss'方法中completion对应的代理方法，completion优先处理
 - snailQuickMaskPopupsDidPresent: 视图已经呈现
 - snailQuickMaskPopupsDidDismiss: 视图已经消失
 */
- (void)snailQuickMaskPopupsWillPresent:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsWillDismiss:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsDidPresent:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsDidDismiss:(SnailQuickMaskPopups *)popups;

@end

NS_ASSUME_NONNULL_END
