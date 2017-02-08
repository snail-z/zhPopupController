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
#import "SnailTooltipView.h"
#import "SnailSidebarView.h"
#import "SnailCurtainView.h"
#import "SnailFullScreenView.h"

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
    _popups = [SnailQuickMaskPopups popupsWithView:[self cityTooltip] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.transitionStyle = SnailPopupsTransitionStyleSlideInFromTop;
    _popups.dismissesOppositeDirection = YES;
    _popups.shouldDismissOnMaskTouch = NO;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example2 {
    _popups = [SnailQuickMaskPopups popupsWithView:[self weChatTooltip] maskStyle:SnailPopupsMaskStyleBlurTranslucentBlack];
    _popups.presentationStyle = SnailPopupsPresentationStyleCentered;
    _popups.shouldDismissOnMaskTouch = NO;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example3 {
    _popups = [SnailQuickMaskPopups popupsWithView:[self sloganView] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleCentered;
    _popups.transitionStyle = SnailPopupsTransitionStyleSlideInFromTop;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example4 {
    _popups = [SnailQuickMaskPopups popupsWithView:[self qzoneCurtain] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleCurtain;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example5 {
    _popups = [SnailQuickMaskPopups popupsWithView:[self sharedCurtain] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleActionSheet;
    _popups.shouldDismissOnPopupsDrag = YES;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example6 {
    _popups = [SnailQuickMaskPopups popupsWithView:[self sidebarView] maskStyle:SnailPopupsMaskStyleBlackTranslucent];
    _popups.presentationStyle = SnailPopupsPresentationStyleSlideLeft;
    _popups.shouldDismissOnPopupsDrag = YES;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

- (void)example7 {
    _popups = [SnailQuickMaskPopups popupsWithView:[self fullScreenView] maskStyle:SnailPopupsMaskStyleBlurTranslucentWhite];
    _popups.transitionStyle = SnailPopupsTransitionStyleTransformScale;
    _popups.shouldDismissOnPopupsDrag = YES;
    [_popups presentPopupsAnimated:YES completion:NULL];
}

#pragma mark - dismiss

- (void)dismiss {
    [_popups dismissPopupsAnimated:YES completion:NULL];
}

#pragma mark - custom views

- (UIView *)cityTooltip {
    SnailTooltipView *view = [SnailTooltipView new];
    view.width = 280;
    view.titleLabel.text = @"提示";
    view.detailTextLabel.text = @"切换城市失败，是否重试？";
    UIColor *color = [UIColor colorWithHexString:@"#FC7541"];
    [view.components.mainButton setTitle:@"取消" forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:color forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [view.components.cancelButton setTitle:@"重试" forState:UIControlStateNormal];
    [view.components.cancelButton setTitleColor:color forState:UIControlStateNormal];
    [view.components.cancelButton setTitleColor:color forState:UIControlStateHighlighted];
    view.components.verticalLine.backgroundColor = color.CGColor;
    view.components.horizontalLine.backgroundColor = color.CGColor;
    [view.components.mainButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [view reloadLayout];
    return view;
}

- (UIView *)weChatTooltip {
    SnailTooltipView *view = [SnailTooltipView new];
    view.width = 290;
    view.titleLabel.text = @"语音转文字";
    view.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    view.detailTextLabel.text = @"此功能目前仅可以转换普通话，结果仅供参考。";
    view.detailTextLabel.textColor = [UIColor r:160 g:159 b:160];
    view.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    [view.components.mainButton setTitle:@"知道了" forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:[UIColor r:10 g:176 b:2] forState:UIControlStateNormal];
    [view.components.mainButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [view.components.mainButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [view reloadLayout];
    return view;
}

- (UIView *)sloganView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"广告"]];
    imgView.size = CGSizeMake(270, 320);
    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = 4;
    return imgView;
}

- (UIView *)qzoneCurtain {
    SnailCurtainView *view= [SnailCurtainView new];
    view.delegate = self;
    view.width = self.view.bounds.size.width;
    NSArray *imageNames = @[@"说说", @"照片", @"视频", @"签到", @"大头贴"];
    NSMutableArray *items = @[].mutableCopy;
    [imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[SnailImageLabelItem itemWithTitle:imageName image:[UIImage imageNamed:imageName]]];
    }];
    view.items = items;
    return view;
}

- (UIView *)sharedCurtain {
    SnailCurtainView *view= [SnailCurtainView new];
    view.width = self.view.width;
    view.close.hidden = YES;
    view.itemSize = CGSizeMake(50, 80);
    NSArray *imageNames = @[@"微信好友", @"朋友圈", @"新浪微博", @"QQ好友", @"跳转"];
    NSMutableArray *items = @[].mutableCopy;
    [imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[SnailImageLabelItem itemWithTitle:imageName image:[UIImage imageNamed:imageName]]];
    }];
    view.items = items;
    view.height += 45;
    return view;
}

- (UIView *)sidebarView {
    SnailSidebarView *view = [SnailSidebarView new];
    view.size = CGSizeMake([UIScreen width] - 90, [UIScreen height]);
    view.backgroundColor = [UIColor r:24 g:28 b:45 alphaComponent:0.8];
    NSArray *array = @[@"我的故事", @"消息中心", @"我的收藏", @"近期阅读", @"离线阅读"];
    view.items = array;
    return view;
}

- (UIView *)fullScreenView {
    SnailFullScreenView *view = [SnailFullScreenView new];
    view.delegate = self;
    view.size = [UIApplication sharedApplication].keyWindow.size;
    NSMutableArray *items = @[].mutableCopy;
    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"更多", @"点评", @"好友圈", @"音乐", @"商品", @"签到", @"秒拍"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SnailImageLabelItem *item = [SnailImageLabelItem new];
        item.image = [UIImage imageNamed:[NSString stringWithFormat:@"sina_%@", obj]];
        item.title = obj;
        [items addObject:item];
    }];
    view.items = items;
    view.advertisement = [UIImage imageNamed:@"4G LTE"];
    return view;
}

#pragma mark - SnailCurtainViewDelegate

// 点击了关闭按钮
- (void)curtainViewDidClickClose:(UIButton *)close {
    [self dismiss];
}
// 点击了每个item
- (void)curtainView:(SnailCurtainView *)curtainView didClickItemAtIndex:(NSInteger)index {
    NSArray *imageNames = @[@"说说", @"照片", @"视频", @"签到", @"大头贴"];
    [self showAlert:imageNames[index]];
}

#pragma mark - SnailFullScreenViewDelegate

- (void)fullScreenViewWhenTapped:(SnailFullScreenView *)fullScreenView {
    [self dismiss];
}

// 点击了广告
- (void)fullScreenViewDidClickAdvertisement:(UIButton *)advertisement {
    [self showAlert:@" 广告链接"];
}

// 点击了每个item
- (void)fullScreenView:(SnailFullScreenView *)fullView didClickItemAtIndex:(NSInteger)index {
    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"更多", @"点评", @"好友圈", @"音乐", @"商品", @"签到", @"秒拍"];
    [self showAlert:array[index]];
}

#pragma mark - show alert

- (void)showAlert:(NSString *)text {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:text message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
#pragma clang diagnostic pop
    [alert show];
}

@end
