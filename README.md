<img src="http://oo8l3jrvb.bkt.clouddn.com/0921_left_zhPopupController.png" alt="zhPopupController" title="zhPopupController">

[![Language](https://img.shields.io/badge/Language-%20Objective--C%20-orange.svg)](https://travis-ci.org/snail-z/zhPopupController)
[![Version](https://img.shields.io/badge/pod-v1.0.3-brightgreen.svg)](http://cocoapods.org/pods/zhPopupController)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://cocoapods.org/pods/zhPopupController)
[![Platform](https://img.shields.io/badge/platform-%20iOS7.0+%20-lightgrey.svg)](http://cocoapods.org/pods/zhPopupController)

Popup your custom view is easy, support custom mask style, transition effects and gesture to drag.



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Requires iOS 7.0 or later
- Requires Automatic Reference Counting (ARC)

## Installation

zhPopupController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '7.0'
use_frameworks!

target 'You Project' do
    
	pod 'zhPopupController', '~> 1.0'
    
end
```

## Preview 

<img src="htt://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController.gif?raw=true" width="204px" height="365px">

## Usage

* Direct use of zh_popupController popup your  custom view.
``` objc
    [self.zh_popupController presentContentView:customView];
```

* Customize.
```objc
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeWhiteBlur];
    self.zh_popupController.layoutType = zhPopupLayoutTypeLeft;
    self.zh_popupController.allowPan = YES;
    // ...
    [self.zh_popupController presentContentView:customView];
```

## Notes

- Update  **(September 11, 2017 v0.1.6)**

  - Support dismiss automatically.

```objc
/**
 present your content view.
 @param contentView This is the view that you want to appear in popup. / 弹出自定义的contentView
 @param duration Popup animation time. / 弹出动画时长
 @param isSpringAnimated if YES, Will use a spring animation. / 是否使用弹性动画
 @param sView  Displayed on the sView. if nil, Displayed on the window. / 显示在sView上
 @param displayTime The view will disappear after `displayTime` seconds. / 视图将在displayTime后消失
 */
- (void)presentContentView:(nullable UIView *)contentView
                  duration:(NSTimeInterval)duration
            springAnimated:(BOOL)isSpringAnimated
                    inView:(nullable UIView *)sView
               displayTime:(NSTimeInterval)displayTime;
```

-----

- Update  **(September 13, 2017 v0.1.7)**

  - Content layout fixes

  - Observe to keyboard changes will change contentView layout

  - New **`offsetSpacingOfKeyboard`** properties.   You can through it adjust the spacing relative to the keyboard when the keyboard appears. default is 0

    >  The pan gesture will be invalid when the keyboard appears.

<img src="https://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController_up.gif?raw=true" width="204px" height="365px">



-----

- Update  **(September 21, 2017 v0.1.8)**

   - Support ios11 system version

   - When system is larger than iOS 8 will use of UIVisualEffectView to do mask blur effect.

<img src="https://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController_ios11.gif?raw=true?raw=true" width="216px" height="427px">

-----

- Update  **(November 20, 2017 v1.0.2)**
    - New method `- (void)fadeDismiss` for fade out of your content view.

    - In 1.0.2 `zhPopupSlideStyleShrinkInOut` will be deprecated, You should use `zhPopupSlideStyleShrinkInOut1` or `zhPopupSlideStyleShrinkInOut2`


## Author

snail-z, haozhang0770@163.com

## License

zhPopupController is available under the MIT license. See the LICENSE file for more info.


