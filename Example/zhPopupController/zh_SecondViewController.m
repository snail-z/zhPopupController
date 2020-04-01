//
//  zh_ViewController.m
//  zhPopupController
//
//  Created by snail-z on 08/17/2016.
//  Copyright (c) 2017 snail-z. All rights reserved.
//

#import "zh_SecondViewController.h"
#import <zhPopupController/zhPopupController.h>
#import "zh_SecondViewController+Extension.h"
#import "zh_TestViewController.h"

static void *zh_CellButtonKey = &zh_CellButtonKey;

@interface zh_SecondViewController () <UITableViewDelegate, UITableViewDataSource, zhWallViewDelegateConfig>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *styles;
@property (nonatomic, assign) BOOL isLight;

@property (nonatomic, strong) zhPopupController *popupController1;
@property (nonatomic, strong) zhPopupController *popupController2;
@property (nonatomic, strong) zhPopupController *popupController3;
@property (nonatomic, strong) zhPopupController *popupController4;
@property (nonatomic, strong) zhPopupController *popupController5;
@property (nonatomic, strong) zhPopupController *popupController6;
@property (nonatomic, strong) zhPopupController *popupController7;
@property (nonatomic, strong) zhPopupController *popupController8;
@property (nonatomic, strong) zhPopupController *popupController9;
@property (nonatomic, strong) zhPopupController *popupController10;

@property (nonatomic, strong) zh_KeyboardView *keyboardView1;
@property (nonatomic, strong) zh_KeyboardView2 *keyboardView2;

@end

@implementation zh_SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zh_statusBarStyle = UIStatusBarStyleLightContent;
    [self commonInitialization];
}

- (void)commonInitialization {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(25, 0, 35, 0);
    }
    [self.view addSubview:_tableView];
    [_tableView zh_makeConstraints:^(SnailConstraintMaker *make) {
        [make.edges equalTo:self.view];
    }];
    
    if (!_styles) {
        _styles = @[@"style1", @"style2", @"style3", @"style4", @"style5", @"style6", @"Shared style7", @"Keyboard style8", @"Keyboard style9", @"Picker style10"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor colorWithHexString:@"0x70AFCE"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:17];
        button.layer.cornerRadius = 2;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        [button zh_makeConstraints:^(SnailConstraintMaker *make) {
            [make.width zh_equalTo:130];
            [make.height zh_equalTo:40];
            [make.center equalTo:cell.contentView];
        }];
        [cell sl_setAssociatedValue:button withKey:zh_CellButtonKey];
    }
    UIButton *button = (UIButton *)[cell sl_getAssociatedValueForKey:zh_CellButtonKey];
    [button setTitle:_styles[indexPath.row] forState:UIControlStateNormal];
    button.tag = indexPath.row;
    return cell;
}

- (void)buttonClicked:(UIButton *)sender {
    NSString *selName = [NSString stringWithFormat:@"example%lu", sender.tag + 1];
    SEL sel = NSSelectorFromString(selName);
    if ([self respondsToSelector:sel]) {
        self.title = _styles[sender.tag];
        [self performSelector:sel withObject:nil afterDelay:0];
    }
}

#pragma mark - Alert style1

- (zhPopupController *)popupController1 {
    if (!_popupController1) {
        zhAlertView *alert = [self alertView1];
        alert.layer.cornerRadius = 3;
        alert.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        alert.messageLabel.textColor = [UIColor blackColor];
        alert.messageLabel.font = [UIFont fontWithName:@"pingFangSC-light" size:16];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:NULL];
        __weak typeof(self) w_self = self;
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
            [w_self.popupController1 dismiss];
        }];
        cancelButton.lineColor = [UIColor colorWithHexString:@"0x70AFCE"];
        okButton.lineColor = cancelButton.lineColor;
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"0x70AFCE"] forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor colorWithHexString:@"0x70AFCE"] forState:UIControlStateNormal];
        cancelButton.edgeInsets = UIEdgeInsetsMake(22, 0, 0, 0);
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        
        _popupController1 = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
        _popupController1.presentationStyle = zhPopupSlideStyleTransform;
        _popupController1.presentationTransformScale = 1.25;
        _popupController1.dismissonTransformScale = 0.85;
    }
    return _popupController1;
}

- (void)example1 {
    [self.popupController1 showInView:self.view.window completion:NULL];
}

#pragma mark - Alert style2

