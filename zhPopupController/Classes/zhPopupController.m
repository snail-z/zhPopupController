//
//  zhPopupController.m
//  <https://github.com/snail-z/zhPopupController.git>
//
//  Created by zhanghao on 2016/11/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhPopupController.h"
#import <objc/runtime.h>

@interface zhPopupController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat dropAngle;

@end

static void *zhPopupControllerParametersKey = &zhPopupControllerParametersKey;

@implementation zhPopupController

- (instancetype)init {
    if (self = [super init]) {
        _isPresenting = NO;
        _layoutType = zhPopupLayoutTypeCenter;
        _maskAlpha = 0.5f;
        _dismissOnMaskTouched = YES;
        _allowPan = NO;
        self.slideStyle = zhPopupSlideStyleFade;
        self.dismissOppositeDirection = NO;
    
        _superview = [self applicationWindow];
        _popupView = [[UIView alloc] init];
        _popupView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_popupView addGestureRecognizer:pan];
        self.maskType = zhPopupMaskTypeBlackTranslucent;
        
        // Observer statusBar orientation changes.
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willChangeStatusBarOrientation)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeStatusBarOrientation)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (UIView *)applicationWindow {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    if (windows.count) {
        return windows.firstObject;
    }
    return [[UIApplication sharedApplication].delegate window];
}

- (void)setDismissOppositeDirection:(BOOL)dismissOppositeDirection {
    _dismissOppositeDirection = dismissOppositeDirection;
    objc_setAssociatedObject(self, _cmd, @(dismissOppositeDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSlideStyle:(zhPopupSlideStyle)slideStyle {
    _slideStyle = slideStyle;
    objc_setAssociatedObject(self, _cmd, @(slideStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMaskAlpha:(CGFloat)maskAlpha {
    _maskAlpha = maskAlpha;
    _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
}

- (void)setMaskType:(zhPopupMaskType)maskType {
    if (_maskType == maskType) return;
    _maskType = maskType;
    
    _maskView = [self maskViewInitialize:maskType];
    switch (maskType) {
        case zhPopupMaskTypeBlackTranslucent:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
            break;
        case zhPopupMaskTypeWhite:
            _maskView.backgroundColor = [UIColor whiteColor];
            break;
        case zhPopupMaskTypeClear:
            _maskView.backgroundColor = [UIColor clearColor];
            break;
        case zhPopupMaskTypeBlackBlur:
            [(UIToolbar *)_maskView setBarStyle:UIBarStyleBlack];
            break;
        case zhPopupMaskTypeWhiteBlur:
            [(UIToolbar *)_maskView setBarStyle:UIBarStyleDefault];
            break;
        default: break;
    }
}

- (UIView *)maskViewInitialize:(zhPopupMaskType)maskType {
    switch (maskType) {
        case zhPopupMaskTypeBlackBlur:
        case zhPopupMaskTypeWhiteBlur: {
            if (!_maskView || ![_maskView isKindOfClass:[UIToolbar class]]) {
                _maskView = [[UIToolbar alloc] initWithFrame:_superview.bounds];
                [_maskView addGestureRecognizer:[self tapRecognizer]];
            }
        } break;
        default: {
            if (!_maskView || ![_maskView isKindOfClass:[UIView class]]) {
                _maskView = [[UIView alloc] initWithFrame:_superview.bounds];
                [_maskView addGestureRecognizer:[self tapRecognizer]];
            }
        } break;
    }
    return _maskView;
}

- (UITapGestureRecognizer *)tapRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    return tap;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    
    if (!_contentView) {
        if (nil != _popupView.superview) [_popupView removeFromSuperview];
        return;
    }
    
    if (_contentView.superview != _popupView) {
        _contentView.frame = (CGRect){.origin = CGPointZero, .size = contentView.frame.size};
        _popupView.frame = _contentView.frame;
        _popupView.backgroundColor = _contentView.backgroundColor;
        if (_contentView.layer.cornerRadius) {
            _popupView.layer.cornerRadius = _contentView.layer.cornerRadius;
            _popupView.clipsToBounds = NO;
        }
        [_popupView addSubview:_contentView];
        [_maskView addSubview:_popupView];
    }
}

- (void)removeChildViews {
    if (_popupView.subviews.count > 0) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    [_maskView removeFromSuperview];
}

#pragma mark - Present

- (void)presentContentView:(UIView *)contentView {
    [self presentContentView:contentView duration:0.25 springAnimated:NO];
}

- (void)presentContentView:(UIView *)contentView duration:(NSTimeInterval)duration springAnimated:(BOOL)isSpringAnimated {
    [self presentContentView:contentView duration:duration springAnimated:isSpringAnimated inView:nil];
}

- (void)presentContentView:(UIView *)contentView
                  duration:(NSTimeInterval)duration
            springAnimated:(BOOL)isSpringAnimated
                    inView:(UIView *)sView {
    
    if (self.isPresenting) return;
    
    if (nil != self.willPresent) {
        self.willPresent(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerWillPresent:)]) {
            [self.delegate popupControllerWillPresent:self];
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:@(duration) forKey:@"zh_duration"];
    [parameters setValue:@(isSpringAnimated) forKey:@"zh_springAnimated"];
    objc_setAssociatedObject(self, zhPopupControllerParametersKey, parameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (nil != sView) {
        _superview = sView;
        _maskView.frame = _superview.frame;
    }
    
    [self setContentView:contentView];
    [_superview addSubview:_maskView];
    
    [self prepareDropAnimated];
    [self prepareBackground];
    _popupView.userInteractionEnabled = NO;
    _popupView.center = [self prepareCenter];
    
    if (isSpringAnimated) {
        [UIView animateWithDuration:duration delay:0.f usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self finishedDropAnimated];
            [self finishedBackground];
            _popupView.center = [self finishedCenter];
            
        } completion:^(BOOL finished) {
            [self presentCompletion:finished];
        }];
    } else {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self finishedDropAnimated];
            [self finishedBackground];
            _popupView.center = [self finishedCenter];
            
        } completion:^(BOOL finished) {
            [self presentCompletion:finished];
        }];
    }
}

