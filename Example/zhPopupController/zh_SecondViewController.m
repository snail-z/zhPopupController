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
        _styles = @[@"Alert style1", @"Alert style2", @"Overfly style", @"Qzone style", @"Sidebar style", @"Full style", @"Shared style", @"Keyboard style1", @"Keyboard style2", @"Picker style"];
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
        button.backgroundColor = [UIColor colorWithHexString:@"569EED"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:22];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        [button zh_makeConstraints:^(SnailConstraintMaker *make) {
            [make.width zh_equalTo:220];
            [make.height zh_equalTo:45];
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

- (void)example1 {
    zhAlertView *alert = [self alertView1];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:NULL];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
        [self.zh_popupController dismiss];
    }];
    cancelButton.lineColor = [UIColor colorWithHexString:@"#FC7541"];
    okButton.lineColor = cancelButton.lineColor;
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#FC7541"] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithHexString:@"#FC7541"] forState:UIControlStateNormal];
    cancelButton.edgeInsets = UIEdgeInsetsMake(15, 0, 0, 0);
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController dropAnimatedWithRotateAngle:30];
    [self.zh_popupController presentContentView:alert duration:0.75 springAnimated:YES];
}

#pragma mark - Alert style2

- (void)example2 {
    zhAlertView *alert = [self alertView2];
    zhAlertButton *button = [zhAlertButton buttonWithTitle:@"OK" handler:^(zhAlertButton * _Nonnull button) {
        [self.zh_popupController dismiss];
    }];
    button.edgeInsets = UIEdgeInsetsMake(20, 20, 25, 20);
    button.backgroundColor = [UIColor r:27 g:159 b:253];
    button.layer.cornerRadius = 5;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alert addAction:button];
    
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackBlur];
    self.zh_popupController.slideStyle = zhPopupSlideStyleShrinkInOut1;
    self.zh_popupController.allowPan = YES;
    self.zh_popupController.dismissOnMaskTouched = NO;
    // 弹出2秒后消失
    [self.zh_popupController presentContentView:alert duration:0.75 springAnimated:YES inView:nil displayTime:2];
}

#pragma mark - Overfly style

- (void)example3 {
    zhOverflyView *overflyView = [self overflyView];
    
    zhOverflyButton *btn1 = [zhOverflyButton buttonWithTitle:@"忽略" handler:^(zhOverflyButton * _Nonnull button) {
        [self.zh_popupController dismiss];
    }];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    zhOverflyButton *btn2 = [zhOverflyButton buttonWithTitle:@"查看详情" handler:NULL];
    [btn2 setTitleColor:[UIColor r:236 g:78 b:39] forState:UIControlStateNormal];
    
    [overflyView adjoinWithLeftAction:btn1 rightAction:btn2];
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.dismissOnMaskTouched = NO;
    self.zh_popupController.dismissOppositeDirection = YES;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self.zh_popupController presentContentView:overflyView duration:0.75 springAnimated:YES];
}

#pragma mark - Qzone style

