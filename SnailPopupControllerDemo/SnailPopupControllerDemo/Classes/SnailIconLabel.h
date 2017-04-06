//
//  SnailIconLabel.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/9/26.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, slTextAlignment) {
    slTextAlignmentMarginal  = 0,    // Visually marginal aligned
    slTextAlignmentCenter    = 1,    // Visually centered aligned
    slTextAlignmentNatural   = 2,    // Indicates the default alignment for natural
};

@class SnailIconLabelModel;

@interface SnailIconLabel : UIControl

@property (nonatomic, strong, readonly) UIImageView *iconView;

@property (nonatomic, strong, readonly) UILabel *textLabel;

// UIEdgeInsets insets = {top, left, bottom, right}
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets; // default is UIEdgeInsetsZero
// Can use the "bottom" or "right" to adjust the space between subviews.

@property (nonatomic, assign) BOOL horizontalLayout; // default is NO. if YES, layout subviews horizontally.
// The text not fold line when horizontal layout. 横向布局时文本不折行

@property (nonatomic, assign) BOOL autoresizingFlexibleSize; // default is NO. if YES, self.frame are adjusted according to flexibleSize if subviews size changes
// 如果设置YES，textLabel会根据文本计算自身size，SnailIconLabel自身size也对应改变

@property (nonatomic, assign) CGFloat sizeLimit; // textLabel根据文本计算size时，如果纵向布局则限高，横向布局则限宽

// 手动设置布局样式，autoresizingFlexibleSize = NO时有作用
@property (nonatomic, assign) slTextAlignment textAlignment; // default is slTextAlignmentNatural.

@property (nonatomic, strong) SnailIconLabelModel *model; // Model of the assignment.

@end

@interface SnailIconLabelModel : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *text;
+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image;

@end
