//
//  SnailSidebarView.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "SnailSidebarView.h"

@interface SnailSidebarView ()

@property (nonatomic, strong) SnailImageLabel *settingItem;
@property (nonatomic, strong) SnailImageLabel *nighttimeItem;

@end

@implementation SnailSidebarView

- (SnailImageLabel *)imageLabelWithText:(NSString *)text imageNamed:(NSString *)imageNamed {
    SnailImageLabel *imageLabel = [SnailImageLabel new];
    imageLabel.textLabel.text = text;
    imageLabel.textLabel.textColor = [UIColor whiteColor];
    imageLabel.textLabel.font = [UIFont systemFontOfSize:13];
    [imageLabel.imgView setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    return imageLabel;
}

- (instancetype)init {
    if (self = [super init]) {
        _settingItem = [self imageLabelWithText:@"设置" imageNamed:@"rhino_设置"];
        [self addSubview:_settingItem];
        
        _nighttimeItem = [self imageLabelWithText:@"夜间模式" imageNamed:@"rhino_夜间模式"];
        [self addSubview:_nighttimeItem];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _nighttimeItem.padding  = _settingItem.padding = 35;
    _nighttimeItem.size     = _settingItem.size = CGSizeMake(60, 80);
    _nighttimeItem.bottom   = _settingItem.bottom = [UIScreen height] - 20;
    _settingItem.x =  [UIScreen width] * 0.05;
    _nighttimeItem.right = self.width - 50;
}

- (void)setItems:(NSArray<NSString *> *)items {
    CGFloat _gap = 15;
    [items enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.size = CGSizeMake(150, 50);
        item.x = [UIScreen width] * 0.055;
        item.centerX = self.width * 0.4;
        item.y = (_gap + item.height) * idx + [UIScreen height] * 0.25;
        item.imageView.contentMode = UIViewContentModeCenter;
        [item setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rhino_%@", title]] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        item.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        item.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        item.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:item];
    }];
}

@end
