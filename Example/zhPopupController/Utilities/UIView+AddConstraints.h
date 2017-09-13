//
//  UIView+AddConstraints.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnailConstraintMaker, SnailConstraint;

@interface UIView (AddConstraints)

- (NSArray *)zh_makeConstraints:(void(^)(SnailConstraintMaker *make))block;

@end

@interface SnailConstraintMaker : NSObject

@property (nonatomic, strong, readonly) SnailConstraint *left;
@property (nonatomic, strong, readonly) SnailConstraint *top;
@property (nonatomic, strong, readonly) SnailConstraint *right;
@property (nonatomic, strong, readonly) SnailConstraint *bottom;
@property (nonatomic, strong, readonly) SnailConstraint *edges;
@property (nonatomic, strong, readonly) SnailConstraint *width;
@property (nonatomic, strong, readonly) SnailConstraint *height;
@property (nonatomic, strong, readonly) SnailConstraint *size;
@property (nonatomic, strong, readonly) SnailConstraint *centerX;
@property (nonatomic, strong, readonly) SnailConstraint *centerY;
@property (nonatomic, strong, readonly) SnailConstraint *center;

- (id)initWithView:(UIView *)view;
- (NSArray *)install; // @return    an array of all the installed SnailConstraints

@end

@interface SnailConstraint : NSObject

@property (nonatomic, strong) NSMutableArray *layoutAttributes;
@property (nonatomic, weak) UIView *firstItem;

- (instancetype)initWithView:(UIView *)view;
- (void)install;

- (SnailConstraint *)equalTo:(UIView *)view;
- (SnailConstraint *)zh_equalTo:(CGFloat)c;

@end
