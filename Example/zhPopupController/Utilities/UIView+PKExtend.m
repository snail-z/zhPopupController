//
//  UIView+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIView+PKExtend.h"
#import <objc/runtime.h>

@implementation UIView (PKFrameAdjust)

- (CGFloat)pk_left {
    return self.frame.origin.x;
}

- (void)setPk_left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)pk_top {
    return self.frame.origin.y;
}

- (void)setPk_top:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)pk_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setPk_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)pk_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setPk_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)pk_width {
    return self.frame.size.width;
}

- (void)setPk_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)pk_height {
    return self.frame.size.height;
}

- (void)setPk_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)pk_centerX {
    return self.center.x;
}

- (void)setPk_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)pk_centerY {
    return self.center.y;
}

- (void)setPk_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)pk_origin {
    return self.frame.origin;
}

- (void)setPk_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)pk_size {
    return self.frame.size;
}

- (void)setPk_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end


@implementation UIView (PKVisuals)

- (void)pk_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners {
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        [self.superview layoutIfNeeded];
    }
    CGRect rect = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (CAShapeLayer *)pk_edgeLineAssociated {
    CAShapeLayer *edgeLayer = objc_getAssociatedObject(self, _cmd);
    if (!edgeLayer) {
        edgeLayer = [CAShapeLayer layer];
        edgeLayer.zPosition = 2999;
        objc_setAssociatedObject(self, _cmd, edgeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return edgeLayer;
}

- (void)pk_addEdgeLineWidth:(CGFloat)width color:(UIColor *)color byEdgePosition:(PKEdgeLinePosition)position {
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        [self.superview layoutIfNeeded];
    }
    if (CGRectIsEmpty(self.frame) || !position) return;
    if (width <= 0) {
        CALayer *layer = objc_getAssociatedObject(self, @selector(pk_edgeLineAssociated));
        if (layer) {
            [layer removeFromSuperlayer];
            objc_setAssociatedObject(self, @selector(pk_edgeLineAssociated), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat halfWidth = width * 0.5;
    if (position & PKEdgeLinePositionLeft) {
        [path moveToPoint:CGPointMake(halfWidth, 0)];
        [path addLineToPoint:CGPointMake(halfWidth, self.frame.size.height)];
    }
    if (position & PKEdgeLinePositionRight) {
        [path moveToPoint:CGPointMake(self.frame.size.width - halfWidth, 0)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - halfWidth, self.frame.size.height)];
    }
    if (position & PKEdgeLinePositionTop) {
        [path moveToPoint:CGPointMake(0, halfWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, halfWidth)];
    }
    if (position & PKEdgeLinePositionBottom) {
        [path moveToPoint:CGPointMake(0, self.frame.size.height - halfWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - halfWidth)];
    }
    self.pk_edgeLineAssociated.path = path.CGPath;
    self.pk_edgeLineAssociated.strokeColor = color.CGColor;
    self.pk_edgeLineAssociated.lineWidth = width;
    self.pk_edgeLineAssociated.fillColor = [UIColor clearColor].CGColor;
    if (!self.pk_edgeLineAssociated.superlayer) {
        [self.layer addSublayer:self.pk_edgeLineAssociated];
    }
}

- (void)pk_addDefaultEdgeLineByPosition:(PKEdgeLinePosition)position {
    return [self pk_addEdgeLineWidth:1 / [UIScreen mainScreen].scale
                               color:[UIColor colorWithRed:220 / 255. green:220 / 255. blue:220 / 255. alpha:1]
                      byEdgePosition:position];
}

@end


@implementation UIView (PKExtend)

- (void)pk_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (UIViewController *)pk_inViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end


static void *UIViewAssociatedPKBadgeLabelKey = &UIViewAssociatedPKBadgeLabelKey;
@implementation UIView (PKBadge)

- (CGRect)_badgeDefaultRect {
    return CGRectMake(0, 0, 18, 18);
}

- (UILabel *)pk_badgeLabel {
    UILabel *badgeLabel = objc_getAssociatedObject(self, UIViewAssociatedPKBadgeLabelKey);
    if (!badgeLabel) {
        badgeLabel = [[UILabel alloc] init];
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:13];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.frame = [self _badgeDefaultRect];
        badgeLabel.center = CGPointMake(self.bounds.size.width, 0);
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.alpha = 0;
        [self addSubview:badgeLabel];
        [self bringSubviewToFront:badgeLabel];
        objc_setAssociatedObject(self, UIViewAssociatedPKBadgeLabelKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return badgeLabel;
}

- (void)setBadgeText:(NSString *)text {
    self.pk_badgeShowing = YES;
    self.pk_badgeLabel.transform = CGAffineTransformIdentity;
    self.pk_badgeLabel.text = text;
    
    if (text && text.length) {
        self.pk_badgeLabel.frame = [self _badgeDefaultRect];
        CGFloat _width = [self.pk_badgeLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.pk_badgeLabel.frame.size.height)].width;
        CGRect originRect = self.pk_badgeLabel.frame;
        originRect.size.width = _width + 3;
        if (originRect.size.height > originRect.size.width) {
            originRect.size.width = originRect.size.height; // 使宽度>=高度
        }
        self.pk_badgeLabel.frame = originRect;
    }
    
    if ([self pk_badgeAlwaysRound]) {
        CGPoint originCenter = self.pk_badgeLabel.center;
        CGRect originRect = self.pk_badgeLabel.frame;
        originRect.size.height = originRect.size.width;
        self.pk_badgeLabel.frame  = originRect;
        self.pk_badgeLabel.layer.cornerRadius = self.pk_badgeLabel.frame.size.height / 2;
        self.pk_badgeLabel.center = originCenter;
    }
    
    CGFloat transformHeight = [self pk_badgeTransformHeight];
    if (transformHeight > 0) {
        CGFloat scale = transformHeight / self.pk_badgeLabel.frame.size.height;
        CGAffineTransform transform = self.pk_badgeLabel.transform;
        self.pk_badgeLabel.transform = CGAffineTransformScale(transform, scale, scale);
    }
    
    [self pk_badgeOffset:[self pk_badgeOffset]];
}

- (void)pk_showBadgeWithText:(NSString *)text {
    [self setBadgeText:text];
    if (self.pk_badgeLabel.alpha > 0) return;
    self.pk_badgeLabel.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.pk_badgeLabel.alpha = 1;
    }];
}

- (void)pk_badgeHide {
    if (!self.pk_badgeShowing) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.pk_badgeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.pk_badgeShowing = NO;
    }];
}

