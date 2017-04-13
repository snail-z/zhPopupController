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

@protocol SnailSheetViewConfigDelegate, SnailSheetViewDelegate;

@interface SnailSheetView : UIView

- (instancetype)init __attribute__ ((unavailable("You cannot initialize through init - please use initWithConfig:frame:")));
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame configDelegate:(id <SnailSheetViewConfigDelegate>)configDelegate NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak, nullable) id <SnailSheetViewDelegate> delegate;

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, copy) void (^didClickHeader)(SnailSheetView *sheetView);
@property (nonatomic, copy) void (^didClickFooter)(SnailSheetView *sheetView);
@property (nonatomic, strong, readonly) UILabel *headerLabel;
@property (nonatomic, strong, readonly) UILabel *footerLabel;
- (void)autoresizingFlexibleHeight;

@end

@protocol SnailSheetViewConfigDelegate <NSObject>

@required
- (SnailSheetViewLayout *)layoutOfItemInSheetView:(SnailSheetView *)sheetView; // 布局相关
@optional
- (SnailSheetViewAppearance *)appearanceOfItemInSheetView:(SnailSheetView *)sheetView; // 外观颜色相关

@end

@protocol SnailSheetViewDelegate <NSObject>

- (void)sheetView:(SnailSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index; // 点击了每个item事件

@end

NS_ASSUME_NONNULL_END
