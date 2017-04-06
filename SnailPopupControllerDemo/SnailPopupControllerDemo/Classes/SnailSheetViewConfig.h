//
//  SnailSheetViewConfig.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/4/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnailSheetViewLayout : NSObject

// layout shortcut
+ (instancetype)layoutWithItemSize:(CGSize)itemSize
                     itemEdgeInset:(UIEdgeInsets)itemEdgeInset
                       itemSpacing:(CGFloat)itemSpacing
                   imageViewWidth:(CGFloat)imageViewWidth
                        subSpacing:(CGFloat)subSpacing;

// You must set itemSize
@property (nonatomic, assign) CGSize  itemSize;
// Optional
@property (nonatomic, assign) UIEdgeInsets itemEdgeInset; // 边距
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat imageViewWidth; // imageView.height = imageView.width
@property (nonatomic, assign) CGFloat subSpacing; // textLabel.y = imageView.bottom + subSpacing

/* 若外部自定义headerLabel和footerLabel，需要设置对应的高度!
   若是使用默认的headerLabel和footerLabel时，可以在SnailSheetViewLayout.m中修改默认高度。为防止自适应高度计算错误，外部最好不要修改! */
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@end


@interface SnailSheetViewAppearance : NSObject

@property (nonatomic, strong) UIColor *sectionBackgroundColor;
@property (nonatomic, strong) UIColor *itemBackgroundColor;
@property (nonatomic, strong) UIColor *imageViewBackgroundColor;
@property (nonatomic, strong) UIColor *imageViewHighlightedColor;
@property (nonatomic, strong) UIColor *textLabelBackgroundColor;
@property (nonatomic, strong) UIColor *textLabelTextColor;
@property (nonatomic, strong) UIFont  *textLabelFont;
@property (nonatomic, assign) UIViewContentMode imageViewContentMode;
@property (nonatomic, assign) CGFloat imageViewCornerRadius;

@end


@interface SnailSheetItemModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
+ (instancetype)modelWithText:(NSString *)text image:(UIImage *)image;

@end
