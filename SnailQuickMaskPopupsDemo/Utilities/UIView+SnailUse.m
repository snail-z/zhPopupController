//
//  UIView+SnailUse.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2017/2/9.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "UIView+SnailUse.h"

@implementation UIView (SnailUse)

+ (id)cityTooltip {
    SnailTooltipView *view = [SnailTooltipView new];
    view.width = 280;
    view.titleLabel.text = @"提示";
    view.detailTextLabel.text = @"切换城市失败，是否重试？";
    UIColor *color = [UIColor colorWithHexString:@"#FC7541"];
    [view.components.mainButton setTitle:@"取消" forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:color forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [view.components.cancelButton setTitle:@"重试" forState:UIControlStateNormal];
    [view.components.cancelButton setTitleColor:color forState:UIControlStateNormal];
    [view.components.cancelButton setTitleColor:color forState:UIControlStateHighlighted];
    view.components.verticalLine.backgroundColor = color.CGColor;
    view.components.horizontalLine.backgroundColor = color.CGColor;
    [view reloadLayout];
    return view;
}

+ (id)wechatTooltip {
    SnailTooltipView *view = [SnailTooltipView new];
    view.width = 290;
    view.titleLabel.text = @"语音转文字";
    view.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    view.detailTextLabel.text = @"此功能目前仅可以转换普通话，结果仅供参考。";
    view.detailTextLabel.textColor = [UIColor r:160 g:159 b:160];
    view.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    [view.components.mainButton setTitle:@"知道了" forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:[UIColor r:10 g:176 b:2] forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [view reloadLayout];
    return view;
}

+ (id)slogan {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"广告"]];
    imgView.size = CGSizeMake(270, 320);
    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = 4;
    return imgView;
}

+ (id)qzoneCurtain {
    SnailCurtainView *view = [SnailCurtainView new];
    view.width = [UIScreen width];
    NSArray *imageNames = @[@"说说", @"照片", @"视频", @"签到", @"大头贴"];
    NSMutableArray *items = @[].mutableCopy;
    [imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[SnailImageLabelItem itemWithTitle:imageName image:[UIImage imageNamed:imageName]]];
    }];
    view.items = items;
    return view;
}

+ (id)sharedCurtain {
    SnailCurtainView *view = [SnailCurtainView new];
    view.width = [UIScreen width];
    view.close.hidden = YES;
    view.itemSize = CGSizeMake(50, 80);
    NSArray *imageNames = @[@"微信好友", @"朋友圈", @"新浪微博", @"QQ好友", @"跳转"];
    NSMutableArray *items = @[].mutableCopy;
    [imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[SnailImageLabelItem itemWithTitle:imageName image:[UIImage imageNamed:imageName]]];
    }];
    view.items = items;
    view.height += 45;
    return view;
}

+ (id)sidebar {
    SnailSidebarView *view = [SnailSidebarView new];
    view.size = CGSizeMake([UIScreen width] - 90, [UIScreen height]);
    view.backgroundColor = [UIColor r:24 g:28 b:45 alphaComponent:0.8];
    view.items = @[@"我的故事", @"消息中心", @"我的收藏", @"近期阅读", @"离线阅读"];
    return view;
}

+ (id)fullScreen {
    SnailFullScreenView *view = [SnailFullScreenView new];
    view.size = [UIApplication sharedApplication].keyWindow.size;
    NSMutableArray *items = @[].mutableCopy;
    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"更多", @"点评", @"好友圈", @"音乐", @"商品", @"签到", @"秒拍"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SnailImageLabelItem *item = [SnailImageLabelItem new];
        item.image = [UIImage imageNamed:[NSString stringWithFormat:@"sina_%@", obj]];
        item.title = obj;
        [items addObject:item];
    }];
    view.items = items;
    view.advertisement = [UIImage imageNamed:@"4G LTE"];
    return view;
}

@end