- (zhPopupController *)popupController2 {
    if (!_popupController2) {
        zhAlertView *alert = [self alertView2];
        __weak typeof(self) w_self = self;
        zhAlertButton *button = [zhAlertButton buttonWithTitle:@"OK" handler:^(zhAlertButton * _Nonnull button) {
            [w_self.popupController2 dismiss];
        }];
        button.edgeInsets = UIEdgeInsetsMake(20, 20, 25, 20);
        button.backgroundColor = [UIColor r:27 g:159 b:253];
        button.layer.cornerRadius = 5;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [alert addAction:button];
        
        _popupController2 = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
        _popupController2.maskType = zhPopupMaskTypeDarkBlur;
        _popupController2.presentationStyle = zhPopupSlideStyleTransform;
        _popupController2.dismissOnMaskTouched = NO;
    }
    return _popupController2;
}

- (void)example2 {
    [self.popupController2 showInView:self.view.window duration:0.75 bounced:YES completion:nil];
}

#pragma mark - Overfly style

- (zhPopupController *)popupController3 {
    if (!_popupController3) {
        zhOverflyView *overflyView = [self overflyView];
        
        __weak typeof(self) w_self = self;
        zhOverflyButton *btn1 = [zhOverflyButton buttonWithTitle:@"忽略" handler:^(zhOverflyButton * _Nonnull button) {
            [w_self.popupController3 dismiss];
        }];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        zhOverflyButton *btn2 = [zhOverflyButton buttonWithTitle:@"查看详情" handler:NULL];
        [btn2 setTitleColor:[UIColor r:236 g:78 b:39] forState:UIControlStateNormal];
        
        [overflyView adjoinWithLeftAction:btn1 rightAction:btn2];
        
        _popupController3 = [[zhPopupController alloc] initWithView:overflyView size:overflyView.bounds.size];
        _popupController3.dismissOnMaskTouched = NO;
        _popupController3.presentationStyle = zhPopupSlideStyleFromBottom;
        _popupController3.dismissonStyle = zhPopupSlideStyleFromTop;
        _popupController3.offsetSpacing = 20;
    }
    return _popupController3;
}

- (void)example3 {
    [self.popupController3 showInView:self.view.window completion:NULL];
}

#pragma mark - Qzone style

- (zhPopupController *)popupController4 {
    if (!_popupController4) {
        zhCurtainView *curtainView = [self curtainView];
        
        __weak typeof(self) w_self = self;
        curtainView.closeClicked = ^(UIButton *closeButton) {
            [w_self.popupController4 dismiss];
        };
        curtainView.didClickItems = ^(zhCurtainView *curtainView, NSInteger index) {
            [UIAlertController showAlert:curtainView.items[index].titleLabel.text];
        };
        
        _popupController4 = [[zhPopupController alloc] initWithView:curtainView size:curtainView.bounds.size];
        _popupController4.layoutType = zhPopupLayoutTypeTop;
        _popupController4.presentationStyle = zhPopupSlideStyleFromTop;
        _popupController4.offsetSpacing = -30;
        
        _popupController4.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            w_self.isLight = YES;
        };
        
        _popupController4.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
            w_self.isLight = NO;
        };
    }
    return _popupController4;
}

- (void)setIsLight:(BOOL)isLight {
    _isLight = isLight;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return self.isLight ? UIStatusBarStyleDarkContent : UIStatusBarStyleLightContent;
    } else {
        return self.isLight ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)example4 {
    [self.popupController4 showInView:self.view.window duration:0.75 bounced:YES completion:nil];
}

#pragma mark - Sidebar style

- (zhPopupController *)popupController5 {
    if (!_popupController5) {
        zhSidebarView *sidebar = [self sidebarView];
        
        __weak typeof(self) w_self = self;
        sidebar.didClickItems = ^(zhSidebarView *sidebarView, NSInteger index) {
            [w_self.popupController5 dismiss];
            [UIAlertController showAlert:sidebarView.items[index].titleLabel.text];
        };
        
        _popupController5 = [[zhPopupController alloc] initWithView:sidebar size:sidebar.bounds.size];
        _popupController5.layoutType = zhPopupLayoutTypeLeft;
        _popupController5.presentationStyle = zhPopupSlideStyleFromLeft;
        _popupController5.panGestureEnabled = YES;
        _popupController5.panDismissRatio = 0.5;
    }
    return _popupController5;
}

