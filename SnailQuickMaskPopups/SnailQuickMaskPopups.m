//
//  SnailQuickMaskPopups.m
//  <https://github.com/snail-z/SnailQuickMaskPopups.git>
//
//  Created by zhanghao on 2016/11/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "SnailQuickMaskPopups.h"

@interface SnailQuickMaskPopups () <UIGestureRecognizerDelegate>

@property (nonatomic, weak)   UIView *superview;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, assign) BOOL isAnimated;
@property (nonatomic, assign) BOOL isPresented;

@end

@implementation SnailQuickMaskPopups

#pragma mark - default values

- (void)defaultInitialization {
    _presentationStyle = PresentationStyleCentered;
    _transitionStyle = TransitionStyleCrossDissolve;
    _maskAlpha = 0.5;
    _animateDuration = 0.25;
    _isAllowMaskTouch = YES;
    _isAllowPopupsDrag = NO;
    _isDismissedOppositeDirection = NO;
    _dampingRatio = 1.0;
}

#pragma mark - initialization

- (instancetype)initWithMaskStyle:(MaskStyle)maskStyle aView:(UIView *)aView {
    if (!aView) return nil;
    if (self = [super init]) {
        [self defaultInitialization];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _superview = keyWindow;
        
        _maskView = [self maskViewStyle:maskStyle];
        
        aView.frame = (CGRect){.origin = CGPointZero, .size = aView.frame.size};
        _popupView = [UIView new];
        _popupView.frame = aView.frame;
        _popupView.backgroundColor = aView.backgroundColor;
        if (aView.layer.cornerRadius > 0) {
            CAShapeLayer *roundRectLayer = [[CAShapeLayer alloc] init];
            roundRectLayer.bounds = _popupView.layer.bounds;
            roundRectLayer.frame = _popupView.layer.bounds;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_popupView.layer.bounds
                                                            cornerRadius:aView.layer.cornerRadius];
            roundRectLayer.path = path.CGPath;
            _popupView.layer.mask = roundRectLayer;
            _popupView.clipsToBounds = NO;
        }
        [_popupView addSubview:aView];
        [_maskView addSubview:_popupView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapped:)];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
        
        [_popupView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    }
    return self;
}

+ (instancetype)popupsWithMaskStyle:(MaskStyle)maskStyle aView:(UIView *)aView {
    return [[self alloc] initWithMaskStyle:maskStyle aView:aView];
}

#pragma mark - present

- (void)presentInView:(nullable UIView *)superview
             animated:(BOOL)animated
           completion:(void (^)(SnailQuickMaskPopups * _Nonnull))completion {
    
    if (nil != superview) {
        _superview = superview;
        _maskView.frame = _superview.frame;
    }
    [self presentAnimated:animated completion:completion];
}

- (void)presentAnimated:(BOOL)animated
             completion:(void (^)(SnailQuickMaskPopups * _Nonnull))completion {
    
    if (_delegate && [_delegate respondsToSelector:@selector(snailQuickMaskPopupsWillPresent:)]) {
        [_delegate snailQuickMaskPopupsWillPresent:self];
    }
    
    _popupView.userInteractionEnabled = NO;
    [_superview addSubview:_maskView];
    
    _isAnimated = animated;
    
    _maskView.alpha = 0;
    _popupView.center = [self startingPoint];
    
    if (_dampingRatio < 1) {
        [UIView animateWithDuration:animated ? _animateDuration*=3 : 0
                              delay:0.1
             usingSpringWithDamping:_dampingRatio
              initialSpringVelocity:0.2
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             _maskView.alpha = 1;
                             _popupView.center = [self finishingPoint];
        } completion:^(BOOL finished) {
            [self animation:finished completion:completion];
        }];
    } else {
        [UIView animateWithDuration:animated ? _animateDuration : 0
                              delay:0.1
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             _maskView.alpha = 1;
                             _popupView.center = [self finishingPoint];
        } completion:^(BOOL finished) {
            [self animation:finished completion:completion];
        }];
    }
}

- (void)animation:(BOOL)finished completion:(void (^)(SnailQuickMaskPopups * _Nonnull))completion {
    if (!finished) return;
    _popupView.userInteractionEnabled = YES;
    _isPresented = YES;
    if (completion) {
        completion(self);
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(snailQuickMaskPopupsDidPresent:)]) {
            [_delegate snailQuickMaskPopupsDidPresent:self];
        }
    }
}

#pragma mark - dismiss

- (void)dismissAnimated:(BOOL)animated
             completion:(void (^)(SnailQuickMaskPopups * _Nonnull))completion {

    if (_delegate && [_delegate respondsToSelector:@selector(snailQuickMaskPopupsWillDismiss:)]) {
        [_delegate snailQuickMaskPopupsWillDismiss:self];
    }
    
    if (_dampingRatio < 1) {
        _animateDuration *= 0.3;
    }
    
    [UIView animateWithDuration:animated ? _animateDuration : 0
                          delay:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _maskView.alpha = 0;
                         _popupView.center = [self dismissedPoint];
    } completion:^(BOOL finished) {
        if (!finished) return;
        _isPresented = NO;
        [_maskView removeFromSuperview];
        if (completion) {
            completion(self);
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(snailQuickMaskPopupsDidDismiss:)]) {
                [_delegate snailQuickMaskPopupsDidDismiss:self];
            }
        }
    }];
}

