//
//  zhSidebarView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhSidebarView.h"

@interface zhSidebarView ()

@property (nonatomic, strong) zhImageButton *settingItem;
@property (nonatomic, strong) zhImageButton *nightItem;

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

- (zhImageButton *)itemWithText:(NSString *)text imageNamed:(NSString *)imageNamed {
    zhImageButton *item = [zhImageButton buttonWithType:UIButtonTypeCustom];
    item.userInteractionEnabled = YES;
    item.exclusiveTouch = YES;
    item.titleLabel.font = [UIFont systemFontOfSize:13];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    item.size = CGSizeMake(60, 90);
    item.bottom = [UIScreen height] - 20 - zh_safeAreaHeight();
    item.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [item setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    [item setTitle:text forState:UIControlStateNormal];
    [item imagePosition:zhImageButtonPositionTop spacing:10 imageViewResize:CGSizeMake(30, 30)];
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
        
        zhImageButton *item = [zhImageButton buttonWithType:UIButtonTypeCustom];
        item.userInteractionEnabled = YES;
        item.exclusiveTouch = YES;
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        item.imageView.contentMode = UIViewContentModeCenter;
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        item.imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imageNamed = [NSString stringWithFormat:@"sidebar_%@", text];
        [item setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
        [item setTitle:text forState:UIControlStateNormal];
        item.size = CGSizeMake(150, 50);
        item.y = (_gap + item.height) * idx + 150;
        item.centerX = self.width / 2;
        [item imagePosition:zhImageButtonPositionLeft spacing:25 imageViewResize:CGSizeMake(25, 25)];
        [self addSubview:item];
        [_items addObject:item];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)itemClicked:(zhImageButton *)sender {
    if (nil != self.didClickItems) {
        self.didClickItems(self, sender.tag);
    }
}

@end
