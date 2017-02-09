//
//  SnailQuickMaskPopups.m
//  <https://github.com/snail-z/zhPopups.git>
//
//  Created by zhanghao on 2016/11/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "SnailQuickMaskPopups.h"

@interface SnailQuickMaskPopups () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWindow *windowView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *popupsView;
@property (nonatomic, assign) CGFloat maskAlpha;
@property (nonatomic, assign) CGPoint panPoint;
@property (nonatomic, assign) BOOL isAnimated;
@property (nonatomic, assign) BOOL isPresented;                                 

@end

@implementation SnailQuickMaskPopups

- (void)defaultSettings {
    _maskAlpha                  = 0.5;
    _isAnimated                 = YES;
    _shouldDismissOnMaskTouch   = YES;
    _shouldDismissOnPopupsDrag  = NO;
    _dismissesOppositeDirection = NO;
    _isPresented                = NO;
}

#pragma mark - initialization

+ (instancetype)popupsWithView:(UIView *)popupView maskStyle:(SnailPopupsMaskStyle)maskStyle {
    return [[self alloc] initWithPopups:popupView maskStyle:maskStyle];
}

- (instancetype)initWithPopups:(UIView *)popupView
                     maskStyle:(SnailPopupsMaskStyle)maskStyle {
    if (self = [super init]) {
        [self defaultSettings];
    
        _windowView = [UIApplication sharedApplication].keyWindow;
        _maskView = [self maskStyleSettings:maskStyle];
        
        popupView.frame = (CGRect){.origin = CGPointZero, .size = popupView.frame.size};
        _popupsView = [UIView new];
        _popupsView.frame = popupView.frame;
        _popupsView.clipsToBounds = YES;
        _popupsView.backgroundColor = popupView.backgroundColor;
        _popupsView.layer.cornerRadius = popupView.layer.cornerRadius;
        [_popupsView addSubview:popupView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskWhenTapped:)];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
        [_maskView addSubview:_popupsView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_popupsView addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_popupsView]) return NO;
    return YES;
}

- (void)maskWhenTapped:(UITapGestureRecognizer *)tap {
    if (_shouldDismissOnMaskTouch) {
        [self dismissPopupsAnimated:_isAnimated completion:NULL];
    }
}

#pragma mark - maskView Settings

- (UIView *)maskStyleSettings:(SnailPopupsMaskStyle)maskStyle {
    switch (maskStyle) {
        case SnailPopupsMaskStyleBlackTranslucent:
            return [self backgroundWithColor:[UIColor colorWithWhite:0.0 alpha:_maskAlpha]];
            break;
        case SnailPopupsMaskStyleClear:
            return [self backgroundWithColor:[UIColor clearColor]];
            break;
        case SnailPopupsMaskStyleWhite:
            return [self backgroundWithColor:[UIColor whiteColor]];
            break;
        case SnailPopupsMaskStyleBlurTranslucentBlack:
            return [self blurTranslucentView:UIBarStyleBlackTranslucent];
            break;
        case SnailPopupsMaskStyleBlurTranslucentWhite:
            return [self blurTranslucentView:UIBarStyleDefault];
            break;
        default: break;
    }
}

- (UIView *)blurTranslucentView:(UIBarStyle)barStyle {
    UIToolbar *blurTranslucentView = [[UIToolbar alloc] initWithFrame:_windowView.bounds];
    [blurTranslucentView setBarStyle:barStyle];
    return blurTranslucentView;
}

- (UIView *)backgroundWithColor:(UIColor *)backgroundColor {
    UIView *backgroundView = [[UIView alloc] initWithFrame:_windowView.bounds];
    backgroundView.backgroundColor = backgroundColor;
    return backgroundView;
}

#pragma mark - calculation point

