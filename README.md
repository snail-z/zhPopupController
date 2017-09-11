# zhPopupController

[![Language](https://img.shields.io/badge/Language-%20Objective--C%20-orange.svg)](https://travis-ci.org/snail-z/zhPopupController)
[![Version](https://img.shields.io/badge/pod-v0.1.5-brightgreen.svg)](http://cocoapods.org/pods/zhPopupController)
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
    
	pod 'zhPopupController', '~> 0.1.5'
    
end
```

## Preview   

<img src="https://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController.gif?raw=true" width="204px" height="365px">



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
## Author

snail-z, haozhang0770@163.com

## License

zhPopupController is available under the MIT license. See the LICENSE file for more info.


