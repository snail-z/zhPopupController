//
//  SnailSheetView.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/4/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnailSheetViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SnailSheetViewConfig, SnailSheetViewDelegate;

@interface SnailSheetView : UIView

- (nonnull instancetype)init __attribute__ ((unavailable("You cannot initialize through init - please use initWithConfig:frame:")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__ ((unavailable("You cannot initialize through init - please use initWithConfig:frame:")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__ ((unavailable("You cannot initialize through init - please use initWithConfig:frame:")));
- (instancetype)initWithConfig:(id <SnailSheetViewConfig>)config frame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, weak, nullable) id <SnailSheetViewDelegate> delegate;
@property (nonatomic, copy) void (^didClickHeader)(SnailSheetView *sheetView);
@property (nonatomic, copy) void (^didClickFooter)(SnailSheetView *sheetView);
@property (nonatomic, strong, readonly) UILabel *headerLabel;
@property (nonatomic, strong, readonly) UILabel *footerLabel;
- (void)autoresizingFlexibleHeight;

@end

@protocol SnailSheetViewConfig <NSObject>

@required
- (SnailSheetViewLayout *)layoutOfItemInSheetView:(SnailSheetView *)sheetView; // 布局相关
@optional
- (SnailSheetViewAppearance *)appearanceOfItemInSheetView:(SnailSheetView *)sheetView; // 外观颜色相关

@end

@protocol SnailSheetViewDelegate <NSObject>

- (void)sheetView:(SnailSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index; // 点击了每个item事件

@end

NS_ASSUME_NONNULL_END
