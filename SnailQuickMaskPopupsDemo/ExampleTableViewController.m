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

@interface ExampleTableViewController () <SnailCurtainViewDelegate, SnailFullScreenViewDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *styles;
@property (nonatomic, strong) NSMutableArray *selNames;
@property (nonatomic, strong) SnailQuickMaskPopups *popups;

@end

@implementation ExampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar sl_setBackgroundColor:[UIColor r:122 g:190 b:95]];
    [self.tableView setRowHeight:75];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _colors = @[@"#FC7541",
                @"#0AB002",
                @"#EF6656",
                @"#707070",
                @"#7ABE64",
                @"#5BA9F8",
                @"#E2547D"];
    _styles = @[@"58City style",
                @"WeChat style",
                @"Slogan style",
                @"Qzone style",
                @"Shared style",
                @"Sidebar style",
                @"Full screen style"];
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
    _popups = [SnailQuickMaskPopups popupsWithView:v maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.transitionStyle = SnailPopupsTransitionStyleSlideInFromTop;
    _popups.dismissesOppositeDirection = YES;
    _popups.shouldDismissOnMaskTouch = NO;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example2 {
    SnailTooltipView *v = [UIView wechatTooltip];
    [v.components.mainButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _popups = [SnailQuickMaskPopups popupsWithView:v maskStyle:SnailPopupsMaskStyleBlurTranslucentBlack];
    _popups.presentationStyle = SnailPopupsPresentationStyleCentered;
    _popups.shouldDismissOnMaskTouch = NO;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example3 {
    _popups = [SnailQuickMaskPopups popupsWithView:[UIImageView slogan] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleCentered;
    _popups.transitionStyle = SnailPopupsTransitionStyleSlideInFromTop;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example4 {
    SnailCurtainView *v= [UIView qzoneCurtain];
    v.delegate = self;
    _popups = [SnailQuickMaskPopups popupsWithView:v maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleCurtain;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example5 {
    _popups = [SnailQuickMaskPopups popupsWithView:[UIView sharedCurtain] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleActionSheet;
    _popups.shouldDismissOnPopupsDrag = YES;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example6 {
    _popups = [SnailQuickMaskPopups popupsWithView:[UIView sidebar] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleSlideLeft;
    _popups.shouldDismissOnPopupsDrag = YES;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example7 {
    SnailFullScreenView *v = [UIView fullScreen];
    v.delegate = self;
    _popups = [SnailQuickMaskPopups popupsWithView:v maskStyle:SnailPopupsMaskStyleBlurTranslucentWhite];
    _popups.transitionStyle = SnailPopupsTransitionStyleTransformScale;
    _popups.shouldDismissOnPopupsDrag = YES;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

#pragma mark - dismiss

- (void)dismiss {
    [_popups dismissPopupsAnimated:YES completion:NULL];
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
