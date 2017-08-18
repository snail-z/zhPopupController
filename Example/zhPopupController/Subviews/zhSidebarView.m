//
//  zhSidebarView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhSidebarView.h"

@interface zhSidebarView ()

@property (nonatomic, strong) zhIconLabel *settingItem;
@property (nonatomic, strong) zhIconLabel *nightItem;

@end

@implementation zhSidebarView

- (instancetype)init {
    if (self = [super init]) {
        _settingItem = [self itemWithText:@"设置" imageNamed:@"sidebar_settings"];
        [self addSubview:_settingItem];
        _nightItem = [self itemWithText:@"夜间模式" imageNamed:@"sidebar_NightMode"];
        [self addSubview:_nightItem];
    }
    return self;
}

- (zhIconLabel *)itemWithText:(NSString *)text imageNamed:(NSString *)imageNamed {
    zhIconLabel *item = [zhIconLabel new];
    item.autoresizingFlexibleSize = YES;
    item.textLabel.textColor = [UIColor whiteColor];
    item.textLabel.font = [UIFont systemFontOfSize:13];
    item.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 10, 15);
    item.model = [zhIconLabelModel modelWithTitle:text image:[UIImage imageNamed:imageNamed]];
    [item updateLayoutBySize:CGSizeMake(60, 90) finished:^(zhIconLabel *item) {
        item.bottom = [UIScreen height] - 20;
    }];
    return item;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _settingItem.x =  50;
    _nightItem.right = self.width - 50;
}

- (void)setModels:(NSArray<NSString *> *)models {
    _items = @[].mutableCopy;
    CGFloat _gap = 15;
    [models enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        
        zhIconLabel *item = [[zhIconLabel alloc] init];
        item.textLabel.font = [UIFont systemFontOfSize:15];
        item.textLabel.textColor = [UIColor whiteColor];
        item.textLabel.font = [UIFont systemFontOfSize:16.f];
        item.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 30);
        item.horizontalLayout = YES;
        item.autoresizingFlexibleSize = YES;
        item.model = [zhIconLabelModel modelWithTitle:text image:[UIImage imageNamed:[NSString stringWithFormat:@"sidebar_%@", text]]];
        [self addSubview:item];
        [_items addObject:item];
        [item updateLayoutBySize:CGSizeMake(150, 50) finished:^(zhIconLabel *item) {
            item.y = (_gap + item.height) * idx + 150;
            item.centerX = self.width / 2;
        }];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)itemClicked:(zhIconLabel *)sender {
    if (nil != self.didClickItems) {
        self.didClickItems(self, sender.tag);
    }
}

@end
