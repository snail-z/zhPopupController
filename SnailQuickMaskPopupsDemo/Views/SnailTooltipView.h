//
//  SnailSharedTooltip.h
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TooltipComponents : UIView

@property (nonatomic, strong) CALayer *horizontalLine;
@property (nonatomic, strong) CALayer *verticalLine;
@property (nonatomic, strong) UIButton *mainButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@interface SnailTooltipView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) TooltipComponents *components;

- (void)reloadLayout;

@end