- (void)presentCompletion:(BOOL)finished {
    if (!finished) return;
    _isPresenting = YES;
    _popupView.userInteractionEnabled = YES;
    if (self.didPresent) {
        self.didPresent(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerDidPresent:)]) {
            [self.delegate popupControllerDidPresent:self];
        }
    }
}

#pragma mark - Dismiss

- (void)dismiss {
    id object = objc_getAssociatedObject(self, zhPopupControllerParametersKey);
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSTimeInterval duration = 0.0;
        NSNumber *durationNumber = [object valueForKey:@"zh_duration"];
        if (nil != durationNumber) {
            duration = durationNumber.doubleValue;
        }
        BOOL flag = NO;
        NSNumber *flagNumber = [object valueForKey:@"zh_springAnimated"];
        if (nil != flagNumber) {
            flag = flagNumber.boolValue;
        }
        [self dismissWithDuration:duration springAnimated:flag];
    }
}

- (void)dismissWithDuration:(NSTimeInterval)duration springAnimated:(BOOL)isSpringAnimated {
    if (!self.isPresenting) return;
    
    if (nil != self.willDismiss) {
        self.willDismiss(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerWillDismiss:)]) {
            [self.delegate popupControllerWillDismiss:self];
        }
    }
    
    if (isSpringAnimated) {
        NSTimeInterval duration1 = duration * 0.25, duration2 = duration - duration1;
        
        [UIView animateWithDuration:duration1 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self bufferBackground];
            _popupView.center = [self bufferCenter:30];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:duration2 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [self dismissedDropAnimated];
                [self prepareBackground];
                _popupView.center = [self dismissedCenter];
                
            } completion:^(BOOL finished) {
                [self dismissCompletion:finished];
            }];
            
        }];
        
    } else {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self dismissedDropAnimated];
            [self prepareBackground];
            _popupView.center = [self dismissedCenter];

        } completion:^(BOOL finished) {
            [self dismissCompletion:finished];
        }];
    }
}

