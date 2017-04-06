//
//  SnailSidebarView.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "SnailSidebarView.h"

@interface SnailSidebarView ()

@property (nonatomic, strong) SnailIconLabel *settingItem;
@property (nonatomic, strong) SnailIconLabel *nightItem;

@end

@implementation SnailSidebarView

- (instancetype)init {
    if (self = [super init]) {
        _settingItem = [self itemWithText:@"设置" imageNamed:@"sidebar_settings"];
        [self addSubview:_settingItem];
        _nightItem = [self itemWithText:@"夜间模式" imageNamed:@"sidebar_NightMode"];
        [self addSubview:_nightItem];
    }
    return self;
}

- (SnailIconLabel *)itemWithText:(NSString *)text imageNamed:(NSString *)imageNamed {
    SnailIconLabel *item = [SnailIconLabel new];
    item.autoresizingFlexibleSize = YES;
    item.textLabel.text = text;
    item.textLabel.textColor = [UIColor whiteColor];
    item.textLabel.font = [UIFont systemFontOfSize:13];
    item.iconView.image = [UIImage imageNamed:imageNamed];
    item.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 10, 15);
    item.size = CGSizeMake(60, 90);
    item.bottom = [UIScreen height];
    return item;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _settingItem.x =  [UIScreen width] * 0.05;
    _nightItem.right = self.width - 50;
}


- (void)setModels:(NSArray<NSString *> *)models {
    _items = @[].mutableCopy;
    CGFloat _gap = 15;
    [models enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SnailIconLabel *item = [[SnailIconLabel alloc] init];
        item.horizontalLayout = YES;
        item.autoresizingFlexibleSize = YES;
        item.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sidebar_%@", text]];
        item.textLabel.font = [UIFont systemFontOfSize:15];
        item.textLabel.text = text;
        item.textLabel.textColor = [UIColor whiteColor];
        item.textLabel.font = [UIFont systemFontOfSize:16.f];
        item.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 30);
        item.size = CGSizeMake(150, 50);
        item.x = 30;
        item.centerX = self.width / 2;
        item.y = (_gap + item.height) * idx + 150;
        [self addSubview:item];
        [_items addObject:item];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)itemClicked:(SnailIconLabel *)sender {
    if (nil != self.didClickItems) {
        self.didClickItems(self, sender.tag);
    }
}

@end
