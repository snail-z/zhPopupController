<img src="http://oo8l3jrvb.bkt.clouddn.com/0921_left_zhPopupController.png" alt="zhPopupController" title="zhPopupController">

[![Language](https://img.shields.io/badge/Language-%20Objective--C%20-orange.svg)](https://travis-ci.org/snail-z/zhPopupController)
[![Version](https://img.shields.io/badge/pod-v2.0.0-brightgreen.svg)](http://cocoapods.org/pods/zhPopupController)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://cocoapods.org/pods/zhPopupController)
[![Platform](https://img.shields.io/badge/platform-%20iOS8.0+%20-lightgrey.svg)](http://cocoapods.org/pods/zhPopupController)

Popup your custom view is easy, support custom mask style, transition effects and gesture to drag.

### Version 2.0

zhPopupController version 2.0 has been optimized and refactored. Some methods and properties in version 1.0 are no longer compatible. Please upgrade with caution.
The swiftba version is more lightweight and concise. If you want to know more, please see [here](http://cocoapods.org).

**Swift - [OverlayController](http://cocoapods.org)**

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
    
	pod 'zhPopupController', '~> 2.0'
    
end
```

## Preview 

<img src="htt://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController.gif?raw=true" width="204px" height="365px">

## Usage

* Designated initializer，Must set your content view and its size. Bind the view to a popup controller，one-to-one

  ```objc
  _popupController = [[zhPopupController alloc] initWithView:customView size:alert.bounds.size];
  _popupController.presentationStyle = zhPopupSlideStyleTransform;
  _popupController.presentationTransformScale = 1.25;
  _popupController.dismissonTransformScale = 0.85;
  // ...
  [_popupController showInView:self.view.window completion:NULL];
  ```

-----

- Support following keyboard popup and hide

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

<img src="http://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController_up.gif?raw=true" width="204px" height="365px">



* Support adjust the spacing between with the keyboard.by `keyboardOffsetSpacing`

  ```objc
  /// Adjust the spacing between with the keyboard
  @property (nonatomic, assign) CGFloat keyboardOffsetSpacing;
  ```

-----

- Other

   - Support present/dismiss slide style. by`presentationStyle` `dismissonStyle`
- Support Set popup view display position. by `layoutType`
   - Support Set popup view mask style. by `maskType`
   - Support set popup view priority. default is zhPopupWindowLevelNormal `windowLevel`
   -  Support adjust the layout position by `offsetSpacing`
   - Support gesture dragging,default is NO. if YES, Popup view will allow to drag `panGestureEnabled`
   - Support dismiss automatically. the view will disappear after `dismissAfterDelay` seconds，default is 0 will not disappear
   
   ```objc
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
   
   /// The view will disappear after `dismissAfterDelay` seconds，default is 0 will not disappear
   @property (nonatomic, assign) NSTimeInterval dismissAfterDelay;
   
   /// default is NO. if YES, Popup view will allow to drag
   @property (nonatomic, assign) BOOL panGestureEnabled;
   
   /// Adjust the layout position by `offsetSpacing`
   @property (nonatomic, assign) CGFloat offsetSpacing;
   ```
   
   See demo for more usage.


## Author

snail-z, haozhang0770@163.com

## License

zhPopupController is available under the MIT license. See the LICENSE file for more info.


