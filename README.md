# SnailPopupController 
![enter image description here](https://img.shields.io/badge/pod-v2.0.1-brightgreen.svg)
![enter image description here](https://img.shields.io/badge/platform-iOS%207.0%2B-ff69b5152950834.svg) 
<a href="https://github.com/snail-z/OverlayController-Swift/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat"></a>
  
 快速弹出自定义视图，支持自定义蒙版样式、过渡效果、手势拖动、弹性动画等等。简单快捷，方便使用!  
#### _[Swift version is here.](https://github.com/snail-z/OverlayController-Swift) - [OverlayController-Swift](https://github.com/snail-z/OverlayController-Swift)_    


## Installation
To install OverlayController using [CocoaPods](https://cocoapods.org "CocoaPods" ), please integrate it in your existing Podfile, or create a new Podfile:

```ruby
    platform :ios, '7.0'
    use_frameworks!

    target 'You Project' do
    
      pod 'SnailPopupController', '~> 2.0.1'
    
    end
```
Then run pod install.  

## Example   
  
<img src="https://github.com/snail-z/SnailPopupController/blob/master/previews/SnailPopupController.gif?raw=true" width="204px" height="365px">


## Import
 ``` objc
    #import "SnailPopupController.h"
 ```  

## Update 2.0版本更新
* 增加视图弹出样式
```objc
// Controls how the popup will be presented.
typedef NS_ENUM(NSInteger, PopupTransitStyle) {
    PopupTransitStyleSlightScale, // 轻微缩放效果
    PopupTransitStyleShrinkInOut, // 从中心点扩大或收缩
    PopupTransitStyleDefault // 默认淡入淡出效果
};
``` 
* 修改present接口，增加回弹动画等
```objc
/*
 - parameter contentView: 需要弹出的视图 // This is the view that you want to appear in popup.
 - parameter duration: 动画时间
 - parameter isElasticAnimated: 是否使用弹性动画
 - parameter sView: 在sView上显示
 */
- (void)presentContentView:(nullable UIView *)contentView
                  duration:(NSTimeInterval)duration
           elasticAnimated:(BOOL)isElasticAnimated
                    inView:(nullable UIView *)sView; 
```  
  
#### 以下是修改后接口api，具体如下：
```objc
// Control mask view of style.
// 控制蒙版视图的样式
typedef NS_ENUM(NSUInteger, PopupMaskType) {
    PopupMaskTypeBlackBlur = 0, // 黑色半透明模糊效果
    PopupMaskTypeWhiteBlur, // 白色半透明模糊效果
    PopupMaskTypeWhite, // 纯白色
    PopupMaskTypeClear, // 全透明
    PopupMaskTypeDefault, // 默认黑色半透明效果
};

// Control popup view display position.
// 控制弹出视图的显示位置
typedef NS_ENUM(NSUInteger, PopupLayoutType) {
    PopupLayoutTypeTop = 0, // 在顶部显示
    PopupLayoutTypeBottom,
    PopupLayoutTypeLeft,
    PopupLayoutTypeRight,
    PopupLayoutTypeCenter // 默认居中显示
};

// Controls how the popup will be presented.
// 控制弹出视图将以哪种样式呈现
typedef NS_ENUM(NSInteger, PopupTransitStyle) {
    PopupTransitStyleFromTop = 0, // 从上部滑出
    PopupTransitStyleFromBottom, // 从底部滑出
    PopupTransitStyleFromLeft,  // 从左部滑出
    PopupTransitStyleFromRight, // 从右部滑出
    PopupTransitStyleSlightScale, // 轻微缩放效果
    PopupTransitStyleShrinkInOut, // 从中心点扩大或收缩
    PopupTransitStyleDefault // 默认淡入淡出效果
};
```
* 属性设置
```objc
@property (nonatomic, assign) PopupMaskType maskType; // 设置蒙版样式，default = PopupMaskTypeDefault

@property (nonatomic, assign) PopupLayoutType layoutType; // 视图显示位置，default = PopupLayoutTypeCenter

// Must set layoutType = PopupLayoutTypeCenter
@property (nonatomic, assign) PopupTransitStyle transitStyle; // 视图呈现方式，default = PopupTransitStyleDefault

// Must set maskType = PopupMaskTypeTranslucent
@property (nonatomic, assign) CGFloat maskAlpha; // 设置蒙版视图的透明度，default = 0.5

// Must set layoutType = PopupLayoutTypeCenter
@property (nonatomic, assign) BOOL isDismissOppositeDirection; // 是否反方向消失，default = NO

@property (nonatomic, assign) BOOL isDismissOnMaskTouched; // 点击蒙版视图是否响应dismiss事件，default = YES

@property (nonatomic, assign) BOOL isAllowPan; // 是否允许视图拖动，default = NO

@property (nonatomic, assign) BOOL isDropTransitionAnimated; // 视图倾斜掉落动画，当transitStyle为PopupTransitStyleFromTop样式时可以设置为YES使用掉落动画，default = NO

@property (nonatomic, assign, readonly) BOOL isPresenting; // 视图是否正在显示中
```
* 相关事件block
```objc
// Block gets called when mask touched. 蒙版触摸事件block，主要用来自定义dismiss动画时间及弹性效果
@property (nonatomic, copy) void (^maskClicked)(SnailPopupController *popupController);

// Should implement this block before the presenting. 应该在present前实现的block
@property (nonatomic, copy) void (^willPresent)(SnailPopupController *popupController); // ContentView will present. 视图将要呈现

@property (nonatomic, copy) void (^didPresent)(SnailPopupController *popupController); // ContentView Did present. 视图已经呈现

@property (nonatomic, copy) void (^willDismiss)(SnailPopupController *popupController); // ContentView Will dismiss. 视图将要消失

@property (nonatomic, copy) void (^didDismiss)(SnailPopupController *popupController); // ContentView Did dismiss. 视图已经消失
```
* 弹出自定义视图方法等 
```objc 
/*
 - parameter contentView: 需要弹出的视图 // This is the view that you want to appear in popup.
 - parameter duration: 动画时间
 - parameter isElasticAnimated: 是否使用弹性动画
 - parameter sView: 在sView上显示
 */
- (void)presentContentView:(nullable UIView *)contentView
                  duration:(NSTimeInterval)duration
           elasticAnimated:(BOOL)isElasticAnimated
                    inView:(nullable UIView *)sView;

// inView = nil, 在Window显示
- (void)presentContentView:(nullable UIView *)contentView duration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated;

/*
 - duration = 0.25
 - isElasticAnimated = NO
 - inView = nil, 在Window显示
 */
- (void)presentContentView:(nullable UIView *)contentView;

/*
 - parameter duration: 动画时间
 - parameter isElasticAnimated: 是否使用弹性动画
 */
- (void)dismissWithDuration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated;

// - parameters等于present时对应设置的values
- (void)dismiss;  

// Convenience method for creating popupController with custom values. 便利构造popupController并设置相应属性值
+ (instancetype)popupControllerWithLayoutType:(PopupLayoutType)layoutType
                                     maskType:(PopupMaskType)maskType
                         dismissOnMaskTouched:(BOOL)isDismissOnMaskTouched
                                     allowPan:(BOOL)isAllowPan;

// When layoutType = PopupLayoutTypeCenter // 若弹出视图想居中显示时，可以使用这个方法快速设置
+ (instancetype)popupControllerLayoutInCenterWithTransitStyle:(PopupTransitStyle)transitStyle
                                                     maskType:(PopupMaskType)maskType
                                         dismissOnMaskTouched:(BOOL)isDismissOnMaskTouched
                                     dismissOppositeDirection:(BOOL)isDismissOppositeDirection
                                                     allowPan:(BOOL)isAllowPan;
``` 
  
* block 对应的代理方法
``` objc
@protocol SnailPopupControllerDelegate <NSObject>

@optional
// - Block对应的Delegate方法，block优先
- (void)popupControllerWillPresent:(nonnull SnailPopupController *)popupController;
- (void)popupControllerDidPresent:(nonnull SnailPopupController *)popupController;
- (void)popupControllerWillDismiss:(nonnull SnailPopupController *)popupController;
- (void)popupControllerDidDismiss:(nonnull SnailPopupController *)popupController;

@end
``` 
* 为需要使用SnailPopupController的类增加属性sl_popupController
``` objc
@interface NSObject (SnailPopupController)

// 因为SnailPopupController内部子视图是默认添加在keyWindow上的，所以如果popupController是局部变量的话不会被任何引用，生命周期也只在这个方法内。为了使内部视图正常响应，所以应将popupController声明为全局属性，保证其生命周期，也可以直接使用sl_popupController
@property (nonatomic, strong) SnailPopupController *sl_popupController;

@end
``` 
## Usage
 * 可以直接使用sl_popupController弹出视图
``` objc
    [self.sl_popupController presentContentView:customView];
```
* 自定义sl_popupController
```objc
    self.sl_popupController = [[SnailPopupController alloc] init];
    self.sl_popupController.layoutType = PopupLayoutTypeLeft;
    self.sl_popupController.isAllowPan = YES;
    // ...
    [self.sl_popupController presentContentView:customView];
```  

#### 更多使用方法请参考Demo  

## License

SnailPopupController is distributed under the MIT license.
