//
//  zhPickerView.h
//  zhPopupController
//
//  Created by zhanghao on 2017/9/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhPickerView : UIView

@property (nonatomic, strong, readonly) UIPickerView *pickerView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *saveButton;
@property (nonatomic, strong, readonly) UIButton *cancelButton;

@property (nonatomic, copy) void (^saveClickedBlock)(zhPickerView *pickerView);
@property (nonatomic, copy) void (^cancelClickedBlock)(zhPickerView *pickerView);

@property (nonatomic, strong, readonly) NSString *selectedTimeString;
@property (nonatomic, assign, readonly) NSInteger selectedTimestamp;

@end
