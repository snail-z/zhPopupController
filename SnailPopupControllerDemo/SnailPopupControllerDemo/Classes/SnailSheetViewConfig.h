//
//  SnailSheetViewConfig.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/4/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SHEETVIEW_HEADER_HEIGHT 30
#define SHEETVIEW_FOOTER_HEIGHT 50

@interface SnailSheetViewLayout : NSObject

// layout shortcut
+ (instancetype)layoutWithItemSize:(CGSize)itemSize
                     itemEdgeInset:(UIEdgeInsets)itemEdgeInset
                       itemSpacing:(CGFloat)itemSpacing
                   imageViewWidth:(CGFloat)imageViewWidth
                        subSpacing:(CGFloat)subSpacing;

@property (nonatomic, assign) CGSize itemSize; // Must set itemSize
@property (nonatomic, assign) UIEdgeInsets itemEdgeInset; // 边距
@property (nonatomic, assign) CGFloat itemSpacing; // item1 <- itemSpacing -> item2
@property (nonatomic, assign) CGFloat imageViewWidth; // imageView.height = imageView.width = imageViewWidth
@property (nonatomic, assign) CGFloat subSpacing; // textLabel.y = imageView.bottom + subSpacing

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