- (void)dismissCompletion:(BOOL)finished {
    if (!finished) return;
    [self removeChildViews];
    _isPresenting = NO;
    _popupView.transform = CGAffineTransformIdentity;
    if (nil != self.didDismiss) {
        self.didDismiss(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerDidDismiss:)]) {
            [self.delegate popupControllerDidDismiss:self];
        }
    }
}

#pragma mark - Drop animated

- (void)dropAnimatedWithRotateAngle:(CGFloat)angle {
    _dropAngle = angle;
    _slideStyle = zhPopupSlideStyleFromTop;
}

- (BOOL)dropSupport {
    return (_layoutType == zhPopupLayoutTypeCenter &&
            _slideStyle == zhPopupSlideStyleFromTop);
}

static CGFloat zh_randomValue(int i, int j) {
    if (arc4random() % 2) return i;
    return j;
}

- (void)prepareDropAnimated {
    if (_dropAngle && [self dropSupport]) {
        _dismissOppositeDirection = YES;
        CGFloat ty = (_maskView.bounds.size.height + _popupView.frame.size.height) / 2;
        CATransform3D transform = CATransform3DMakeTranslation(0, -ty, 0);
        transform = CATransform3DRotate(transform,
                                        zh_randomValue(_dropAngle, -_dropAngle) * M_PI / 180,
                                        0, 0, 1.0);
        _popupView.layer.transform = transform;
    }
}

- (void)finishedDropAnimated {
    if (_dropAngle && [self dropSupport]) {
        _popupView.layer.transform = CATransform3DIdentity;
    }
}

- (void)dismissedDropAnimated {
    if (_dropAngle && [self dropSupport]) {
        CGFloat ty = _maskView.bounds.size.height;
        CATransform3D transform = CATransform3DMakeTranslation(0, ty, 0);
        transform = CATransform3DRotate(transform,
                                        zh_randomValue(_dropAngle, -_dropAngle) * M_PI / 180,
                                        0, 0, 1.0);
        _popupView.layer.transform = transform;
    }
}

#pragma mark - Mask view background

- (void)prepareBackground {
    switch (_maskType) {
        case zhPopupMaskTypeBlackBlur:
        case zhPopupMaskTypeWhiteBlur:
            _maskView.alpha = 0;
            break;
        default:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
            break;
    }
}

- (void)bufferBackground {
    switch (_maskType) {
        case zhPopupMaskTypeBlackBlur:
        case zhPopupMaskTypeWhiteBlur:
            _maskView.alpha = 0.95;
            break;
        case zhPopupMaskTypeBlackTranslucent:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha - _maskAlpha * 0.15];
            break;
        default: break;
    }
}

- (void)finishedBackground {
    _maskView.alpha = 1;
    switch (_maskType) {
        case zhPopupMaskTypeBlackBlur:
        case zhPopupMaskTypeWhiteBlur:
            break;
        case zhPopupMaskTypeBlackTranslucent:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
            break;
        case zhPopupMaskTypeWhite:
            _maskView.backgroundColor = [UIColor whiteColor];
            break;
        case zhPopupMaskTypeClear:
            _maskView.backgroundColor = [UIColor clearColor];
            break;
        default: break;
    }
}

#pragma mark - Center point

- (CGPoint)prepareCenterFrom:(NSInteger)type {
    switch (type) {
        case 0: // top
            return CGPointMake(_maskView.center.x,
                               -_popupView.bounds.size.height / 2) ;
        case 1: // bottom
            return CGPointMake(_maskView.center.x,
                               _maskView.bounds.size.height + _popupView.bounds.size.height / 2);
        case 2: // left
            return CGPointMake(-_popupView.bounds.size.width / 2,
                               _maskView.center.y);
        case 3: // right
            return CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width / 2,
                               _maskView.center.y);
        default: // center
            return _maskView.center;
    }
}

