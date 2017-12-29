//
//  zhImageButton.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/9/26.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhImageButtonModel : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *text;
+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image;

@end

typedef NS_ENUM(NSInteger, zhImageButtonPosition) {
    zhImageButtonPositionLeft = 0,    // 图片在左，文字在右，默认
    zhImageButtonPositionRight,       // 图片在右，文字在左
    zhImageButtonPositionTop,         // 图片在上，文字在下
    zhImageButtonPositionBottom,      // 图片在下，文字在上
};

@interface zhImageButton : UIButton

- (void)imagePosition:(zhImageButtonPosition)postion spacing:(CGFloat)spacing;
- (void)imagePosition:(zhImageButtonPosition)postion spacing:(CGFloat)spacing imageViewResize:(CGSize)size;

@end
