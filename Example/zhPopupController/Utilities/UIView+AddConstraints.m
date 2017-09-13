//
//  UIView+AddConstraints.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "UIView+AddConstraints.h"

@implementation UIView (AddConstraints)

- (NSArray *)zh_makeConstraints:(void (^)(SnailConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    SnailConstraintMaker *constraintMaker = [[SnailConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

@end

typedef NS_ENUM(NSUInteger, SnailLayoutAttribute) {
    SnailLayoutAttributeEdges = 0,
    SnailLayoutAttributeSize,
    SnailLayoutAttributeCenter,
};

@interface SnailConstraintMaker ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) NSMutableArray<SnailConstraint *> *constraints;

@end

@implementation SnailConstraintMaker

- (id)initWithView:(UIView *)view {
    if (self = [super init]) {
        self.view = view;
        self.constraints = [NSMutableArray new];
    }
    return self;
}

- (NSArray *)install {
    NSArray *constraints = self.constraints.copy;
    for (SnailConstraint *constraint in constraints) {
        [constraint install];
    }
    return constraints;
}

- (SnailConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (SnailConstraint *)constraint:(SnailConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    SnailConstraint *sl_constraint = [[SnailConstraint alloc] initWithView:self.view];
    sl_constraint.layoutAttributes = [NSMutableArray arrayWithObjects:@(layoutAttribute), nil];
    [self.constraints addObject:sl_constraint];
    return sl_constraint;
}

- (SnailConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (SnailConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (SnailConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (SnailConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (SnailConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (SnailConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (SnailConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (SnailConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (SnailConstraint *)edges {
    return [self sl_addConstraintWithLayoutAttribute:SnailLayoutAttributeEdges];
}

- (SnailConstraint *)size {
    return [self sl_addConstraintWithLayoutAttribute:SnailLayoutAttributeSize];
}

- (SnailConstraint *)center {
    return [self sl_addConstraintWithLayoutAttribute:SnailLayoutAttributeCenter];
}

- (SnailConstraint *)sl_addConstraintWithLayoutAttribute:(SnailLayoutAttribute)layoutAttribute {
    SnailConstraint *sl_constraint = [[SnailConstraint alloc] initWithView:self.view];
    sl_constraint.layoutAttributes = [self sl_layoutAttribute:layoutAttribute];
    [self.constraints addObject:sl_constraint];
    return sl_constraint;
}

- (NSMutableArray *)sl_layoutAttribute:(SnailLayoutAttribute )layoutAttribute {
    switch (layoutAttribute) {
        case SnailLayoutAttributeEdges:
            return [NSMutableArray arrayWithObjects:
                    @(NSLayoutAttributeLeft),
                    @(NSLayoutAttributeTop),
                    @(NSLayoutAttributeBottom),
                    @(NSLayoutAttributeRight), nil];
        case SnailLayoutAttributeSize:
            return [NSMutableArray arrayWithObjects:
                    @(NSLayoutAttributeWidth),
                    @(NSLayoutAttributeHeight), nil];
        case SnailLayoutAttributeCenter:
            return [NSMutableArray arrayWithObjects:
                    @(NSLayoutAttributeCenterX),
                    @(NSLayoutAttributeCenterY), nil];
        default: break;
    }
}

@end

@implementation SnailConstraint {
    NSMutableArray *_constraints;
}

- (instancetype)initWithView:(UIView *)view {
    if (self = [super init]) {
        _constraints = [NSMutableArray new];
        self.firstItem = view;
    }
    return self;
}

- (void)install {
    [self.firstItem.superview addConstraints:_constraints];
}

- (SnailConstraint *)equalTo:(UIView *)view {
    for (NSNumber *obj in self.layoutAttributes) {
        NSLayoutAttribute attr = (NSLayoutAttribute)obj.integerValue;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                      attribute:attr
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:view
                                                                      attribute:attr
                                                                     multiplier:1
                                                                       constant:0];
        [_constraints addObject:constraint];
    }
    return self;
}

- (SnailConstraint *)zh_equalTo:(CGFloat)c {
    
    for (NSNumber *obj in self.layoutAttributes) {
        NSLayoutAttribute attr = (NSLayoutAttribute)obj.integerValue;
        
        if (NSLayoutAttributeWidth == attr || NSLayoutAttributeHeight == attr) { // 宽高 -> size
          
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                          attribute:attr
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:c];
            [_constraints addObject:constraint];
            
        } else {
            
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                          attribute:attr
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.firstItem.superview
                                                                          attribute:attr
                                                                         multiplier:1
                                                                           constant:c];
            [_constraints addObject:constraint];
        }
    }
    return self;
}

@end
