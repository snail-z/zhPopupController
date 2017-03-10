//
//  SnailImageLabel.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "SnailImageLabel.h"

@implementation SnailImageLabelItem

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image
{
    SnailImageLabelItem *item = [SnailImageLabelItem new];
    item.title = title;
    item.image = image;
    return item;
}

@end

@implementation SnailImageLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _imgView = [UIButton new];
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.userInteractionEnabled = NO;
        
        [self addSubview:_imgView];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_padding) _padding = 15;   // 两边留白默认15
    CGFloat topPadding = 10;        // 顶部留白
    CGFloat spacing = 10;           // 间距
    CGFloat imgW = self.width - _padding;
    CGFloat imgX = _padding * 0.5;
    _imgView.frame = CGRectMake(imgX, topPadding, imgW, imgW);
    
    CGSize titleMaximumSize = CGSizeMake(self.width, 30);
    _textLabel.size = [_textLabel sizeThatFits:titleMaximumSize];
    _textLabel.y = _imgView.bottom + spacing;
    _textLabel.centerX = self.width * 0.5;
}

- (void)setItem:(SnailImageLabelItem *)item
{
    _textLabel.text = item.title;
    [_imgView setImage:item.image forState:UIControlStateNormal];
}

@end