- (void)example5 {
    [self.popupController5 showInView:self.view.window completion:NULL];
}

#pragma mark - Full style

- (zhPopupController *)popupController6 {
    if (!_popupController6) {
        zhFullView *full = [self fullView];
        
        __weak typeof(self) w_self = self;
        full.didClickFullView = ^(zhFullView * _Nonnull fullView) {
            [w_self.popupController6 dismiss];
        };

        full.didClickItems = ^(zhFullView *fullView, NSInteger index) {
            [fullView endAnimationsCompletion:^(zhFullView *fullView) {
                zh_TestViewController *vc = [zh_TestViewController new];
                vc.title = fullView.items[index].titleLabel.text;
                [w_self.navigationController pushViewController:vc animated:YES];
                [w_self.popupController6 dismiss];
            }];
        };
        
        _popupController6 = [[zhPopupController alloc] initWithView:full size:full.bounds.size];
        _popupController6.maskType = zhPopupMaskTypeExtraLightBlur;
        _popupController6.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            [full startAnimationsCompletion:NULL];
        };
    }
    return _popupController6;
}

- (void)example6 {
    [self.popupController6 showInView:self.view.window completion:NULL];
}

#pragma mark - Shared style

- (zhPopupController *)popupController7 {
    if (!_popupController7) {
        zhWallView *wallView = [self wallView];
        wallView.delegate = self;
        
        __weak typeof(self) w_self = self;
        wallView.didClickFooter = ^(zhWallView * _Nonnull sheetView) {
            [w_self.popupController7 dismiss];
        };
        
        _popupController7 = [[zhPopupController alloc] initWithView:wallView size:wallView.bounds.size];
        _popupController7.layoutType = zhPopupLayoutTypeBottom;
        _popupController7.presentationStyle = zhPopupSlideStyleFromBottom;
    }
    return _popupController7;
}

- (void)example7 {
    [self.popupController7 showInView:self.view.window duration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut bounced:NO completion:nil];
}

// zhWallViewDelegateConfig
- (zhWallViewLayout *)layoutOfItemInWallView:(zhWallView *)wallView {
    zhWallViewLayout *layout = [zhWallViewLayout new];
    layout.itemSubviewsSpacing = 9;
    return layout;
}

- (zhWallViewAppearance *)appearanceOfItemInWallView:(zhWallView *)wallView {
    zhWallViewAppearance *appearance = [zhWallViewAppearance new];
    appearance.textLabelFont = [UIFont systemFontOfSize:10];
    return appearance;
}

// zhWallViewDelegate
- (void)wallView:(zhWallView *)wallView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    zhWallItemModel *model = [self wallModels][indexPath.section][indexPath.row];
    [self.popupController7 dismissWithDuration:0.25 completion:^{
        [UIAlertController showAlert:model.text];
    }];
}

#pragma mark - Keyboard style1

- (zh_KeyboardView *)keyboardView1 {
    if (!_keyboardView1) {
        _keyboardView1 = [[zh_KeyboardView alloc] initWithFrame:CGRectMake(0, 0, 300, 236)];
        __weak typeof(self) w_self = self;
        _keyboardView1.loginClickedBlock = ^(zh_KeyboardView *keyboardView) {
            [w_self.popupController8 dismiss];
        };
        
        _keyboardView1.nextClickedBlock = ^(zh_KeyboardView *keyboardView, UIButton *button) {
            [UIView transitionWithView:w_self.popupController8.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{

                [w_self.popupController8.view addSubview:w_self.keyboardView2];
                [w_self.keyboardView2.numberField becomeFirstResponder];

            } completion:^(BOOL finished) {
                if ([w_self.popupController8.view.subviews containsObject:keyboardView]) {
                    [keyboardView removeFromSuperview];
                }
            }];
        };
    }
    return _keyboardView1;
}

- (zh_KeyboardView2 *)keyboardView2 {
    if (!_keyboardView2) {
        _keyboardView2 = [[zh_KeyboardView2 alloc] initWithFrame:CGRectMake(0, 0, 300, 236)];
        __weak typeof(self) w_self = self;
        _keyboardView2.gobackClickedBlock = ^(zh_KeyboardView2 *keyboardView, UIButton *button) {
            __strong typeof(w_self) s_self = w_self;

            [UIView transitionWithView:s_self.popupController8.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{

                [s_self.popupController8.view addSubview:s_self.keyboardView1];
                [s_self.keyboardView1.numberField becomeFirstResponder];

            } completion:^(BOOL finished) {
                if ([s_self.popupController8.view.subviews containsObject:keyboardView]) {
                    [keyboardView removeFromSuperview];
                }
            }];
        };
        
        _keyboardView2.nextClickedBlock = ^(zh_KeyboardView2 *keyboardView, UIButton *button) {
            [w_self.keyboardView1.numberField resignFirstResponder];
            [w_self.keyboardView2.numberField resignFirstResponder];
        };
    }
    return _keyboardView2;
}