- (void)pk_badgeRemove {
    if (!self.pk_badgeShowing) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.pk_badgeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.pk_badgeShowing = NO;
        [self.pk_badgeLabel removeFromSuperview];
        objc_setAssociatedObject(self, @selector(pk_badgeAlwaysRound), @(NO), OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, @selector(pk_badgeOffset), [NSValue valueWithUIOffset:UIOffsetZero], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, UIViewAssociatedPKBadgeLabelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (UIOffset)pk_badgeOffset {
    return [objc_getAssociatedObject(self, _cmd) UIOffsetValue];
}

- (void)pk_badgeOffset:(UIOffset)offset {
    self.pk_badgeShowing = YES;
    NSValue *value = [NSValue valueWithUIOffset:offset];
    objc_setAssociatedObject(self, @selector(pk_badgeOffset), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGSize originSize = self.pk_badgeLabel.frame.size;
    CGFloat offsetX = (self.bounds.size.width - self.pk_badgeLabel.frame.size.width / 2) + offset.horizontal;
    CGFloat offsetY = (-self.pk_badgeLabel.frame.size.height / 2) + offset.vertical;
    self.pk_badgeLabel.frame = CGRectMake(offsetX, offsetY, originSize.width, originSize.height);
}

- (BOOL)pk_badgeAlwaysRound {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)pk_badgeAlwaysRound:(BOOL)isRound {
    objc_setAssociatedObject(self, @selector(pk_badgeAlwaysRound), @(isRound), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBadgeText:self.pk_badgeLabel.text];
}

- (CGFloat)pk_badgeTransformHeight {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)pk_badgeTransformHeight:(CGFloat)height {
    objc_setAssociatedObject(self, @selector(pk_badgeTransformHeight), @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBadgeText:self.pk_badgeLabel.text];
}

- (BOOL)pk_badgeShowing {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setPk_badgeShowing:(BOOL)pk_badgeShowing {
    objc_setAssociatedObject(self, @selector(pk_badgeShowing), @(pk_badgeShowing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


static void *UIViewPKIsIndicatorLoadingKey = &UIViewPKIsIndicatorLoadingKey;
static void *UIViewPKIndicatorLoadingViewKey = &UIViewPKIndicatorLoadingViewKey;
static void *UIViewPKIndicatorTipLabelKey = &UIViewPKIndicatorTipLabelKey;

@implementation UIView (PKIndicatorLoading)

- (BOOL)pk_isIndicatorLoading {
    return [objc_getAssociatedObject(self, UIViewPKIsIndicatorLoadingKey) boolValue];
}

- (void)pk_setIndicatorLoading:(BOOL)pk_isIndicatorLoading {
    objc_setAssociatedObject(self, UIViewPKIsIndicatorLoadingKey, @(pk_isIndicatorLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)pk_indicatorView {
    UIActivityIndicatorView *loadingView = objc_getAssociatedObject(self, UIViewPKIndicatorLoadingViewKey);
    if (!loadingView) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = NO;
        loadingView.color = [UIColor grayColor];
        objc_setAssociatedObject(self, UIViewPKIndicatorLoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return loadingView;
}

- (UILabel *)pk_indicatorLabel {
    UILabel *indicatorLabel = objc_getAssociatedObject(self, UIViewPKIndicatorTipLabelKey);
    if (!indicatorLabel) {
        indicatorLabel = [[UILabel alloc] init];
        indicatorLabel.numberOfLines = 1;
        indicatorLabel.font = [UIFont systemFontOfSize:12];
        indicatorLabel.textAlignment = NSTextAlignmentCenter;
        indicatorLabel.textColor = [UIColor grayColor];
        indicatorLabel.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 20);
        objc_setAssociatedObject(self, UIViewPKIndicatorTipLabelKey, indicatorLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return indicatorLabel;
}

- (void)pk_beginIndicatorLoading:(UIColor *)tintColor {
    if (self.pk_isIndicatorLoading) return;
    [self pk_beginIndicatorLoadingText:nil tintColor:tintColor];
}

- (void)pk_beginIndicatorLoadingText:(NSString *)message {
    if (self.pk_isIndicatorLoading) return;
    [self pk_beginIndicatorLoadingText:message tintColor:[UIColor grayColor]];
}

- (void)pk_beginIndicatorLoadingText:(NSString *)message tintColor:(UIColor *)tintColor {
    if (self.pk_isIndicatorLoading) return;
    [self pk_setIndicatorLoading:YES];
    [self layoutIfNeeded];
    [self addSubview:self.pk_indicatorView];
    self.pk_indicatorView.color = tintColor;
    self.pk_indicatorView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self.pk_indicatorView startAnimating];
    if (message) {
        [self addSubview:self.pk_indicatorLabel];
        self.pk_indicatorLabel.text = message;
        self.pk_indicatorLabel.textColor = tintColor;
        self.pk_indicatorLabel.center = CGPointMake(self.bounds.size.width / 2, self.pk_indicatorView.center.y + self.pk_indicatorView.bounds.size.height + 5);
    }
}

- (void)pk_beginIndicatorLoading {
    if (self.pk_isIndicatorLoading) return;
    [self pk_beginIndicatorLoadingText:nil tintColor:[UIColor grayColor]];
}

- (void)pk_endIndicatorLoading {
    if (!self.pk_isIndicatorLoading) return;
    [self pk_setIndicatorLoading:NO];
    [self.pk_indicatorView stopAnimating];
    [self.pk_indicatorView removeFromSuperview];
    objc_setAssociatedObject(self, UIViewPKIndicatorLoadingViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (objc_getAssociatedObject(self, UIViewPKIndicatorTipLabelKey)) {
        [self.pk_indicatorLabel removeFromSuperview];
        objc_setAssociatedObject(self, UIViewPKIndicatorTipLabelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end


static void *UIViewPKTipToastShowingKey = &UIViewPKTipToastShowingKey;

@implementation UIView (PKTipToast)

- (BOOL)pk_isToastShowing {
    return [objc_getAssociatedObject(self, UIViewPKTipToastShowingKey) boolValue];
}

- (void)pk_setToastShowing:(BOOL)pk_isToastShowing {
    objc_setAssociatedObject(self, UIViewPKTipToastShowingKey, @(pk_isToastShowing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)pk_showToastText:(NSString *)message {
    return [self pk_showToastText:message delay:1.5];
}

- (void)pk_showToastText:(NSString *)message delay:(NSTimeInterval)delay {
    if (self.pk_isToastShowing) return;
    
    if (!message || !message.length) return;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 10, 20);
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    CGSize size = [label sizeThatFits:CGSizeMake(200, 200)];
    size = CGSizeMake(ceil(size.width * scale) / scale, ceil(size.height * scale) / scale);
    label.frame = CGRectMake(0, 0, size.width, size.height);
    
    UIView *hud = [UIView new];
    hud.frame = CGRectMake(0, 0, size.width + insets.left + insets.right, size.height + insets.top + insets.bottom);
    hud.backgroundColor = [UIColor darkGrayColor];
    hud.clipsToBounds = YES;
    hud.layer.cornerRadius = 2;
    
    label.center = CGPointMake(hud.frame.size.width / 2, hud.frame.size.height / 2);
    [hud addSubview:label];
    hud.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 15);
    hud.alpha = 0;
    [self addSubview:hud];
    
    [UIView animateWithDuration:0.4 animations:^{
        hud.alpha = 1;
    }];
    
    [self pk_setToastShowing:YES];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.4 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
            [self pk_setToastShowing:NO];
        }];
    });
}

@end