#pragma mark - maskView style

- (UIView *)maskViewStyle:(MaskStyle)maskStyle {
    switch (maskStyle) {
        case MaskStyleBlackTranslucent:
            return [self backgroundWithColor:[UIColor colorWithWhite:0.0 alpha:_maskAlpha]];
            break;
        case MaskStyleClear:
            return [self backgroundWithColor:[UIColor clearColor]];
            break;
        case MaskStyleWhite:
            return [self backgroundWithColor:[UIColor whiteColor]];
            break;
        case MaskStyleBlackBlur:
            return [self blurTranslucentView:UIBarStyleBlackTranslucent];
            break;
        case MaskStyleWhiteBlur:
            return [self blurTranslucentView:UIBarStyleDefault];
            break;
        default: break;
    }
}

- (UIView *)blurTranslucentView:(UIBarStyle)barStyle {
    UIToolbar *mask = [[UIToolbar alloc] initWithFrame:_superview.bounds];
    [mask setBarStyle:barStyle];
    return mask;
}

- (UIView *)backgroundWithColor:(UIColor *)backgroundColor {
    UIView *mask = [[UIView alloc] initWithFrame:_superview.bounds];
    mask.backgroundColor = backgroundColor;
    return mask;
}

#pragma mark - calculation point

- (CGPoint)startingPoint {
    CGPoint point = _maskView.center;
    switch (_presentationStyle) {
        case PresentationStyleCentered:
            point = [self presentPointForPresentationStyleCentered];
            break;
        case PresentationStyleBottom:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height);
            break;
        case PresentationStyleTop:
            point = CGPointMake(_maskView.center.x, -_popupView.bounds.size.height);
            break;
        case PresentationStyleLeft:
            point = CGPointMake(-_popupView.bounds.size.width, _maskView.center.y);
            break;
        case PresentationStyleRight:
            point = CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

- (CGPoint)finishingPoint {
    CGPoint point = _maskView.center;
    switch (_presentationStyle) {
        case PresentationStyleCentered: {
            switch (_transitionStyle) {
                case TransitionStyleZoom:
                    _maskView.transform = CGAffineTransformIdentity;
                case TransitionStyleFromCenter:
                    _popupView.transform = CGAffineTransformIdentity;
                    break;
                default: break;
            }
        } break;
        case PresentationStyleBottom:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height - _popupView.bounds.size.height * 0.5);
            break;
        case PresentationStyleTop:
            point = CGPointMake(_maskView.center.x, _popupView.bounds.size.height * 0.5);
            break;
        case PresentationStyleLeft:
            point = CGPointMake(_popupView.bounds.size.width * 0.5, _maskView.center.y);
            break;
        case PresentationStyleRight:
            point = CGPointMake(_maskView.bounds.size.width - _popupView.bounds.size.width * 0.5, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

- (CGPoint)dismissedPoint {
    CGPoint point = _maskView.center;
    switch (_presentationStyle) {
        case PresentationStyleCentered:
            point = [self dismissedPointForPresentationStyleCentered];
            break;
        case PresentationStyleBottom:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height);
            break;
        case PresentationStyleTop:
            point = CGPointMake(_maskView.center.x, -_popupView.bounds.size.height);
            break;
        case PresentationStyleLeft:
            point = CGPointMake(-_popupView.bounds.size.width, _maskView.center.y);
            break;
        case PresentationStyleRight:
            point = CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width, _maskView.center.y);
            break;
        default: break;
    }
    return point;
}

- (CGPoint)presentPointForPresentationStyleCentered {
    CGPoint point = _maskView.center;
    switch (_transitionStyle) {
        case TransitionStyleCrossDissolve:
            break;
        case TransitionStyleZoom:
            _maskView.transform = CGAffineTransformMakeScale(1.15, 1.15);
            break;
        case TransitionStyleFromTop:
            point = CGPointMake(_maskView.center.x, -_popupView.bounds.size.height);
            break;
        case TransitionStyleFromBottom:
            point = CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height);
            break;
        case TransitionStyleFromLeft:
            point = CGPointMake(-_popupView.bounds.size.width, _maskView.center.y);
            break;
        case TransitionStyleFromRight:
            point = CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width, _maskView.center.y);
            break;
        case TransitionStyleFromCenter:
            _popupView.transform = CGAffineTransformMakeScale(0.05, 0.05);
        default: break;
    }
    return point;
}

