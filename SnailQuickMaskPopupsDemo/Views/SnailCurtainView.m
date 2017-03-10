//
//  SnailCurtainView.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2017/2/4.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "SnailCurtainView.h"

@implementation SnailCurtainView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _close = [UIButton buttonWithType:UIButtonTypeCustom];
        _close.size = CGSizeMake(35, 35);
        _close.right = [UIScreen width] - 15;
        _close.y = 30;
        [_close setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
}

- (void)setItems:(NSArray<SnailImageLabelItem *> *)items {
    if (_itemSize.width == 0 && _itemSize.height == 0) { // 设置item的默认宽高
        _itemSize.width = 60;
        _itemSize.height = 90;
    }
    CGFloat _gap = 15;
    CGFloat _space = (self.width - _rowCount * _itemSize.width) / (_rowCount + 1);
    
    NSMutableArray *itemViews = [NSMutableArray new];
    [items enumerateObjectsUsingBlock:^(SnailImageLabelItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger l = idx % _rowCount;
        NSInteger v = idx / _rowCount;
        
        SnailImageLabel *item = [SnailImageLabel new];
        item.size = CGSizeMake(_itemSize.width , _itemSize.height);
        item.x = _space + (_itemSize.width  + _space) * l;
        item.y = _gap + (_itemSize.height + _gap) * v + 45;
        [self addSubview:item];
        [item setItem:obj];
        if (idx == items.count - 1) {
            self.height = item.bottom + 20;
        }
        item.imgView.tag = idx;
        [item.imgView addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [itemViews addObject:item];
    }];
    _itemViews = itemViews;
}

- (void)imageClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(curtainView:didClickItemAtIndex:)]) {
        [_delegate curtainView:self didClickItemAtIndex:sender.tag];
    }
}

- (void)close:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(curtainViewDidClickClose:)]) {
        [_delegate curtainViewDidClickClose:sender];
    }
}

@end
