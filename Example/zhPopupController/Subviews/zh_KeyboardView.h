//
//  zh_KeyboardView.h
//  zhPopupController
//
//  Created by zhanghao on 2017/9/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhUnderlineTextField : UITextField

@property (nonatomic, strong) UIColor *underlineColor;

@end

@interface zh_KeyboardView : UIView

@property (nonatomic, copy) void (^nextClickedBlock)(zh_KeyboardView *keyboardView, UIButton *button);
@property (nonatomic, copy) void (^loginClickedBlock)(zh_KeyboardView *keyboardView);

@property (nonatomic, strong) zhUnderlineTextField *numberField;
@property (nonatomic, strong) zhUnderlineTextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@end

@interface zh_KeyboardView2 : UIView

@property (nonatomic, copy) void (^gobackClickedBlock)(zh_KeyboardView2 *keyboardView, UIButton *button);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) zhUnderlineTextField *numberField;
@property (nonatomic, strong) zhUnderlineTextField *codeField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *gobackButton;

@end

@interface zh_KeyboardView3 : UIView

@property (nonatomic, copy) void (^senderClickedBlock)(zh_KeyboardView3 *keyboardView, UIButton *button);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *senderButton;

@end
