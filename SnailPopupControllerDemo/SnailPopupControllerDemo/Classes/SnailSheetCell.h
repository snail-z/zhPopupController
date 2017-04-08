//
//  SnailSheetCell.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/4/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SnailSheetViewLayout, SnailSheetViewAppearance, SnailSheetItemModel;

@interface SnailSheetCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                       layout:(SnailSheetViewLayout *)layout
                   appearance:(SnailSheetViewAppearance *)appearance;

@property (nonatomic, copy) void (^itemClicked)(NSInteger index);

@property (nonatomic, strong) NSArray *arrays;

@end

@interface SnailSheetCollectionCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIButton *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

- (void)setLayout:(SnailSheetViewLayout *)layout appearance:(SnailSheetViewAppearance *)appearance model:(SnailSheetItemModel *)model;

@end
