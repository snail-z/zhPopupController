//
//  zh_UpdateView.h
//  zhPopupController
//
//  Created by zhanghao on 2017/9/7.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface zhOverflyButton : UIButton

+ (instancetype)buttonWithTitle:(nullable NSString *)title
                        handler:(void (^ __nullable)(zhOverflyButton *button))handler;

@property (nonatomic, assign) UIColor *lineColor;   // 线条颜色
@property (nonatomic, assign) CGFloat lineWidth;    // 线宽
@property (nonatomic, assign) UIEdgeInsets flyEdgeInsets; //边缘留白 top -> 间距 / bottom -> 最底部留白(根据不同情况调整不同间距)

@end

@interface zhOverflyView : UIView

@property (nonatomic, strong) UIImageView *flyImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) CALayer *splitLine;

/**
 - flyImage: 顶部image
 - highlyRatio: 为对称透明区域视觉上更加美观，需要设置顶部图片透明区域所占比，无透明区域设置为0即可 ( highlyRatio = 图片透明区域高度 / 图片高度 ) (对切图有要求，需要美工告知透明区域高度)
 - attributedTitle: 富文本标题 ( NSString => NSMutableAttributedString
                               [[NSMutableAttributedString alloc] initWithString:string]; )
 - message: 消息文本
 */
- (instancetype)initWithFlyImage:(nullable UIImage *)flyImage
                     highlyRatio:(CGFloat)highlyRatio
                 attributedTitle:(nullable NSAttributedString *)attributedTitle
               attributedMessage:(nullable NSAttributedString *)attributedMessage
                   constantWidth:(CGFloat)constantWidth; // 自动计算内部各组件高度，最终zhOverflyView视图高等于总高度

- (instancetype)initWithFlyImage:(nullable UIImage *)flyImage
                     highlyRatio:(CGFloat)highlyRatio
                           title:(nullable NSString *)title
                         message:(nullable NSString *)message
                   constantWidth:(CGFloat)constantWidth;

@property (nonatomic, assign) CGFloat highlyRatio;

/// 可视滚动区域高，默认200 (当message文本内容高度小于200时，则可视滚动区域等于文本内容高度)
@property (nonatomic, assign) CGFloat visualScrollableHight;

/// 消息文本边缘留白，默认UIEdgeInsetsMake(10, 10, 10, 10)
@property (nonatomic, assign) UIEdgeInsets messageEdgeInsets;

/// 子视图按钮(zhOverflyButton)的高度，默认49
@property (nonatomic, assign) CGFloat subOverflyButtonHeight;

/// 竖直方向添加一个按钮，可增加多个按钮依次向下排列
- (void)addAction:(zhOverflyButton *)action;

/// 水平方向两个并列按钮
- (void)adjoinWithLeftAction:(zhOverflyButton *)leftAction rightAction:(zhOverflyButton *)rightAction;

/// 刷新所有子视图内容
- (void)reloadAllComponents;

@end

NS_ASSUME_NONNULL_END
