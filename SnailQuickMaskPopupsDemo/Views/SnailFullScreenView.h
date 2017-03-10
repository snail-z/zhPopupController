//
//  SnailFullScreenView.h
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2017/2/5.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define _rowCount   3   // 默认每行显示3个
#define _rows       2   // 默认每页显示2行
#define _pages      2   // 共多少页

@protocol SnailFullScreenViewDelegate;

@interface SnailFullScreenView : UIView

@property (nonatomic, weak) id <SnailFullScreenViewDelegate> delegate;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<SnailImageLabelItem *> *items;
@property (nonatomic, strong) UIImage *advertisement;
@property (nonatomic, strong) NSMutableArray<SnailImageLabel *> *itemViews;

- (void)endAnimationCompletion:(void (^ __nullable)(BOOL finished))completion;

@end

@protocol SnailFullScreenViewDelegate <NSObject>
@optional
// 点击了空白
- (void)fullScreenViewWhenTapped:(SnailFullScreenView *)fullScreenView;
// 点击了广告
- (void)fullScreenViewDidClickAdvertisement:(UIButton *)advertisement;
// 点击了每个item
- (void)fullScreenView:(SnailFullScreenView *)fullView didClickItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