- (CGPoint)startingPoint {
    CGPoint point = _maskView.center;
    switch (_presentationStyle) {
        case SnailPopupsPresentationStyleCentered:
            point = [self presentPointForPresentationStyleCentered];
            break;
        case SnailPopupsPresentationStyleActionSheet:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupsView.bounds.size.height);
            break;
        case SnailPopupsPresentationStyleCurtain:
            point = CGPointMake(_maskView.center.x, -_popupsView.bounds.size.height);
            break;
        case SnailPopupsPresentationStyleSlideLeft:
            point = CGPointMake(-_popupsView.bounds.size.width, _maskView.center.y);
            break;
        case SnailPopupsPresentationStyleSlideRight:
            point = CGPointMake(_maskView.bounds.size.width + _popupsView.bounds.size.width, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

- (CGPoint)finishingPoint {
    CGPoint point = _maskView.center;
    switch (_presentationStyle) {
        case SnailPopupsPresentationStyleCentered: {
            switch (_transitionStyle) {
                    case SnailPopupsTransitionStyleTransformScale:
                    _maskView.transform = CGAffineTransformIdentity;
                    break;
                default: break;
            }
        } break;
        case SnailPopupsPresentationStyleActionSheet:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height - _popupsView.bounds.size.height * 0.5);
            break;
        case SnailPopupsPresentationStyleCurtain:
            point = CGPointMake(_maskView.center.x, _popupsView.bounds.size.height * 0.5);
            break;
        case SnailPopupsPresentationStyleSlideLeft:
            point = CGPointMake(_popupsView.bounds.size.width * 0.5, _maskView.center.y);
            break;
        case SnailPopupsPresentationStyleSlideRight:
            point = CGPointMake(_maskView.bounds.size.width - _popupsView.bounds.size.width * 0.5, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

- (CGPoint)dismissedPoint {
    CGPoint point = _maskView.center;
    switch (_presentationStyle) {
        case SnailPopupsPresentationStyleCentered:
            point = [self dismissedPointForPresentationStyleCentered];
            break;
        case SnailPopupsPresentationStyleActionSheet:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupsView.bounds.size.height);
            break;
        case SnailPopupsPresentationStyleCurtain:
            point = CGPointMake(_maskView.center.x, -_popupsView.bounds.size.height);
            break;
        case SnailPopupsPresentationStyleSlideLeft:
            point = CGPointMake(-_popupsView.bounds.size.width, _maskView.center.y);
            break;
        case SnailPopupsPresentationStyleSlideRight:
            point = CGPointMake(_maskView.bounds.size.width + _popupsView.bounds.size.width, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

- (CGPoint)presentPointForPresentationStyleCentered {
    CGPoint point = _maskView.center;
    switch (_transitionStyle) {
        case SnailPopupsTransitionStyleCrossDissolve:
            break;
        case SnailPopupsTransitionStyleTransformScale:
            _maskView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            break;
        case SnailPopupsTransitionStyleSlideInFromTop:
            point = CGPointMake(_maskView.center.x, -_popupsView.bounds.size.height);
            break;
        case SnailPopupsTransitionStyleSlideInFromBottom:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupsView.bounds.size.height);
            break;
        case SnailPopupsTransitionStyleSlideInFromLeft:
            point = CGPointMake(-_popupsView.bounds.size.width, _maskView.center.y);
            break;
        case SnailPopupsTransitionStyleSlideInFromRight:
            point = CGPointMake(_maskView.bounds.size.width + _popupsView.bounds.size.width, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

- (CGPoint)dismissedPointForPresentationStyleCentered {
    CGPoint point = _maskView.center;
    switch (_transitionStyle) {
        case SnailPopupsTransitionStyleCrossDissolve:
        case SnailPopupsTransitionStyleTransformScale:
            break;
        case SnailPopupsTransitionStyleSlideInFromTop:
            point = _dismissesOppositeDirection ? CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupsView.bounds.size.height) : CGPointMake(_maskView.center.x, -_popupsView.bounds.size.height);
            break;
        case SnailPopupsTransitionStyleSlideInFromBottom:
            point = _dismissesOppositeDirection ? CGPointMake(_maskView.center.x, -_popupsView.bounds.size.height) : CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupsView.bounds.size.height);
            break;
        case SnailPopupsTransitionStyleSlideInFromLeft:
            point = _dismissesOppositeDirection ? CGPointMake(_maskView.bounds.size.width + _popupsView.bounds.size.width, _maskView.center.y) : CGPointMake(-_popupsView.bounds.size.width, _maskView.center.y);
            break;
        case SnailPopupsTransitionStyleSlideInFromRight:
            point = _dismissesOppositeDirection ? CGPointMake(-_popupsView.bounds.size.width, _maskView.center.y) : CGPointMake(_maskView.bounds.size.width + _popupsView.bounds.size.width, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

#pragma mark - present

- (void)presentPopupsAnimated:(BOOL)flag
                   completion:(void (^)(BOOL, SnailQuickMaskPopups * _Nonnull))completion {
    if ([_delegate respondsToSelector:@selector(snailQuickMaskPopupsWillPresent:)]) {
        [_delegate snailQuickMaskPopupsWillPresent:self];
    }
    
    _isAnimated = flag;
    [_windowView addSubview:_maskView];
    _maskView.alpha = 0;
    
    _popupsView.center = [self startingPoint];
    
    NSTimeInterval interval = _isAnimated ? 0.25 : 0;
    [UIView animateWithDuration:interval animations:^{
        _maskView.alpha = 1;
        _popupsView.center = [self finishingPoint];
    } completion:^(BOOL finished) {
        _isPresented = YES;
        if (completion) {
            completion(finished, self);
        } else {
            if ([_delegate respondsToSelector:@selector(snailQuickMaskPopupsDidPresent:)]) {
                [_delegate snailQuickMaskPopupsDidPresent:self];
            }
        }
    }];
}

#pragma mark - dismiss

- (void)dismissPopupsAnimated:(BOOL)flag
                   completion:(void (^)(BOOL, SnailQuickMaskPopups * _Nonnull))completion {
    if ([_delegate respondsToSelector:@selector(snailQuickMaskPopupsWillDismiss:)]) {
        [_delegate snailQuickMaskPopupsWillDismiss:self];
    }
    
    NSTimeInterval interval = flag ? 0.25 : 0;
    [UIView animateWithDuration:interval animations:^{
        _maskView.alpha = 0;
        _popupsView.center = [self dismissedPoint];
    } completion:^(BOOL finished) {
        _isPresented = NO;
        [_maskView removeFromSuperview];
        if (completion) {
            completion(finished, self);
        } else {
            if ([_delegate respondsToSelector:@selector(snailQuickMaskPopupsDidDismiss:)]) {
                [_delegate snailQuickMaskPopupsDidDismiss:self];
            }
        }
    }];
}

#pragma mark - handle Pan

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (!_shouldDismissOnPopupsDrag || !_isPresented) return;
    
    CGPoint translation = [g translationInView:_maskView];
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_presentationStyle) {
                case SnailPopupsPresentationStyleCentered: {
                    BOOL verticalTransformation = NO;
                    switch (_transitionStyle) {
                        case SnailPopupsTransitionStyleCrossDissolve:
                        case SnailPopupsTransitionStyleTransformScale:
                        case SnailPopupsTransitionStyleSlideInFromTop:
                        case SnailPopupsTransitionStyleSlideInFromBottom: // vertical sliding
                            verticalTransformation = YES;
                            break;
                        default: break;
                    }
                    
                    NSInteger coefficient = 4; // set screen ratio `_maskView.bounds.size.height / coefficient`
                    CGFloat changeValue;
                    if (verticalTransformation) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                        changeValue = g.view.center.y / (_maskView.bounds.size.height / coefficient);
                    } else {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                        changeValue = g.view.center.x / (_maskView.bounds.size.width / coefficient);
                    }
                    CGFloat alpha = coefficient * 0.5 - fabs(changeValue - coefficient * 0.5);
                    [UIView animateWithDuration:0.15 animations:^{
                        _maskView.alpha = alpha;
                    } completion:NULL];
                } break;
                case SnailPopupsPresentationStyleActionSheet: {
                    if (g.view.frame.origin.y + translation.y > _maskView.bounds.size.height - g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case SnailPopupsPresentationStyleCurtain: {
                    if (g.view.frame.origin.y + g.view.frame.size.height + translation.y  < g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case SnailPopupsPresentationStyleSlideLeft: {
                    if (g.view.frame.origin.x + g.view.frame.size.width + translation.x < g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                case SnailPopupsPresentationStyleSlideRight: {
                    if (g.view.frame.origin.x + translation.x > _maskView.bounds.size.width - g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                default: break;
            }
            [g setTranslation:CGPointZero inView:_maskView];
        } break;
        case UIGestureRecognizerStateEnded: {
            BOOL willDismiss = YES, styleCentered = NO;
            switch (_presentationStyle) {
                case SnailPopupsPresentationStyleCentered: {
                    styleCentered = YES;
                    if (g.view.center.y != _maskView.center.y) {
                        if (g.view.center.y > _maskView.bounds.size.height * 0.25 && g.view.center.y < _maskView.bounds.size.height * 0.75) {
                            willDismiss = NO;
                        }
                    } else {
                        if (g.view.center.x > _maskView.bounds.size.width * 0.25 && g.view.center.x < _maskView.bounds.size.width * 0.75) {
                            willDismiss = NO;
                        }
                    }
                } break;
                case SnailPopupsPresentationStyleActionSheet:
                    willDismiss = g.view.frame.origin.y > _maskView.bounds.size.height - g.view.frame.size.height * 0.75;
                    break;
                case SnailPopupsPresentationStyleCurtain:
                    willDismiss = g.view.frame.origin.y + g.view.frame.size.height < g.view.frame.size.height * 0.75;
                    break;
                case SnailPopupsPresentationStyleSlideLeft:
                    willDismiss = g.view.frame.origin.x + g.view.frame.size.width < g.view.frame.size.width * 0.75;
                    break;
                case SnailPopupsPresentationStyleSlideRight:
                    willDismiss = g.view.frame.origin.x > _maskView.bounds.size.width - g.view.frame.size.width * 0.75;
                    break;
                default: break;
            }
            if (willDismiss) {
                if (styleCentered) {
                    switch (_transitionStyle) {
                        case SnailPopupsTransitionStyleCrossDissolve:
                        case SnailPopupsTransitionStyleTransformScale: {
                            if (g.view.center.y < _maskView.bounds.size.height * 0.25) {
                                _transitionStyle = SnailPopupsTransitionStyleSlideInFromTop;
                            } else {
                                if (g.view.center.y > _maskView.bounds.size.height * 0.75) {
                                    _transitionStyle = SnailPopupsTransitionStyleSlideInFromBottom;
                                }
                            }
                            _dismissesOppositeDirection = NO;
                        } break;
                        case SnailPopupsTransitionStyleSlideInFromTop:
                            _dismissesOppositeDirection = g.view.center.y < _maskView.bounds.size.height * 0.25 ? NO : YES;
                            break;
                        case SnailPopupsTransitionStyleSlideInFromBottom:
                            _dismissesOppositeDirection = g.view.center.y < _maskView.bounds.size.height * 0.25 ? YES : NO;
                            break;
                        case SnailPopupsTransitionStyleSlideInFromLeft:
                            _dismissesOppositeDirection = g.view.center.x < _maskView.bounds.size.width * 0.25 ? NO : YES;
                            break;
                        case SnailPopupsTransitionStyleSlideInFromRight:
                            _dismissesOppositeDirection = g.view.center.x < _maskView.bounds.size.width * 0.25 ? YES : NO;
                            break;
                        default: break;
                    }
                }
                [self dismissPopupsAnimated:YES completion:NULL];
            } else { // restore view location
                [UIView animateWithDuration:0.15 animations:^{
                    g.view.center = [self finishingPoint];
                } completion:NULL];
            }
        } break;
        case UIGestureRecognizerStateCancelled:
            break;
        default: break;
    }
}

@end
