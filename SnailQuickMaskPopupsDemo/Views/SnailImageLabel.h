//
//  SnailImageLabel.h
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnailImageLabelItem : NSObject

@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *title;

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image;

@end

@interface SnailImageLabel : UIButton

@property (nonatomic, strong) UIButton *imgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) CGFloat padding; 

- (void)setItem:(SnailImageLabelItem *)item;

@end
