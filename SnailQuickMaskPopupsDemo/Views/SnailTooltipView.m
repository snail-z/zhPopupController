//
//  SnailSharedTooltip.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "SnailTooltipView.h"

@implementation TooltipComponents

- (instancetype)init {
    if (self = [super init]) {
        _horizontalLine = [CALayer layer];
        _horizontalLine.backgroundColor = [UIColor r:219 g:219 b:219].CGColor;
        [self.layer addSublayer:_horizontalLine];
        
        _mainButton = [UIButton new];
        _mainButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_mainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_mainButton];
        
        _cancelButton = [UIButton new];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
        _verticalLine = [CALayer layer];
        _verticalLine.backgroundColor = [UIColor r:219 g:219 b:219].CGColor;
        [self.layer addSublayer:_verticalLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _horizontalLine.size    = CGSizeMake(self.width, 1 / UIScreen.scale);
    if (_mainButton.titleLabel.text && _cancelButton.titleLabel.text) {
        _cancelButton.size  = _mainButton.size = CGSizeMake(self.width * 0.5, self.height);
        _cancelButton.x     = _mainButton.right;
        _verticalLine.size  = CGSizeMake(1 / UIScreen.scale, self.height);
        _verticalLine.centerX = self.width * 0.5;
    } else if (_mainButton.titleLabel.text) {
        _mainButton.size    = self.size;
    } else {
        _cancelButton.size  = self.size;
    }
}

@end

@implementation SnailTooltipView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3;
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _detailTextLabel = [UILabel new];
        _detailTextLabel.numberOfLines = 0;
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.font = [UIFont systemFontOfSize:16];
        _detailTextLabel.textColor = [UIColor grayColor];
        
        _components = [TooltipComponents new];
        
        [self addSubview:_titleLabel];
        [self addSubview:_detailTextLabel];
        [self addSubview:_components];
    }
    return self;
}

- (void)reloadLayout {
    CGSize titleMaximumSize = CGSizeMake(self.width - 40, 100);
    _titleLabel.size = [_titleLabel sizeThatFits:titleMaximumSize];
    _titleLabel.y = 15;
    _titleLabel.centerX = self.width * 0.5;
    
    _detailTextLabel.y = _titleLabel.bottom + 15;
    CGSize detailMaximumSize = CGSizeMake(self.width - 20, 200);
    _detailTextLabel.size = [_detailTextLabel sizeThatFits:detailMaximumSize];
    _detailTextLabel.centerX = self.width * 0.5;
    
    _components.size = CGSizeMake(self.width, 49);
    _components.y = _detailTextLabel.bottom + 20;
    self.height = _components.bottom;
}

@end
