//
//  SnailIconLabel.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/9/26.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnailIconLabelModel;

@interface SnailIconLabel : UIControl

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

// UIEdgeInsets insets = {top, left, bottom, right}
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets; // default is UIEdgeInsetsZero
// Can use the "bottom" or "right" to adjust the space between subviews.

@property (nonatomic, assign) BOOL horizontalLayout; // default is NO. if YES, layout subviews horizontally.

@property (nonatomic, assign) BOOL autoresizingFlexibleSize; // default is NO. if YES, self.frame are adjusted according to flexibleSize if subviews size changes

@property (nonatomic, assign) CGFloat sizeLimit; // textLabel根据文本计算size时，如果纵向布局则限高，横向布局则限宽

@property (nonatomic, strong) SnailIconLabelModel *model; // Model of the assignment.

- (void)updateLayoutBySize:(CGSize)size
                  finished:(void (^)(SnailIconLabel *item))finished; // 设置属性值后需要更新布局

@end

@interface SnailIconLabelModel : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *text;
+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image;

@end
