//
//  zh_UpdateView.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/7.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhOverflyView.h"
#import  <objc/runtime.h>

#define zhOverflyViewLineColor [UIColor colorWithHexString:@"bfbfbf"]

@interface zhOverflyButton ()

@property (nonatomic, strong) CALayer *horizontalLine;
@property (nonatomic, strong) CALayer *verticalLine;
@property (nonatomic, copy) void (^buttonClickedBlock)(zhOverflyButton *alertButton);

@end

@implementation zhOverflyButton

+ (instancetype)buttonWithTitle:(NSString *)title handler:(void (^)(zhOverflyButton * _Nonnull))handler {
    return [[self alloc] initWithTitle:title handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(zhOverflyButton * _Nonnull))handler {
    if (self = [super init]) {
        self.buttonClickedBlock = handler;
        
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:self action:@selector(handlerClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _horizontalLine = [CALayer layer];
        _horizontalLine.backgroundColor = zhOverflyViewLineColor.CGColor;
        [self.layer addSublayer:_horizontalLine];
        
        _verticalLine = [CALayer layer];
        _verticalLine.backgroundColor = zhOverflyViewLineColor.CGColor;
        _verticalLine.hidden = YES;
        [self.layer addSublayer:_verticalLine];
    }
    return self;
}

- (void)handlerClicked {
    if (self && self.buttonClickedBlock) self.buttonClickedBlock(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat lineWidth = self.lineWidth > 0 ? self.lineWidth : 1 / [UIScreen mainScreen].scale;
    _horizontalLine.frame = CGRectMake(0, 0, self.width, lineWidth);
    _verticalLine.frame = CGRectMake(0, 0, lineWidth, self.height);
}

- (void)setLineColor:(UIColor *)lineColor {
    _verticalLine.backgroundColor = lineColor.CGColor;
    _horizontalLine.backgroundColor = lineColor.CGColor;
}

@end

@interface zhOverflyView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *adjoinActions;
@property (nonatomic, assign) CGSize overflyViewSize;

@end

@implementation zhOverflyView

- (instancetype)init {
    return [self initWithFlyImage:nil highlyRatio:0 attributedTitle:nil attributedMessage:nil constantWidth:0];
}

- (instancetype)initWithFlyImage:(UIImage *)flyImage
                     highlyRatio:(CGFloat)highlyRatio
                           title:(NSString *)title
                         message:(NSString *)message
                   constantWidth:(CGFloat)constantWidth {
    return [self initWithFlyImage:flyImage
                      highlyRatio:highlyRatio
                  attributedTitle:[[NSMutableAttributedString alloc] initWithString:title]
                attributedMessage:[[NSMutableAttributedString alloc] initWithString:message]
                    constantWidth:constantWidth];
}

- (instancetype)initWithFlyImage:(UIImage *)flyImage
                     highlyRatio:(CGFloat)highlyRatio
                 attributedTitle:(NSAttributedString *)attributedTitle
               attributedMessage:(NSAttributedString *)attributedMessage
                   constantWidth:(CGFloat)constantWidth {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.width = constantWidth;
        self.highlyRatio = highlyRatio;
        self.messageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        self.subOverflyButtonHeight = 49;
        self.visualScrollableHight = 200;
        
        _flyImageView = [UIImageView new];
        [self addSubview:_flyImageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _messageLabel = [UILabel new];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:_messageLabel];
        
        _splitLine = [CALayer layer];
        _splitLine.backgroundColor = zhOverflyViewLineColor.CGColor;
        [self.layer addSublayer:_splitLine];
        
        _flyImageView.image = flyImage;
        _titleLabel.attributedText = attributedTitle;
        _messageLabel.attributedText = attributedMessage;
        
        [self reloadAllComponents];
    }
    return self;
}

- (void)reloadAllComponents {
    CGFloat constantWidth = self.frame.size.width;
    
    UIImage *flyImage = self.flyImageView.image;
    if (flyImage) {
        double factor = flyImage.size.height / flyImage.size.width; // 高宽比因数
        CGFloat imgWidth = constantWidth;
        CGFloat imgHeight = imgWidth * factor;
        _flyImageView.size = CGSizeMake(constantWidth, constantWidth * factor);
        _flyImageView.y = -(imgHeight * self.highlyRatio);
    }
    
    _titleLabel.bottom = _flyImageView.bottom;
    if (_titleLabel.attributedText.length) {
        _titleLabel.size = [_titleLabel sizeThatFits:CGSizeMake(constantWidth, MAXFLOAT)];
        _titleLabel.width = constantWidth;
        _titleLabel.y = _flyImageView.bottom + 5; // 间距扩大5
        _titleLabel.textAlignment = self.titleLabel.textAlignment;
    }
    
    _scrollView.bottom = _titleLabel.bottom;
    if (_messageLabel.attributedText.length) {
        _messageLabel.size = [_messageLabel sizeThatFits:CGSizeMake(constantWidth, MAXFLOAT)];
        _messageLabel.width = constantWidth;
        _messageLabel.textAlignment = self.messageLabel.textAlignment;
        
        UIEdgeInsets insets = self.messageEdgeInsets;
        CGFloat paddingh = insets.left+ insets.right;
        CGFloat paddingv = insets.top + insets.bottom;
        _messageLabel.width -= paddingh;
        _messageLabel.height += paddingh;
        _messageLabel.x = insets.left;
        _messageLabel.height += paddingv;
        _messageLabel.y = 0;
        
        _scrollView.y = _titleLabel.bottom + 10; // 间距扩大10
        _scrollView.contentSize = CGSizeMake(constantWidth, _messageLabel.size.height); // 滚动范围
        
        if ((self.visualScrollableHight > 0) && (_messageLabel.height > self.visualScrollableHight)) {
            _scrollView.size = CGSizeMake(constantWidth, self.visualScrollableHight);
        } else {
            _scrollView.size = CGSizeMake(constantWidth, _messageLabel.height);
        }
        self.splitLine.frame = CGRectMake(0, _scrollView.y, constantWidth, 1 / [UIScreen mainScreen].scale);
    }
    self.size = CGSizeMake(constantWidth, _scrollView.bottom);
    self.overflyViewSize = self.size;
}

static void *zhOverflyViewActionKey = &zhOverflyViewActionKey;

- (void)addAction:(zhOverflyButton *)action {
    [self clearActions:self.adjoinActions.allObjects];
    [self.adjoinActions removeAllObjects];

    void (^layout)(CGFloat) = ^(CGFloat top){
        CGFloat width = self.overflyViewSize.width - action.flyEdgeInsets.left - action.flyEdgeInsets.right;
        action.size = CGSizeMake(width, self.subOverflyButtonHeight);
        action.y = top;
        action.centerX = self.overflyViewSize.width / 2;
    };
    
    zhOverflyButton *lastAction = objc_getAssociatedObject(self, zhOverflyViewActionKey);
    if (lastAction) { // current
        if (![action isEqual:lastAction]) layout(lastAction.bottom + action.flyEdgeInsets.top);
    } else { // first
        layout(self.overflyViewSize.height + action.flyEdgeInsets.top);
    }
    
    action.verticalLine.hidden = YES;
    [self insertSubview:action atIndex:0];
    self.size = CGSizeMake(self.overflyViewSize.width, action.bottom + action.flyEdgeInsets.bottom);
    objc_setAssociatedObject(self, zhOverflyViewActionKey, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)adjoinWithLeftAction:(zhOverflyButton *)leftAction rightAction:(zhOverflyButton *)rightAction {
    [self clearActions:self.subviews];
    objc_setAssociatedObject(self, zhOverflyViewActionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    leftAction.size = CGSizeMake(self.overflyViewSize.width / 2, self.subOverflyButtonHeight);
    leftAction.y = self.overflyViewSize.height;
    
    rightAction.frame = leftAction.frame;
    rightAction.x = leftAction.right;
    rightAction.verticalLine.hidden = NO;
    [self addSubview:leftAction];
    [self addSubview:rightAction];
    self.adjoinActions = [NSMutableSet setWithObjects:leftAction, rightAction, nil];
    self.size = CGSizeMake(self.overflyViewSize.width, leftAction.bottom);
}

- (void)clearActions:(NSArray<UIView *> *)subviews {
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[zhOverflyButton class]]) {
            [subview removeFromSuperview];
        }
    }
}

@end
