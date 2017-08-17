//
//  zhSheetView.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/11/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhSheetViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol zhSheetViewConfigDelegate, zhSheetViewDelegate;

@interface zhSheetView : UIView

- (instancetype)init __attribute__ ((unavailable("You cannot initialize through init - please use initWithConfig:frame:")));
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame configDelegate:(id <zhSheetViewConfigDelegate>)configDelegate NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak, nullable) id <zhSheetViewDelegate> delegate;

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, copy) void (^didClickHeader)(zhSheetView *sheetView);
@property (nonatomic, copy) void (^didClickFooter)(zhSheetView *sheetView);
@property (nonatomic, strong, readonly) UILabel *headerLabel;
@property (nonatomic, strong, readonly) UILabel *footerLabel;
- (void)autoresizingFlexibleHeight;

@end

@protocol zhSheetViewConfigDelegate <NSObject>

@required
- (zhSheetViewLayout *)layoutOfItemInSheetView:(zhSheetView *)sheetView; // 布局相关
@optional
- (zhSheetViewAppearance *)appearanceOfItemInSheetView:(zhSheetView *)sheetView; // 外观颜色相关

@end

@protocol zhSheetViewDelegate <NSObject>

- (void)sheetView:(zhSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index; // 点击了每个item事件

@end

NS_ASSUME_NONNULL_END
