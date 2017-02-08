# SnailQuickMaskPopups
For the view quickly add the mask, and it pops up.

## Installation
Available in [CocoaPods](https://cocoapods.org "CocoaPods" )
    
        pod 'SnailQuickMaskPopups', '~> 0.0.2'
    
## Usage scenario
![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/city_.gif)

![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/wechat_.gif)

![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/slogan_.gif)

![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/qzone_.gif)

![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/shared_.gif)

![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/sidebar_.gif)

![image](https://github.com/snail-z/SnailQuickMaskPopups/blob/master/sample/full_.gif)


## Import
 ``` objc
    #import "SnailQuickMaskPopups.h"
 ```
 
## Example
 *  实例化SnailQuickMaskPopups传入自定义的view并设置遮罩样式，将其弹出
``` objc
    _popups = [SnailQuickMaskPopups popupsWithView:customView maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.transitionStyle = SnailPopupsTransitionStyleSlideInFromTop;
    [_popups presentPopupsAnimated:YES completion:NULL];
 ```
  *  一些属性设置
``` objc
    @property (nonatomic, assign) SnailPopupsPresentationStyle presentationStyle;   // 显现样式
    @property (nonatomic, assign) SnailPopupsTransitionStyle transitionStyle;       // 过渡效果
    @property (nonatomic, assign) BOOL shouldDismissOnMaskTouch;                    // 蒙版是否可以响应事件
    @property (nonatomic, assign) BOOL shouldDismissOnPopupsDrag;                   // 弹出框是否可以被拖动
    @property (nonatomic, assign) BOOL dismissesOppositeDirection;                  // 是否反方向消失
 ```
  *  Protocol
``` objc
    @optional
    - (void)snailQuickMaskPopupsWillPresent:(SnailQuickMaskPopups *)popups;
    - (void)snailQuickMaskPopupsDidPresent:(SnailQuickMaskPopups *)popups;
    - (void)snailQuickMaskPopupsWillDismiss:(SnailQuickMaskPopups *)popups;
    - (void)snailQuickMaskPopupsDidDismiss:(SnailQuickMaskPopups *)popups;
 ```
 
