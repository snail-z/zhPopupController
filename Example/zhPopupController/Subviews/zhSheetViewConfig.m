//
//  zhSheetViewConfig.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/11/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhSheetViewConfig.h"

@implementation zhSheetViewLayout

+ (instancetype)layoutWithItemSize:(CGSize)itemSize
                     itemEdgeInset:(UIEdgeInsets)itemEdgeInset
                       itemSpacing:(CGFloat)itemSpacing
                    imageViewWidth:(CGFloat)imageViewWidth
                        subSpacing:(CGFloat)subSpacing {

    zhSheetViewLayout *layout = [[zhSheetViewLayout alloc] init];
    layout.itemSize = itemSize;
    layout.itemEdgeInset = itemEdgeInset;
    layout.itemSpacing = itemSpacing;
    layout.imageViewWidth = imageViewWidth;
    layout.subSpacing = subSpacing;
    return layout;
}

- (CGFloat)imageWidth {
    if (_imageViewWidth > 0) return _imageViewWidth;
    return _itemSize.width;
}

@end

@implementation zhSheetViewAppearance

- (UIColor *)sectionBackgroundColor {
    if (_sectionBackgroundColor) {
        return _sectionBackgroundColor;
    }
    return [UIColor clearColor];
}

- (UIColor *)itemBackgroundColor {
    if (_itemBackgroundColor) {
        return _itemBackgroundColor;
    }
    return [UIColor clearColor]; // default value
}

- (UIColor *)imageViewBackgroundColor {
    if (_imageViewBackgroundColor) {
        return _imageViewBackgroundColor;
    }
    return [UIColor whiteColor];
}

- (UIColor *)imageViewHighlightedColor {
    if (_imageViewHighlightedColor) {
        return _imageViewHighlightedColor;
    }
    return [UIColor grayColor];
}

- (UIViewContentMode)imageViewContentMode {
    if (_imageViewContentMode) {
        return _imageViewContentMode;
    }
    return UIViewContentModeScaleToFill;
}

- (CGFloat)imageViewCornerRadius {
    if (_imageViewCornerRadius > 0) {
        return _imageViewCornerRadius;
    }
    return 15.0;
}

- (UIColor *)textLabelBackgroundColor {
    if (_textLabelBackgroundColor) {
        return _textLabelBackgroundColor;
    }
    return [UIColor clearColor];
}

- (UIColor *)textLabelTextColor {
    if (_textLabelTextColor) {
        return _textLabelTextColor;
    }
    return [UIColor darkGrayColor];
}

- (UIFont *)textLabelFont {
    if (_textLabelFont) {
        return _textLabelFont;
    }
    return [UIFont systemFontOfSize:10];
}

@end

@implementation zhSheetItemModel

+ (instancetype)modelWithText:(NSString *)text image:(UIImage *)image {
    zhSheetItemModel *model = [[zhSheetItemModel alloc] init];
    model.text = text;
    model.image = image;
    return model;
}

@end
