# SnailQuickMaskPopups 
![enter image description here](https://img.shields.io/badge/pod-v1.0.0-brightgreen.svg)
![enter image description here](https://img.shields.io/badge/platform-iOS%207.0%2B-ff69b5152950834.svg) 
<a href="https://github.com/snail-z/OverlayController-Swift/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat"></a>
  
 为任意视图快速添加一个蒙版，并可根据需求定制样式并可设置一些显示动画等，简单快捷，方便使用!  
 通过SnailQuickMaskPopups内部创建一个蒙版视图，并添加自定义视图，包含一些点的计算实现弹出方向，手势拖动等

## Installation
Available in [CocoaPods](https://cocoapods.org "CocoaPods" )
    
        `pod 'SnailQuickMaskPopups', '~> 1.0.0'`
    
## Usage scenario 
![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/alert%20style.gif)
![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/WeChat%20style.gif)
![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/Qzone%20style.gif)
![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/Shared%20style.gif)
![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/Sidebar%20style.gif)
![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/Full%20style.gif)


## Import
 ``` objc
    #import "SnailQuickMaskPopups.h"
 ```  

## Update  
* 最新更新，为视图弹出时添加回弹动画，通过修改属性springDampingRatio回弹阻尼比的值来设置，使用了系统方法usingSpringWithDamping动画
```objc
// - usingSpringWithDamping的范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显
// - initialSpringVelocity表示初始的速度，数值越大一开始移动越快
[UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                     } completion:^(BOOL finished) {
                     }];  
```  
* 修改接口api，简化方法和枚举值并增加详细注释，具体如下   
```objc
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

```
```objc
@property (nonatomic, assign) PresentationStyle presentationStyle;  // 呈现样式，默认值是PresentationStyleCentered
@property (nonatomic, assign) TransitionStyle transitionStyle;      // 过渡样式，默认值是TransitionStyleCrossDissolve
@property (nonatomic, assign) CGFloat maskAlpha;                    // 蒙版透明度，默认值0.5
@property (nonatomic, assign) CGFloat springDampingRatio;           // 视图呈现时是否设置回弹动画效果，默认值1.0 (当'springDampingRatio'值为1.0时没有动画回弹效果；当该值小于1.0时，则开启回弹动画效果)
@property (nonatomic, assign) NSTimeInterval animateDuration;       // 动画持续时间，默认值0.25
@property (nonatomic, assign) BOOL isAllowMaskTouch;                // 蒙版是否可以响应事件，默认值YES
@property (nonatomic, assign) BOOL isAllowPopupsDrag;               // 是否允许弹出视图响应拖动事件，默认值NO
@property (nonatomic, assign) BOOL isDismissedOppositeDirection;    // 是否反方向消失，默认值NO
```
```objc
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

```
```objc
@protocol SnailQuickMaskPopupsDelegate

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

```
  
## Example
 *  实例化SnailQuickMaskPopups传入自定义的view并设置遮罩样式，然后将视图弹出
``` objc
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackBlur aView:v];
    _popups.presentationStyle = PresentationStyleCentered;
    _popups.transitionStyle = TransitionStyleFromTop;
    _popups.isDismissedOppositeDirection = YES;
    _popups.isAllowMaskTouch = NO;
    _popups.springDampingRatio = 0.5;
    [_popups presentWithAnimated:YES completion:NULL];
 ```
* 实现代理方法，部分如下 
```objc
- (void)snailQuickMaskPopupsWillPresent:(SnailQuickMaskPopups *)popups {
    // do something
}

- (void)snailQuickMaskPopupsWillDismiss:(SnailQuickMaskPopups *)popups {
    // do something
}
```  

 <u>如果需要swift版本，可以[点击这里]()</u>
## License

OverlayController is distributed under the MIT license.
