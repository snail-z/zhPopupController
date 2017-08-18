//
//  zh_ViewController.m
//  zhPopupController
//
//  Created by snail-z on 08/17/2016.
//  Copyright (c) 2017 snail-z. All rights reserved.
//

#import "zh_ViewController.h"
#import <zhPopupController/zhPopupController.h>
#import "zh_ViewController+Extension.h"

static void *zh_CellButtonKey = &zh_CellButtonKey;

@interface zh_ViewController () <UITableViewDelegate, UITableViewDataSource, zhSheetViewConfigDelegate, zhSheetViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *styles;


@end

@implementation zh_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar sl_setBackgroundColor:[UIColor r:44 g:153 b:252]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"Apple SD Gothic Neo" size:23];
    self.navigationController.navigationBar.titleTextAttributes = textAttrs;
    self.navigationItem.title = @"SnailPopupController";
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
    }
    [self.view addSubview:_tableView];
    [_tableView sl_makeConstraints:^(SnailConstraintMaker *make) {
        [make.edges equalTo:self.view];
    }];
    
    if (!_styles) {
        _styles = @[@"Alert style1", @"Alert style2", @"Qzone style", @"Sidebar style", @"Full style", @"Shared style"];
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
        button.backgroundColor = [UIColor r:52 g:155 b:249];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:22];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        [button sl_makeConstraints:^(SnailConstraintMaker *make) {
            [make.width sl_equalTo:220];
            [make.height sl_equalTo:45];
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

#pragma mark - Example

- (void)example1 {
    zhAlertView *alert = [self alertView1];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:NULL];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
        [self.zh_popupController dismiss];
    }];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#FC7541"] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithHexString:@"#FC7541"] forState:UIControlStateNormal];
    [alert addAdjoinWithCancelAction:cancelButton okAction:okButton];
    
    self.zh_popupController = [zhPopupController new];
    [self.zh_popupController dropAnimatedWithRotateAngle:30];
    [self.zh_popupController presentContentView:alert duration:0.75 springAnimated:YES];
}

- (void)example2 {
    zhAlertView *alert = [self alertView2];
    zhAlertButton *button = [zhAlertButton buttonWithTitle:@"OK" handler:^(zhAlertButton * _Nonnull button) {
        [self.zh_popupController dismiss];
    }];
    button.edgeInset = UIEdgeInsetsMake(20, 20, 25, 20);
    button.backgroundColor = [UIColor r:27 g:159 b:253];
    button.layer.cornerRadius = 5;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alert addAction:button];
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.maskType = zhPopupMaskTypeBlackBlur;
    self.zh_popupController.slideStyle = zhPopupSlideStyleShrinkInOut;
    self.zh_popupController.allowPan = YES;
    [self.zh_popupController presentContentView:alert duration:0.75 springAnimated:YES];
}

- (void)example3 {
    zhCurtainView *curtainView = [self curtainView];
    curtainView.closeClicked = ^(UIButton *closeButton) {
        [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    };
    curtainView.didClickItems = ^(zhCurtainView *curtainView, NSInteger index) {
        [UIAlertController showAlert:curtainView.items[index].textLabel.text];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeTop;
    self.zh_popupController.allowPan = YES;
    
    __typeof(self) weakSelf = self;
    self.zh_popupController.maskTouched = ^(zhPopupController * _Nonnull popupController) {
        [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    };
    [self.zh_popupController presentContentView:curtainView duration:0.75 springAnimated:YES];
}

- (void)example4 {
    zhSidebarView *sidebar = [self sidebarView];
    sidebar.didClickItems = ^(zhSidebarView *sidebarView, NSInteger index) {
        [self.zh_popupController dismiss];
        [UIAlertController showAlert:sidebarView.items[index].textLabel.text];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeLeft;
    self.zh_popupController.allowPan = YES;
    [self.zh_popupController presentContentView:sidebar];
}

- (void)example5 {
    zhFullView *full = [self fullView];
    full.didClickFullView = ^(zhFullView * _Nonnull fullView) {
        [self.zh_popupController dismiss];
    };
    
    full.didClickItems = ^(zhFullView *fullView, NSInteger index) {
        self.zh_popupController.didDismiss = ^(zhPopupController * _Nonnull popupController) {
            [UIAlertController showAlert:fullView.items[index].textLabel.text];
        };
        
        [fullView endAnimationsCompletion:^(zhFullView *fullView) {
            [self.zh_popupController dismiss];
        }];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.maskType = zhPopupMaskTypeWhiteBlur;
    self.zh_popupController.allowPan = YES;
    [self.zh_popupController presentContentView:full];
}

- (void)example6 {
    zhSheetView *sheet = [self sheetViewWithConfig:self];
    sheet.delegate = self;
    sheet.didClickFooter = ^(zhSheetView * _Nonnull sheetView) {
        [self.zh_popupController dismiss];
    };
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    self.zh_popupController.allowPan = YES;
    [self.zh_popupController presentContentView:sheet];
}

#pragma mark - zhSheetViewConfig

- (zhSheetViewLayout *)layoutOfItemInSheetView:(zhSheetView *)sheetView {
    
    return [zhSheetViewLayout layoutWithItemSize:CGSizeMake(70, 100)
                                   itemEdgeInset:UIEdgeInsetsMake(15, 10, 5, 10)
                                     itemSpacing:2
                                  imageViewWidth:60
                                      subSpacing:5];
}

#pragma mark - zhSheetViewDelegate

- (void)sheetView:(zhSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index {
    zhSheetItemModel *model = [self sheetModels][section][index];
    __typeof(self) weakSelf = self;
    self.zh_popupController.didDismiss = ^(zhPopupController * _Nonnull popupController) {
        __typeof(weakSelf)strongSelf = weakSelf;
        [UIAlertController showAlert:model.text inVC:strongSelf];
    };
    [self.zh_popupController dismiss];
}

@end