- (CGPoint)prepareCenter {
    if (_layoutType == zhPopupLayoutTypeCenter) {
        CGPoint point = _maskView.center;
        if (_slideStyle == zhPopupSlideStyleShrinkInOut) {
            _popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } else if (_slideStyle == zhPopupSlideStyleFade) {
            _maskView.alpha = 0;
        } else {
            point = [self prepareCenterFrom:_slideStyle];
        }
        return point;
    }
    return [self prepareCenterFrom:_layoutType];
}

- (CGPoint)finishedCenter {
    CGPoint point = _maskView.center;
    switch (_layoutType) {
        case zhPopupLayoutTypeTop:
            return CGPointMake(point.x,
                               _popupView.bounds.size.height / 2);
        case zhPopupLayoutTypeBottom:
            return CGPointMake(point.x,
                               _maskView.bounds.size.height - _popupView.bounds.size.height / 2);
        case zhPopupLayoutTypeLeft:
            return CGPointMake(_popupView.bounds.size.width / 2,
                               point.y);
        case zhPopupLayoutTypeRight:
            return CGPointMake(_maskView.bounds.size.width - _popupView.bounds.size.width / 2,
                               point.y);
        default: // zhPopupLayoutTypeCenter
        {
            if (_slideStyle == zhPopupSlideStyleShrinkInOut) {
                _popupView.transform = CGAffineTransformIdentity;
            } else if (_slideStyle == zhPopupSlideStyleFade) {
                _maskView.alpha = 1;
            }
        }
        return point;
    }
}

- (CGPoint)dismissedCenter {
    if (_layoutType != zhPopupLayoutTypeCenter) {
        return [self prepareCenterFrom:_layoutType];
    }
    switch (_slideStyle) {
        case zhPopupSlideStyleFromTop:
            return _dismissOppositeDirection ?
            CGPointMake(_maskView.center.x,
                        _maskView.bounds.size.height + _popupView.bounds.size.height / 2) :
            CGPointMake(_maskView.center.x,
                        -_popupView.bounds.size.height / 2);
            
        case zhPopupSlideStyleFromBottom:
            return _dismissOppositeDirection ?
            CGPointMake(_maskView.center.x,
                        -_popupView.bounds.size.height / 2) :
            CGPointMake(_maskView.center.x,
                        _maskView.bounds.size.height + _popupView.bounds.size.height / 2);
            
        case zhPopupSlideStyleFromLeft:
            return _dismissOppositeDirection ?
            CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width / 2,
                        _maskView.center.y) :
            CGPointMake(-_popupView.bounds.size.width / 2,
                        _maskView.center.y);
            
        case zhPopupSlideStyleFromRight:
            return _dismissOppositeDirection ?
            CGPointMake(-_popupView.bounds.size.width / 2,
                        _maskView.center.y) :
            CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width / 2,
                        _maskView.center.y);
            
        case zhPopupSlideStyleShrinkInOut:
            _popupView.transform = _dismissOppositeDirection ?
            CGAffineTransformMakeScale(1.95, 1.95) :
            CGAffineTransformMakeScale(0.05, 0.05);
            break;
            
        case zhPopupSlideStyleFade:
            _maskView.alpha = 0;
        default: break;
    }
    return _maskView.center;
}

#pragma mark - Buffer point

- (CGPoint)bufferCenter:(CGFloat)move {
    CGPoint point = _popupView.center;
    switch (_layoutType) {
        case zhPopupLayoutTypeTop:
            point.y += move;
            break;
        case zhPopupLayoutTypeBottom:
            point.y -= move;
            break;
        case zhPopupLayoutTypeLeft:
            point.x += move;
            break;
        case zhPopupLayoutTypeRight:
            point.x -= move;
            break;
        case zhPopupLayoutTypeCenter: {
            switch (_slideStyle) {
                case zhPopupSlideStyleFromTop:
                    point.y += _dismissOppositeDirection ? -move : move;
                    break;
                case zhPopupSlideStyleFromBottom:
                    point.y += _dismissOppositeDirection ? move : -move;
                    break;
                case zhPopupSlideStyleFromLeft:
                    point.x += _dismissOppositeDirection ? -move : move;
                    break;
                case zhPopupSlideStyleFromRight:
                    point.x += _dismissOppositeDirection ? move : -move;
                    break;
                case zhPopupSlideStyleShrinkInOut:
                    _popupView.transform = _dismissOppositeDirection ?
                    CGAffineTransformMakeScale(0.95, 0.95) :
                    CGAffineTransformMakeScale(1.05, 1.05);
                    break;
                default: break;
            }
        } break;
        default: break;
    }
    return point;
}

