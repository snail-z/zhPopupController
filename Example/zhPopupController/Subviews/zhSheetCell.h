//
//  zhSheetCell.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/11/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhSheetViewLayout, zhSheetViewAppearance, zhSheetItemModel;

@interface zhSheetCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                       layout:(zhSheetViewLayout *)layout
                   appearance:(zhSheetViewAppearance *)appearance;

@property (nonatomic, copy) void (^itemClicked)(NSInteger index);

@property (nonatomic, strong) NSArray *arrays;

@end

@interface SnailSheetCollectionCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIButton *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

- (void)setLayout:(zhSheetViewLayout *)layout appearance:(zhSheetViewAppearance *)appearance model:(zhSheetItemModel *)model;

@end