- (CGPoint)dismissedPointForPresentationStyleCentered {
    CGPoint point = _maskView.center;
    switch (_transitionStyle) {
        case TransitionStyleCrossDissolve:
        case TransitionStyleZoom:
            break;
        case TransitionStyleFromTop:
            point = _isDismissedOppositeDirection ? CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height) : CGPointMake(_maskView.center.x, -_popupView.bounds.size.height);
            break;
        case TransitionStyleFromBottom:
            point = _isDismissedOppositeDirection ? CGPointMake(_maskView.center.x, -_popupView.bounds.size.height) : CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height);
            break;
        case TransitionStyleFromLeft:
            point = _isDismissedOppositeDirection ? CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width, _maskView.center.y) : CGPointMake(-_popupView.bounds.size.width, _maskView.center.y);
            break;
        case TransitionStyleFromRight:
            point = _isDismissedOppositeDirection ? CGPointMake(-_popupView.bounds.size.width, _maskView.center.y) : CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width, _maskView.center.y);
            break;
        case TransitionStyleFromCenter:
            _popupView.transform = CGAffineTransformMakeScale(0.05, 0.05);
        default: break;
    }
    return point;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:_popupView];
}

#pragma mark - gesture action

- (void)maskTapped:(UITapGestureRecognizer *)tap {
    if (_isAllowMaskTouch) {
        [self dismissAnimated:_isAnimated completion:NULL];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (!_isAllowPopupsDrag || !_isPresented) return;
    
    CGPoint translation = [g translationInView:_maskView];
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_presentationStyle) {
                case PresentationStyleCentered: {
                    BOOL verticalTransformation = NO;
                    switch (_transitionStyle) {
                        case TransitionStyleFromLeft:
                        case TransitionStyleFromRight: break;
                        default:
                            verticalTransformation = YES;
                            break;
                    }
                    
                    // set screen ratio `_maskView.bounds.size.height / coefficient`
                    NSInteger coefficient = 4;
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
                case PresentationStyleBottom: {
                    if (g.view.frame.origin.y + translation.y > _maskView.bounds.size.height - g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case PresentationStyleTop: {
                    if (g.view.frame.origin.y + g.view.frame.size.height + translation.y  < g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case PresentationStyleLeft: {
                    if (g.view.frame.origin.x + g.view.frame.size.width + translation.x < g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                case PresentationStyleRight: {
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
                case PresentationStyleCentered: {
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
                case PresentationStyleBottom:
                    willDismiss = g.view.frame.origin.y > _maskView.bounds.size.height - g.view.frame.size.height * 0.75;
                    break;
                case PresentationStyleTop:
                    willDismiss = g.view.frame.origin.y + g.view.frame.size.height < g.view.frame.size.height * 0.75;
                    break;
                case PresentationStyleLeft:
                    willDismiss = g.view.frame.origin.x + g.view.frame.size.width < g.view.frame.size.width * 0.75;
                    break;
                case PresentationStyleRight:
                    willDismiss = g.view.frame.origin.x > _maskView.bounds.size.width - g.view.frame.size.width * 0.75;
                    break;
                default: break;
            }
            if (willDismiss) {
                if (styleCentered) {
                    switch (_transitionStyle) {
                        case TransitionStyleCrossDissolve:
                        case TransitionStyleZoom:
                        case TransitionStyleFromCenter: {
                            if (g.view.center.y < _maskView.bounds.size.height * 0.25) {
                                _transitionStyle = TransitionStyleFromTop;
                            } else {
                                if (g.view.center.y > _maskView.bounds.size.height * 0.75) {
                                    _transitionStyle = TransitionStyleFromBottom;
                                }
                            }
                            _isDismissedOppositeDirection = NO;
                        } break;
                        case TransitionStyleFromTop:
                            _isDismissedOppositeDirection = !(g.view.center.y < _maskView.bounds.size.height * 0.25);
                            break;
                        case TransitionStyleFromBottom:
                            _isDismissedOppositeDirection = g.view.center.y < _maskView.bounds.size.height * 0.25;
                            break;
                        case TransitionStyleFromLeft:
                            _isDismissedOppositeDirection = !(g.view.center.x < _maskView.bounds.size.width * 0.25);
                            break;
                        case TransitionStyleFromRight:
                            _isDismissedOppositeDirection = g.view.center.x < _maskView.bounds.size.width * 0.25;
                            break;
                        default: break;
                    }
                }
                [self dismissAnimated:YES completion:NULL];
            } else { // restore view location
                if (_dampingRatio < 1) {
                    [UIView animateWithDuration:_animateDuration delay:0.1 usingSpringWithDamping:_dampingRatio initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        g.view.center = [self finishingPoint];
                    } completion:NULL];
                } else {
                    [UIView animateWithDuration:_animateDuration animations:^{
                        g.view.center = [self finishingPoint];
                    }];
                }
            }
        } break;
        case UIGestureRecognizerStateCancelled:
            break;
        default: break;
    }
}

@end
