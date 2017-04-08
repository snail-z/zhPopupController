//
//  ViewController.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "ViewController.h"
#import "SnailPopupController.h"
#import "ViewController+Extension.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SnailSheetViewConfig, SnailSheetViewDelegate> {
    NSArray *_styles;
}
@property (nonatomic, strong) UITableView *tableView;

@end

static void *sl_CellButtonKey = &sl_CellButtonKey;

@implementation ViewController

- (void)viewDidLoad {
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
    @weakify(self);
    [_tableView sl_makeConstraints:^(SnailConstraintMaker *make) {
        [make.edges equalTo:weak_self.view];
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
        [cell sl_setAssociatedValue:button withKey:sl_CellButtonKey];
    }
    UIButton *button = (UIButton *)[cell sl_getAssociatedValueForKey:sl_CellButtonKey];
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
    SnailAlertView *alert = [self alertView1];
    SnailAlertButton *cancelButton = [SnailAlertButton buttonWithTitle:@"取消" handler:NULL];
    SnailAlertButton *okButton = [SnailAlertButton buttonWithTitle:@"确定" handler:^(SnailAlertButton * _Nonnull button) {
        [self.sl_popupController dismiss];
    }];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#FC7541"] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithHexString:@"#FC7541"] forState:UIControlStateNormal];
    [alert addAdjoinWithCancelAction:cancelButton okAction:okButton];
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.transitStyle = PopupTransitStyleFromTop;
    self.sl_popupController.dropTransitionAnimated = YES;
    [self.sl_popupController presentContentView:alert duration:0.75 elasticAnimated:YES];
}

- (void)example2 {
    SnailAlertView *alert = [self alertView2];
    SnailAlertButton *button = [SnailAlertButton buttonWithTitle:@"OK" handler:^(SnailAlertButton * _Nonnull button) {
        [self.sl_popupController dismiss];
    }];
    button.edgeInset = UIEdgeInsetsMake(20, 20, 25, 20);
    button.backgroundColor = [UIColor r:27 g:159 b:253];
    button.layer.cornerRadius = 5;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alert addAction:button];
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.maskType = PopupMaskTypeBlackBlur;
    self.sl_popupController.transitStyle = PopupTransitStyleShrinkInOut;
    [self.sl_popupController presentContentView:alert duration:0.75 elasticAnimated:YES];
}

- (void)example3 {
    SnailCurtainView *curtainView = [self curtainView];
    curtainView.closeClicked = ^(UIButton *closeButton) {
        [self.sl_popupController dismissWithDuration:0.25 elasticAnimated:NO];
    };
    curtainView.didClickItems = ^(SnailCurtainView *curtainView, NSInteger index) {
        [UIAlertController showAlert:curtainView.items[index].textLabel.text];
    };
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.layoutType = PopupLayoutTypeTop;
    self.sl_popupController.allowPan = YES;
    @weakify(self);
    self.sl_popupController.maskTouched = ^(SnailPopupController * _Nonnull popupController) {
        [weak_self.sl_popupController dismissWithDuration:0.25 elasticAnimated:NO];
    };
    [self.sl_popupController presentContentView:curtainView duration:0.75 elasticAnimated:YES];
}

- (void)example4 {
    SnailSidebarView *sidebar = [self sidebarView];
    sidebar.didClickItems = ^(SnailSidebarView *sidebarView, NSInteger index) {
        [self.sl_popupController dismiss];
        [UIAlertController showAlert:sidebarView.items[index].textLabel.text];
    };
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.layoutType = PopupLayoutTypeLeft;
    self.sl_popupController.allowPan = YES;
    [self.sl_popupController presentContentView:sidebar];
}

- (void)example5 {
    SnailFullView *full = [self fullView];
    full.didClickFullView = ^(SnailFullView * _Nonnull fullView) {
        [self.sl_popupController dismiss];
    };
    
    full.didClickItems = ^(SnailFullView *fullView, NSInteger index) {
        self.sl_popupController.didDismiss = ^(SnailPopupController * _Nonnull popupController) {
            [UIAlertController showAlert:fullView.items[index].textLabel.text];
        };
        
        [fullView endAnimationsCompletion:^(SnailFullView *fullView) {
            [self.sl_popupController dismiss];
        }];
    };
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.maskType = PopupMaskTypeWhiteBlur;
    self.sl_popupController.allowPan = YES;
    [self.sl_popupController presentContentView:full];
}

- (void)example6 {
    SnailSheetView *sheet = [self sheetViewWithConfig:self];
    sheet.delegate = self;
    sheet.didClickFooter = ^(SnailSheetView * _Nonnull sheetView) {
        [self.sl_popupController dismiss];
    };
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.layoutType = PopupLayoutTypeBottom;
    [self.sl_popupController presentContentView:sheet];
}

#pragma mark - SnailSheetViewConfig

- (SnailSheetViewLayout *)layoutOfItemInSheetView:(SnailSheetView *)sheetView {
    
    return [SnailSheetViewLayout layoutWithItemSize:CGSizeMake(70, 100)
                                      itemEdgeInset:UIEdgeInsetsMake(15, 10, 5, 10)
                                        itemSpacing:2
                                     imageViewWidth:60
                                         subSpacing:5];
}

#pragma mark - SnailSheetViewDelegate

- (void)sheetView:(SnailSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index {
    SnailSheetItemModel *model = [self sheetModels][section][index];
    @weakify(self);
    self.sl_popupController.didDismiss = ^(SnailPopupController * _Nonnull popupController) {
        @strongify(self);
        [UIAlertController showAlert:model.text inVC:self];
    };
    [self.sl_popupController dismiss];
}

@end