- (void)example4 {
    zhCurtainView *curtainView = [self curtainView];
    curtainView.closeClicked = ^(UIButton *closeButton) {
        [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    };
    curtainView.didClickItems = ^(zhCurtainView *curtainView, NSInteger index) {
        [UIAlertController showAlert:curtainView.items[index].titleLabel.text];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeTop;
    self.zh_popupController.allowPan = YES;
    
    self.zh_popupController.maskTouched = ^(zhPopupController * _Nonnull popupController) {
        [popupController dismissWithDuration:0.25 springAnimated:NO];
    };
    
    __weak typeof(self) weak_self = self;
    self.zh_popupController.willDismiss = ^(zhPopupController * _Nonnull popupController) {
        weak_self.zh_statusBarStyle = UIStatusBarStyleLightContent;
    };
    self.zh_statusBarStyle = UIStatusBarStyleDefault;
    [self.zh_popupController presentContentView:curtainView duration:0.75 springAnimated:YES];
}

#pragma mark - Sidebar style

- (void)example5 {
    zhSidebarView *sidebar = [self sidebarView];
    sidebar.didClickItems = ^(zhSidebarView *sidebarView, NSInteger index) {
        [self.zh_popupController dismiss];
        [UIAlertController showAlert:sidebarView.items[index].titleLabel.text];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeLeft;
    self.zh_popupController.allowPan = YES;
    [self.zh_popupController presentContentView:sidebar];
}

#pragma mark - Full style

- (void)example6 {
    zhFullView *full = [self fullView];
    full.didClickFullView = ^(zhFullView * _Nonnull fullView) {
        [self.zh_popupController dismiss];
    };
    
    full.didClickItems = ^(zhFullView *fullView, NSInteger index) {
        
        __weak typeof(self) weak_self = self;
        self.zh_popupController.willDismiss = ^(zhPopupController * _Nonnull popupController) {
            zh_TestViewController *vc = [zh_TestViewController new];
            vc.title = fullView.items[index].titleLabel.text;
            [weak_self.navigationController pushViewController:vc animated:YES];
        };
        
        [fullView endAnimationsCompletion:^(zhFullView *fullView) {
            [self.zh_popupController dismiss];
        }];
    };
    
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeWhiteBlur];
    self.zh_popupController.allowPan = YES;
    [self.zh_popupController presentContentView:full];
}

#pragma mark - Shared style

- (void)example7 {
    zhWallView *wallView = [self wallView];
    wallView.delegate = self;
    wallView.didClickFooter = ^(zhWallView * _Nonnull sheetView) {
        [self.zh_popupController dismiss];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:wallView];
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
    self.zh_popupController.didDismiss = ^(zhPopupController * _Nonnull popupController) {
        [UIAlertController showAlert:model.text];
    };
    [self.zh_popupController dismiss];
}

#pragma mark - Keyboard style1

- (void)example8 {
    CGRect rect = CGRectMake(0, 0, 300, 236);
    zh_KeyboardView *kbview1 = [[zh_KeyboardView alloc] initWithFrame:rect];
    zh_KeyboardView2 *kbview2 = [[zh_KeyboardView2 alloc] initWithFrame:rect];
    
    kbview1.loginClickedBlock = ^(zh_KeyboardView *keyboardView) {
        [self.zh_popupController dismiss];
    };
    
    kbview1.nextClickedBlock = ^(zh_KeyboardView *keyboardView, UIButton *button) {

        [UIView transitionWithView:self.zh_popupController.popupView duration:0.65 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
            [self.zh_popupController.popupView addSubview:kbview2];
            [kbview2.numberField becomeFirstResponder];
            
        } completion:^(BOOL finished) {
            if ([self.zh_popupController.popupView.subviews containsObject:keyboardView]) {
                [keyboardView removeFromSuperview];
            }
        }];
        
    };
    
    __weak typeof(self) weak_self = self;
    __weak typeof(kbview1) weak_kbview1 = kbview1;
    
    kbview2.gobackClickedBlock = ^(zh_KeyboardView2 *keyboardView, UIButton *button) {
        
        __strong typeof(weak_self) strong_self = weak_self;
        __strong typeof(weak_kbview1) strong_kbview = weak_kbview1;
        
        [UIView transitionWithView:strong_self.zh_popupController.popupView duration:0.65 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
            [strong_self.zh_popupController.popupView addSubview:strong_kbview];
            [strong_kbview.numberField becomeFirstResponder];
            
        } completion:^(BOOL finished) {
            if ([strong_self.zh_popupController.popupView.subviews containsObject:keyboardView]) {
                [keyboardView removeFromSuperview];
            }
        }];
        
    };
    
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackBlur];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.zh_popupController presentContentView:kbview1 duration:0.25 springAnimated:NO];
}

#pragma mark - Keyboard style2

- (void)example9 {
    CGRect rect = CGRectMake(0, 0, self.view.width, 60);
    zh_KeyboardView3 *kbview = [[zh_KeyboardView3 alloc] initWithFrame:rect];
    kbview.senderClickedBlock = ^(zh_KeyboardView3 *keyboardView, UIButton *button) {
        [self.zh_popupController dismiss];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    self.zh_popupController.offsetSpacingOfKeyboard = 30; // 可以设置与键盘之间的间距
    [self.zh_popupController presentContentView:kbview duration:0.25 springAnimated:NO];
}

#pragma mark - Picker style

- (void)example10 {
    CGRect rect = CGRectMake(0, 0, self.view.width, 275);
    zhPickerView *pView = [[zhPickerView alloc] initWithFrame:rect];

    pView.saveClickedBlock = ^(zhPickerView *pickerView) {
        NSString *message = [NSString stringWithFormat:@"%@\n%lu", pickerView.selectedTimeString, pickerView.selectedTimestamp];
        self.zh_popupController.didDismiss = ^(zhPopupController * _Nonnull popupController) {
            [UIAlertController showAlert:message];
        };
        [self.zh_popupController dismiss];
    };
    
    pView.cancelClickedBlock = ^(zhPickerView *pickerView) {
        [self.zh_popupController dismiss];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:pView];
}

#pragma mark - Dealloc

- (void)dealloc {
    NSLog(@"%@ ======> dealloc ✈️", NSStringFromClass(self.class));
}

@end
