//
//  TestTableViewController.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2016/12/24.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "ExampleTableViewCell.h"
#import "SnailQuickMaskPopups.h"
#import "UIView+SnailUse.h"
#import "UIAlertController+SnailUse.h"

@interface ExampleTableViewController () <SnailQuickMaskPopupsDelegate, SnailCurtainViewDelegate, SnailFullScreenViewDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *styles;
@property (nonatomic, strong) NSMutableArray *selNames;
@property (nonatomic, strong) SnailQuickMaskPopups *popups;

@end

@implementation ExampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar sl_setBackgroundColor:[UIColor r:102 g:150 b:95]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"Gurmukhi MN" size:20];
    self.navigationController.navigationBar.titleTextAttributes = textAttrs;
    self.navigationItem.title = @"SnailQuickMaskPopups";
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self contentsInitialization];
}

- (void)contentsInitialization {
    _colors = @[@"#FC7541",
                @"#0AB002",
                @"#707070",
                @"#7ABE64",
                @"#5BA9F8",
                @"#E2547D"];
    _styles = @[@"Alert style",
                @"WeChat style",
                @"Qzone style",
                @"Shared style",
                @"Sidebar style",
                @"Full style"];
    _selNames = @[].mutableCopy;
    [_styles enumerateObjectsUsingBlock:^(NSString *styles, NSUInteger idx, BOOL * _Nonnull stop) {
        [_selNames addObject:[NSString stringWithFormat:@"example%lu", idx + 1]];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ExampleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.titleLabel.text = _styles[indexPath.row];
    cell.titleLabel.backgroundColor = [UIColor colorWithHexString:_colors[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selName = _selNames[indexPath.row];
    SEL sel = NSSelectorFromString(selName);
    if ([self respondsToSelector:sel]) {
        self.title = _styles[indexPath.row];
        [self performSelector:sel withObject:nil afterDelay:0];
    }
}

#pragma mark - selector methods

- (void)example1 {
    SnailTooltipView *v = [UIView cityTooltip];
    [v.components.mainButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackBlur aView:v];
    _popups.presentationStyle = PresentationStyleCentered;
    _popups.transitionStyle = TransitionStyleFromTop;
    _popups.isDismissedOppositeDirection = YES;
    _popups.isAllowMaskTouch = NO;
    _popups.springDampingRatio = 0.5;
    [_popups presentWithAnimated:YES completion:NULL];
}

- (void)example2 {
    SnailTooltipView *v = [UIView wechatTooltip];
    [v.components.mainButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:v];
    _popups.presentationStyle = PresentationStyleCentered;
    _popups.transitionStyle = TransitionStyleZoom;
    _popups.isAllowMaskTouch = NO;
    [_popups presentWithAnimated:YES completion:NULL];
}

- (void)example3 {
    SnailCurtainView *v= [UIView qzoneCurtain];
    v.delegate = self;
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:v];
    _popups.presentationStyle = PresentationStyleTop;
    _popups.delegate = self;
    [_popups presentInView:self.view withAnimated:YES completion:NULL];
}

- (void)snailQuickMaskPopupsWillPresent:(SnailQuickMaskPopups *)popups {
    self.tableView.scrollEnabled = NO;
}

- (void)snailQuickMaskPopupsWillDismiss:(SnailQuickMaskPopups *)popups {
    self.tableView.scrollEnabled = YES;
}

- (void)example4 {
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:[UIView sharedCurtain]];
    _popups.presentationStyle = PresentationStyleBottom;
    _popups.isAllowPopupsDrag = YES;
    _popups.springDampingRatio = 0.5;
    [_popups presentWithAnimated:YES completion:NULL];
}

- (void)example5 {
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:[UIView sidebar]];
    _popups.presentationStyle = PresentationStyleLeft;
    _popups.isAllowPopupsDrag = YES;
    [_popups presentWithAnimated:YES completion:NULL];
}

- (void)example6 {
    SnailFullScreenView *v = [UIView fullScreen];
    v.delegate = self;
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleWhiteBlur aView:v];
    _popups.isDismissedOppositeDirection = YES;
    _popups.isAllowPopupsDrag = YES;
    [_popups presentWithAnimated:YES completion:NULL];
}

#pragma mark - dismiss

- (void)dismiss {
    [_popups dismissWithAnimated:YES completion:NULL];
}

#pragma mark - SnailCurtainViewDelegate

// 点击了关闭按钮
- (void)curtainViewDidClickClose:(UIButton *)close {
    [self dismiss];
}
// 点击了每个item
- (void)curtainView:(SnailCurtainView *)curtainView didClickItemAtIndex:(NSInteger)index {
    [UIAlertController showAlert:curtainView.itemViews[index].textLabel.text];
}

#pragma mark - SnailFullScreenViewDelegate

- (void)fullScreenViewWhenTapped:(SnailFullScreenView *)fullScreenView {
    [self dismiss];
}

// 点击了广告
- (void)fullScreenViewDidClickAdvertisement:(UIButton *)advertisement {
    [UIAlertController showAlert:@"广告链接"];
}

// 点击了每个item
- (void)fullScreenView:(SnailFullScreenView *)fullView didClickItemAtIndex:(NSInteger)index {
    [UIAlertController showAlert:fullView.itemViews[index].textLabel.text];
}

@end