- (zhPopupController *)popupController8 {
    if (!_popupController8) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 236)];
        [backView addSubview:self.keyboardView1];

        _popupController8 = [[zhPopupController alloc] initWithView:backView size:backView.bounds.size];
        _popupController8.maskType = zhPopupMaskTypeBlackOpacity;
        _popupController8.layoutType = zhPopupLayoutTypeCenter;
        _popupController8.presentationStyle = zhPopupSlideStyleFromBottom;
        _popupController8.keyboardOffsetSpacing = 50;
        _popupController8.keyboardChangeFollowed = YES;
        _popupController8.becomeFirstResponded = YES;
        
        __weak typeof(self) w_self = self;
        _popupController8.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            [w_self.keyboardView1.numberField becomeFirstResponder];
        };
        
        _popupController8.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
            if (w_self.keyboardView1.numberField.isFirstResponder) {
                [w_self.keyboardView1.numberField resignFirstResponder];
            }
            
            if (w_self.keyboardView2.numberField.isFirstResponder) {
                [w_self.keyboardView2.numberField resignFirstResponder];
            }
        };
        
    }
    return _popupController8;
}

- (void)example8 {
    [self.popupController8 showInView:self.view.window duration:0.25 completion:NULL];
}

#pragma mark - Keyboard style2

- (zhPopupController *)popupController9 {
    if (!_popupController9) {
        CGRect rect = CGRectMake(0, 0, self.view.width, 60);
        zh_KeyboardView3 *kbview = [[zh_KeyboardView3 alloc] initWithFrame:rect];
        
        __weak typeof(self) w_self = self;
        kbview.senderClickedBlock = ^(zh_KeyboardView3 *keyboardView, UIButton *button) {
            [w_self.popupController9 dismiss];
        };
        
        _popupController9 = [[zhPopupController alloc] initWithView:kbview size:kbview.bounds.size];
        _popupController9.maskType = zhPopupMaskTypeDarkBlur;
        _popupController9.layoutType = zhPopupLayoutTypeBottom;
        _popupController9.presentationStyle = zhPopupSlideStyleFromBottom;
        _popupController9.becomeFirstResponded = YES;
        _popupController9.keyboardChangeFollowed = YES;
        
        _popupController9.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            [kbview.textField becomeFirstResponder];
        };
        
        _popupController9.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
            [kbview.textField resignFirstResponder];
        };
    }
    return _popupController9;
}

- (void)example9 {
    [self.popupController9 showInView:self.view.window completion:NULL];
}

#pragma mark - Picker style

- (zhPopupController *)popupController10 {
    if (!_popupController10) {
        CGRect rect = CGRectMake(0, 0, self.view.width, 280 + UIScreen.safeInsets.bottom);
        zhPickerView *pView = [[zhPickerView alloc] initWithFrame:rect];

        __weak typeof(self) w_self = self;
        pView.saveClickedBlock = ^(zhPickerView *pickerView) {
            NSString *message = [NSString stringWithFormat:@"%@\n%@", pickerView.selectedTimeString, @(pickerView.selectedTimestamp)];
            [w_self.popupController10 dismissWithDuration:0.25 completion:^{
                [UIAlertController showAlert:message];
            }];
        };

        pView.cancelClickedBlock = ^(zhPickerView *pickerView) {
            [w_self.popupController10 dismiss];
        };
        
        _popupController10 = [[zhPopupController alloc] initWithView:pView size:pView.bounds.size];
        _popupController10.layoutType = zhPopupLayoutTypeBottom;
        _popupController10.presentationStyle = zhPopupSlideStyleFromBottom;
    }
    return _popupController10;
}

- (void)example10 {
    [self.popupController10 showInView:self.view.window completion:NULL];
}

#pragma mark - Dealloc

- (void)dealloc {
    NSLog(@"dealloc--✈️✈️✈️---%@", NSStringFromClass(self.class));
}

@end
