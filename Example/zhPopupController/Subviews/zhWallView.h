//
//  zhWallView.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/11/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhWallViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface zhWallItemModel : NSObject

+ (instancetype)modelWithImage:(UIImage *)image text:(NSString *)text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;

@end

@protocol zhWallViewDelegateConfig, zhWallViewDelegate;
@interface zhWallView : UIView

@property (nonatomic, weak, nullable) id <zhWallViewDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *wallFooterLabel;
@property (nonatomic, strong, readonly) UILabel *wallHeaderLabel;

@property (nonatomic, strong) NSArray<NSArray<zhWallItemModel *> *> *models;

@property (nonatomic, copy) void (^didClickHeader)(zhWallView *wallView);
@property (nonatomic, copy) void (^didClickFooter)(zhWallView *wallView);

- (void)autoAdjustFitHeight;

@end

@protocol zhWallViewDelegate <NSObject>
@optional
// 点击了每个item事件
- (void)wallView:(zhWallView *)wallView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol zhWallViewDelegateConfig <zhWallViewDelegate>
@optional
// 布局相关
- (zhWallViewLayout *)layoutOfItemInWallView:(zhWallView *)wallView;
// 外观颜色相关
- (zhWallViewAppearance *)appearanceOfItemInWallView:(zhWallView *)wallView;

@end

NS_ASSUME_NONNULL_END
