//
//  SnailCurtainView.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "SnailCurtainView.h"

#define ROW_COUNT 3 // 每行显示3个

@implementation SnailCurtainView

- (instancetype)init {
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.size = CGSizeMake(35, 35);
        _closeButton.right = [UIScreen width] - 15;
        _closeButton.y = 30;
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return self;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
}

- (void)setModels:(NSArray<SnailIconLabelModel *> *)models {
    if (0 == _itemSize.width && 0 == _itemSize.height) { // 设置item的默认宽高
        _itemSize.width = 60;
        _itemSize.height = 90;
    }
    CGFloat _gap = 35;
    CGFloat _space = (self.width - ROW_COUNT * _itemSize.width) / (ROW_COUNT + 1);
    
    _items = [NSMutableArray arrayWithCapacity:models.count];
    [models enumerateObjectsUsingBlock:^(SnailIconLabelModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger l = idx % ROW_COUNT;
        NSInteger v = idx / ROW_COUNT;
        
        SnailIconLabel *item = [SnailIconLabel new];
        item.size = CGSizeMake(_itemSize.width , _itemSize.height + 20);
        item.x = _space + (_itemSize.width  + _space) * l;
        item.y = _gap + (_itemSize.height + _gap) * v + 45;
        [self addSubview:item];
        item.model = model;
        item.iconView.tag = idx;
        [item.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconWhenTapped:)]];
        [_items addObject:item];
        
        if (idx == models.count - 1) {
            self.height = item.bottom + 20;
        }
    }];
}

- (void)close:(UIButton *)sender {
    if (nil != self.closeClicked) {
        self.closeClicked(sender);
    }
}

- (void)iconWhenTapped:(UITapGestureRecognizer *)g {
    if (nil != self.didClickItems) {
        self.didClickItems(self, g.view.tag);
    }
}

@end
