//
//  zhCurtainView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhCurtainView.h"

#define ROW_COUNT 4 // 每行显示3个

@implementation zhCurtainView

- (instancetype)init {
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.size = CGSizeMake(35, 35);
        _closeButton.right = [UIScreen width] - 15;
        _closeButton.y = 45 + UIScreen.safeInsets.top;
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return self;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
}

- (void)setModels:(NSArray<zhImageButtonModel *> *)models {
  
    if (CGSizeEqualToSize(CGSizeZero, _itemSize)) {
        _itemSize = CGSizeMake(50, 70);
    }
    CGFloat _gap = UIScreen.safeInsets.top + 30;
    CGFloat _space = (self.width - ROW_COUNT * _itemSize.width) / (ROW_COUNT + 1);
    
    _items = [NSMutableArray arrayWithCapacity:models.count];
    [models enumerateObjectsUsingBlock:^(zhImageButtonModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger l = idx % ROW_COUNT;
        NSInteger v = idx / ROW_COUNT;
        
        zhImageButton *item = [zhImageButton buttonWithType:UIButtonTypeCustom];
        item.userInteractionEnabled = YES;
        [self addSubview:item];
        [_items addObject:item];
        item.titleLabel.font = [UIFont fontWithName:@"pingFangSC-light" size:14];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitle:model.text forState:UIControlStateNormal];
        [item setImage:model.icon forState:UIControlStateNormal];
        [item imagePosition:zhImageButtonPositionTop spacing:15 imageViewResize:CGSizeMake(32, 32)];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        item.size = CGSizeMake(_itemSize.width, _itemSize.height + 20);
        item.x = _space + (_itemSize.width  + _space) * l;
        item.y = _gap + (_itemSize.height + 40) * v + 45;
    }];
}

- (void)close:(UIButton *)sender {
    if (nil != self.closeClicked) {
        self.closeClicked(sender);
    }
}

- (void)itemClicked:(zhImageButton *)button {
    if (nil != self.didClickItems) {
        self.didClickItems(self, button.tag);
    }
}

@end
