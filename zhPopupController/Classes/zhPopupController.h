//
//  zhPopupController.h
//  <https://github.com/snail-z/zhPopupController.git>
//
//  Created by zhanghao on 2016/11/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Control view mask style
typedef NS_ENUM(NSUInteger, zhPopupMaskType) {
    zhPopupMaskTypeDarkBlur = 0,
    zhPopupMaskTypeLightBlur,
    zhPopupMaskTypeExtraLightBlur,
    zhPopupMaskTypeWhite,
    zhPopupMaskTypeClear,
    zhPopupMaskTypeBlackOpacity // default
};

/// Control the style of view Presenting
typedef NS_ENUM(NSInteger, zhPopupSlideStyle) {
    zhPopupSlideStyleFromTop = 0,
    zhPopupSlideStyleFromBottom,
    zhPopupSlideStyleFromLeft,
    zhPopupSlideStyleFromRight,
    zhPopupSlideStyleFade, // default
    zhPopupSlideStyleTransform
};

/// Control where the view finally position
typedef NS_ENUM(NSUInteger, zhPopupLayoutType) {
    zhPopupLayoutTypeTop = 0,
    zhPopupLayoutTypeBottom,
    zhPopupLayoutTypeLeft,
    zhPopupLayoutTypeRight,
    zhPopupLayoutTypeCenter // default
};

/// Control the display level of the PopupController
typedef NS_ENUM(NSUInteger, zhPopupWindowLevel) {
    zhPopupWindowLevelVeryHigh = 0,
    zhPopupWindowLevelHigh,
    zhPopupWindowLevelNormal, // default
    zhPopupWindowLevelLow,
    zhPopupWindowLevelVeryLow
};

@protocol zhPopupControllerDelegate;

@interface zhPopupController : NSObject

@property (nonatomic, weak) id <zhPopupControllerDelegate> _Nullable delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Designated initializer，Must set your content view and its size.
/// Bind the view to a popup controller，one-to-one
- (instancetype)initWithView:(UIView *)popupView size:(CGSize)size;

/// The view is the initialized `popupView`
@property (nonatomic, strong, readonly) UIView *view;

/// Whether contentView is presenting.
@property (nonatomic, assign, readonly) BOOL isPresenting;

/// Set popup view mask style. default is zhPopupMaskTypeBlackOpacity (maskAlpha: 0.5)
@property (nonatomic, assign) zhPopupMaskType maskType;

/// Set popup view display position. default is zhPopupLayoutTypeCenter
@property (nonatomic, assign) zhPopupLayoutType layoutType;

/// Set popup view present slide style. default is zhPopupSlideStyleFade
@property (nonatomic, assign) zhPopupSlideStyle presentationStyle;

/// Set popup view dismiss slide style. default is `presentationStyle`
@property (nonatomic, assign) zhPopupSlideStyle dismissonStyle;

/// Set popup view priority. default is zhPopupWindowLevelNormal
@property (nonatomic, assign) zhPopupWindowLevel windowLevel;

/// default is 0.5, When maskType is zhPopupMaskTypeBlackOpacity vaild.
@property (nonatomic, assign) CGFloat maskAlpha;

/// default is 0.5, When slideStyle is zhPopupSlideStyleTransform vaild.
@property (nonatomic, assign) CGFloat presentationTransformScale;

/// default is `presentationTransformScale`, When slideStyle is zhPopupSlideStyleTransform vaild.
@property (nonatomic, assign) CGFloat dismissonTransformScale;

/// default is YES. if NO, Mask view will not respond to events.
@property (nonatomic, assign) BOOL dismissOnMaskTouched;

/// The view will disappear after `dismissAfterDelay` seconds，default is 0 will not disappear
@property (nonatomic, assign) NSTimeInterval dismissAfterDelay;

/// default is NO. if YES, Popup view will allow to drag
@property (nonatomic, assign) BOOL panGestureEnabled;

/// When drag position meets the screen ratio the view will dismiss，default is 0.5
@property (nonatomic, assign) CGFloat panDismissRatio;

/// Adjust the layout position by `offsetSpacing`
@property (nonatomic, assign) CGFloat offsetSpacing;

/// Adjust the spacing between with the keyboard
@property (nonatomic, assign) CGFloat keyboardOffsetSpacing;

/// default is NO. if YES, Will adjust view position when keyboard changes
@property (nonatomic, assign) BOOL keyboardChangeFollowed;

/// default is NO. if the view becomes first responder，you need set YES to keep the animation consistent
/// If you want to make the animation consistent:
/// You need to call the method "becomeFirstResponder()" in "willPresentBlock", don't call it before that.
/// You need to call the method "resignFirstResponder()" in "willDismissBlock".
@property (nonatomic, assign) BOOL becomeFirstResponded;

/// Block gets called when internal trigger dismiss.
@property (nonatomic, copy) void (^defaultDismissBlock)(zhPopupController *popupController);

/// Block gets called when contentView will present.
@property (nonatomic, copy) void (^willPresentBlock)(zhPopupController *popupController);

/// Block gets called when contentView did present.
@property (nonatomic, copy) void (^didPresentBlock)(zhPopupController *popupController);

/// Block gets called when contentView will dismiss.
@property (nonatomic, copy) void (^willDismissBlock)(zhPopupController *popupController);

/// Block gets called when contentView did dismiss.
@property (nonatomic, copy) void (^didDismissBlock)(zhPopupController *popupController);

@end


@interface zhPopupController (Convenient)

/// shows popup view animated in window
- (void)show;

/// shows popup view animated.
- (void)showInView:(UIView *)view completion:(void (^ __nullable)(void))completion;

/// shows popup view animated using the specified duration.
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion;

/// shows popup view animated using the specified duration and bounced.
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration bounced:(BOOL)bounced completion:(void (^ __nullable)(void))completion;

/// shows popup view animated using the specified duration, delay, options, bounced, and completion handler.
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options bounced:(BOOL)bounced completion:(void (^ __nullable)(void))completion;

/// hide popup view animated
- (void)dismiss;

/// hide popup view animated using the specified duration.
- (void)dismissWithDuration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion;

/// hide popup view animated using the specified duration, delay, options, and completion handler.
- (void)dismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^ __nullable)(void))completion;

@end


@protocol zhPopupControllerDelegate <NSObject>
@optional

// - The Delegate method, block is preferred.
- (void)popupControllerWillPresent:(zhPopupController *)popupController;
- (void)popupControllerDidPresent:(zhPopupController *)popupController;
- (void)popupControllerWillDismiss:(zhPopupController *)popupController;
- (void)popupControllerDidDismiss:(zhPopupController *)popupController;

@end

NS_ASSUME_NONNULL_END