#pragma mark - Observing

- (void)willChangeStatusBarOrientation {
    _maskView.frame = _superview.bounds;
    _popupView.center = [self finishedCenter];
    [self dismiss];
}

- (void)didChangeStatusBarOrientation {
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) { // must manually fix orientation prior to iOS 8
        CGFloat angle;
        switch ([UIApplication sharedApplication].statusBarOrientation)
        {
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = M_PI;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = -M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI_2;
                break;
            default: // as UIInterfaceOrientationPortrait
                angle = 0.0;
                break;
        }
        _popupView.transform = CGAffineTransformMakeRotation(angle);
    }
    _maskView.frame = _superview.bounds;
    _popupView.center = [self finishedCenter];
}

#pragma mark - Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_popupView]) return NO;
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)g {
    if (_dismissOnMaskTouched) {
        if (!_dropAngle) {
            id object = objc_getAssociatedObject(self, @selector(setSlideStyle:));
            _slideStyle = [object integerValue];
            id obj = objc_getAssociatedObject(self, @selector(setDismissOppositeDirection:));
            _dismissOppositeDirection = [obj boolValue];
        }
        if (nil != self.maskTouched) {
            self.maskTouched(self);
        } else {
            [self dismiss];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (!_allowPan || !_isPresenting || _dropAngle) {
        return;
    }
    CGPoint translation = [g translationInView:_maskView];
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_layoutType) {
                case zhPopupLayoutTypeCenter: {
                    
                    BOOL isTransformationVertical = NO;
                    switch (_slideStyle) {
                        case zhPopupSlideStyleFromLeft:
                        case zhPopupSlideStyleFromRight: break;
                        default:
                            isTransformationVertical = YES;
                            break;
                    }
                    
                    NSInteger factor = 4; // set screen ratio `_maskView.bounds.size.height / factor`
                    CGFloat changeValue;
                    if (isTransformationVertical) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                        changeValue = g.view.center.y / (_maskView.bounds.size.height / factor);
                    } else {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                        changeValue = g.view.center.x / (_maskView.bounds.size.width / factor);
                    }
                    CGFloat alpha = factor / 2 - fabs(changeValue - factor / 2);
                    [UIView animateWithDuration:0.15 animations:^{
                        _maskView.alpha = alpha;
                    } completion:NULL];
                    
                } break;
                case zhPopupLayoutTypeBottom: {
                    if (g.view.frame.origin.y + translation.y > _maskView.bounds.size.height - g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case zhPopupLayoutTypeTop: {
                    if (g.view.frame.origin.y + g.view.frame.size.height + translation.y  < g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case zhPopupLayoutTypeLeft: {
                    if (g.view.frame.origin.x + g.view.frame.size.width + translation.x < g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                case zhPopupLayoutTypeRight: {
                    if (g.view.frame.origin.x + translation.x > _maskView.bounds.size.width - g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                default: break;
            }
            [g setTranslation:CGPointZero inView:_maskView];
        } break;
        case UIGestureRecognizerStateEnded: {
            
            BOOL isWillDismiss = YES, isStyleCentered = NO;
            switch (_layoutType) {
                case zhPopupLayoutTypeCenter: {
                    isStyleCentered = YES;
                    if (g.view.center.y != _maskView.center.y) {
                        if (g.view.center.y > _maskView.bounds.size.height * 0.25 &&
                            g.view.center.y < _maskView.bounds.size.height * 0.75) {
                            isWillDismiss = NO;
                        }
                    } else {
                        if (g.view.center.x > _maskView.bounds.size.width * 0.25 &&
                            g.view.center.x < _maskView.bounds.size.width * 0.75) {
                            isWillDismiss = NO;
                        }
                    }
                } break;
                case zhPopupLayoutTypeBottom:
                    isWillDismiss = g.view.frame.origin.y > _maskView.bounds.size.height - g.view.frame.size.height * 0.75;
                    break;
                case zhPopupLayoutTypeTop:
                    isWillDismiss = g.view.frame.origin.y + g.view.frame.size.height < g.view.frame.size.height * 0.75;
                    break;
                case zhPopupLayoutTypeLeft:
                    isWillDismiss = g.view.frame.origin.x + g.view.frame.size.width < g.view.frame.size.width * 0.75;
                    break;
                case zhPopupLayoutTypeRight:
                    isWillDismiss = g.view.frame.origin.x > _maskView.bounds.size.width - g.view.frame.size.width * 0.75;
                    break;
                default: break;
            }
            if (isWillDismiss) {
                if (isStyleCentered) {
                    switch (_slideStyle) {
                        case zhPopupSlideStyleShrinkInOut:
                        case zhPopupSlideStyleFade: {
                            if (g.view.center.y < _maskView.bounds.size.height * 0.25) {
                                _slideStyle = zhPopupSlideStyleFromTop;
                            } else {
                                if (g.view.center.y > _maskView.bounds.size.height * 0.75) {
                                    _slideStyle = zhPopupSlideStyleFromBottom;
                                }
                            }
                            _dismissOppositeDirection = NO;
                        } break;
                        case zhPopupSlideStyleFromTop:
                            _dismissOppositeDirection = !(g.view.center.y < _maskView.bounds.size.height * 0.25);
                            break;
                        case zhPopupSlideStyleFromBottom:
                            _dismissOppositeDirection = g.view.center.y < _maskView.bounds.size.height * 0.25;
                            break;
                        case zhPopupSlideStyleFromLeft:
                            _dismissOppositeDirection = !(g.view.center.x < _maskView.bounds.size.width * 0.25);
                            break;
                        case zhPopupSlideStyleFromRight:
                            _dismissOppositeDirection = g.view.center.x < _maskView.bounds.size.width * 0.25;
                            break;
                        default: break;
                    }
                }
                
                [self dismissWithDuration:0.2f springAnimated:NO];
                
            } else {
                // restore view location.
                id object = objc_getAssociatedObject(self, zhPopupControllerParametersKey);
                NSNumber *flagNumber = [object valueForKey:@"zh_springAnimated"];
                BOOL flag = NO;
                if (nil != flagNumber) {
                    flag = flagNumber.boolValue;
                }
                NSTimeInterval duration = 0.25;
                NSNumber* durationNumber = [object valueForKey:@"zh_duration"];
                if (nil != durationNumber) {
                    duration = durationNumber.doubleValue;
                }
                if (flag) {
                    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        g.view.center = [self finishedCenter];
                    } completion:NULL];
                } else {
                    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        g.view.center = [self finishedCenter];
                    } completion:NULL];
                }
            }
            
        } break;
        case UIGestureRecognizerStateCancelled:
            break;
        default: break;
    }
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%@ dealloc.", NSStringFromClass(self.class));
#endif
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIApplicationWillChangeStatusBarOrientationNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIApplicationDidChangeStatusBarOrientationNotification
                                                 object:nil];
    [self removeChildViews];
}

@end

@implementation NSObject (zhPopupController)

- (zhPopupController *)zh_popupController {
    id popupController = objc_getAssociatedObject(self, _cmd);
    if (nil == popupController) {
        popupController = [[zhPopupController alloc] init];
        self.zh_popupController = popupController;
    }
    return popupController;
}

- (void)setZh_popupController:(zhPopupController *)zh_popupController {
    objc_setAssociatedObject(self, @selector(zh_popupController), zh_popupController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
