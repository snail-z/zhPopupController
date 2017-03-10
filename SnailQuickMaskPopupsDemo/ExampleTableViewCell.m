//
//  TestTableViewCell.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/24.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ExampleTableViewCell.h"

@implementation ExampleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:20];
        _titleLabel.clipsToBounds = YES;
        _titleLabel.layer.cornerRadius = 4;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.size = CGSizeMake(222, 40);
    _titleLabel.centerX = self.centerX;
    _titleLabel.bottom = self.contentView.bottom;
}

@end
