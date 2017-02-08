# SnailQuickMaskPopups
为任意视图快速添加一个蒙版，并可根据需求定制样式，简单快捷！
通过SnailQuickMaskPopups内部创建一个蒙版视图，并添加自定义视图，通过一些点的计算实现弹出方向，手势拖动等

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
 
