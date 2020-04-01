<img src="http://oo8l3jrvb.bkt.clouddn.com/0921_left_zhPopupController.png" alt="zhPopupController" title="zhPopupController">

[![Language](https://img.shields.io/badge/Language-%20Objective--C%20-orange.svg)](https://travis-ci.org/snail-z/zhPopupController)
[![Version](https://img.shields.io/badge/pod-v1.0.3-brightgreen.svg)](http://cocoapods.org/pods/zhPopupController)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://cocoapods.org/pods/zhPopupController)
[![Platform](https://img.shields.io/badge/platform-%20iOS8.0+%20-lightgrey.svg)](http://cocoapods.org/pods/zhPopupController)

Popup your custom view is easy, support custom mask style, transition effects and gesture to drag.



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Requires iOS 8.0 or later
- Requires Automatic Reference Counting (ARC)

## Installation

zhPopupController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '8.0'
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
    [self.popupController showInView:self.view.window completion:NULL];
```

* Customize.
```objc
_popupController = [[zhPopupController alloc] initWithView:customView size:alert.bounds.size];
_popupController.presentationStyle = zhPopupSlideStyleTransform;
_popupController.presentationTransformScale = 1.25;
_popupController.dismissonTransformScale = 0.85;
// ...
[_popupController showInView:self.view.window completion:NULL];
```

- Support dismiss automatically.

```objc
/// The view will disappear after `dismissAfterDelay` seconds，default is 0 will not disappear
@property (nonatomic, assign) NSTimeInterval dismissAfterDelay;
```

-----

- Update

  Observe to keyboard changes will change contentView layout

  New **`keyboardOffsetSpacing`** properties.   You can through it adjust the spacing relative to the keyboard when the keyboard appears. default is 0, The pan gesture will be invalid when the keyboard appears.

  

  If you want to make the animation consistent: 

  You need to call the method "becomeFirstResponder()" in "willPresentBlock", don't call it before that.

  You need to call the method "resignFirstResponder()" in "willDismissBlock".

  ```objc
  /// default is NO. if YES, Will adjust view position when keyboard changes
  @property (nonatomic, assign) BOOL keyboardChangeFollowed;
  
  /// default is NO. if the view becomes first responder，you need set YES to keep the animation consistent
  @property (nonatomic, assign) BOOL becomeFirstResponded;
  ```

  ```objc
  _popupController.becomeFirstResponded = YES;
  _popupController.keyboardChangeFollowed = YES;
  _popupController.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
  	[textField becomeFirstResponder];
  };
          
  _popupController.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
  	[textField resignFirstResponder];
  };
  
  //...
  [_popupController show];
  ```

<img src="https://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController_up.gif?raw=true" width="204px" height="365px">



-----

- Update

   - Support present/dismiss slide style

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


