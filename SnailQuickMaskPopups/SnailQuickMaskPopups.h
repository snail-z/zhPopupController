//
//  SnailQuickMaskPopups.h
//  <https://github.com/snail-z/zhPopups.git>
//
//  Created by zhanghao on 2016/11/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SnailQuickMaskPopupsDelegate;

// 显现样式（决定最终显示位置）
typedef NS_ENUM(NSUInteger, SnailPopupsPresentationStyle) {
    SnailPopupsPresentationStyleCentered = 0,   // 默认居中显示弹出框
    SnailPopupsPresentationStyleActionSheet,    // 在底部显示弹出框类似UIActionSheet
    SnailPopupsPresentationStyleCurtain,        // 在顶部显示弹出框
    SnailPopupsPresentationStyleSlideLeft,      // 在左边显示弹出框
    SnailPopupsPresentationStyleSlideRight      // 在右边显示弹出框
};

// 过渡样式
// 仅当设置`SnailPopupsPresentationStyle`为`SnailPopupsPresentationStyleCentered`时，以下效果才会生效
typedef NS_ENUM(NSInteger, SnailPopupsTransitionStyle) {
    SnailPopupsTransitionStyleCrossDissolve = 0,
    SnailPopupsTransitionStyleTransformScale,
    SnailPopupsTransitionStyleSlideInFromTop,
    SnailPopupsTransitionStyleSlideInFromBottom,
    SnailPopupsTransitionStyleSlideInFromLeft,
    SnailPopupsTransitionStyleSlideInFromRight,
};

// 蒙版样式
typedef NS_ENUM(NSUInteger, SnailPopupsMaskStyle) {
    SnailPopupsMaskStyleBlackTranslucent = 0,   // 黑色半透明背景
    SnailPopupsMaskStyleClear,                  // 全透明
    SnailPopupsMaskStyleWhite,                  // 纯白色
    SnailPopupsMaskStyleBlurTranslucentBlack,   // 类似UIToolbar的半透明背景（黑）
    SnailPopupsMaskStyleBlurTranslucentWhite,   // 类似UIToolbar的半透明背景（白）
};

@interface SnailQuickMaskPopups : NSObject

@property (nonatomic, assign) SnailPopupsPresentationStyle presentationStyle;   // 显现样式
@property (nonatomic, assign) SnailPopupsTransitionStyle transitionStyle;       // 过渡效果
@property (nonatomic, assign) BOOL shouldDismissOnMaskTouch;                    // 蒙版是否可以响应事件
@property (nonatomic, assign) BOOL shouldDismissOnPopupsDrag;                   // 弹出框是否可以被拖动
@property (nonatomic, assign) BOOL dismissesOppositeDirection;                  // 是否反方向消失

@property (nonatomic, weak) id <SnailQuickMaskPopupsDelegate> _Nullable delegate;

+ (instancetype)popupsWithView:(UIView *)popupView
                     maskStyle:(SnailPopupsMaskStyle)maskStyle;

- (void)presentPopupsAnimated:(BOOL)flag
                   completion:(void (^ __nullable)(BOOL finished, SnailQuickMaskPopups *popups))completion;
- (void)dismissPopupsAnimated:(BOOL)flag
                   completion:(void (^ __nullable)(BOOL finished, SnailQuickMaskPopups *popups))completion;

@end

@protocol SnailQuickMaskPopupsDelegate <NSObject>

@optional
- (void)snailQuickMaskPopupsWillPresent:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsDidPresent:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsWillDismiss:(SnailQuickMaskPopups *)popups;
- (void)snailQuickMaskPopupsDidDismiss:(SnailQuickMaskPopups *)popups;

@end

NS_ASSUME_NONNULL_END
