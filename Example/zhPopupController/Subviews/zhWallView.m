//
//  zhWallView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/11/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhWallView.h"

///////////////////////////////////////
// MARK - zhWallViewCollectionCell - //
///////////////////////////////////////

@interface zhWallViewCollectionCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIButton *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

@implementation zhWallViewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = NO;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - WallView item layout / appearance

- (void)setModel:(zhWallItemModel *)model
      withLayout:(zhWallViewLayout *)layout
      appearance:(zhWallViewAppearance *)appearance {
    
    [_imageView setImage:model.image forState:UIControlStateNormal];
    _textLabel.text = model.text;
    
    // appearance
    self.backgroundColor = appearance.itemBackgroundColor;
    _imageView.layer.cornerRadius = appearance.imageViewCornerRadius;
    _imageView.imageView.contentMode = appearance.imageViewContentMode;
    [_imageView setBackgroundImage:[UIImage imageWithColor:appearance.imageViewBackgroundColor] forState:UIControlStateNormal];
    [_imageView setBackgroundImage:[UIImage imageWithColor:appearance.imageViewHighlightedColor] forState:UIControlStateHighlighted];
    _textLabel.backgroundColor = appearance.textLabelBackgroundColor;
    _textLabel.textColor = appearance.textLabelTextColor;
    _textLabel.font = appearance.textLabelFont;
    
    // layout
    _imageView.size = CGSizeMake(layout.imageViewSideLength, layout.imageViewSideLength);
    _imageView.centerX = layout.itemSize.width / 2;
    if (_textLabel.text.length > 0) {
        CGFloat h = layout.itemSize.height - layout.imageViewSideLength - layout.itemSubviewsSpacing;
        CGSize size = [_textLabel sizeThatFits:CGSizeMake(layout.itemSize.width, MAXFLOAT)];
        if (size.height > h) size.height = h;
        _textLabel.size = CGSizeMake(layout.itemSize.width, size.height);
        _textLabel.y = _imageView.bottom + layout.itemSubviewsSpacing;
        _textLabel.centerX = layout.itemSize.width / 2;
    }
}

@end

////////////////////////////
// MARK -zhWallViewCell - //
////////////////////////////

static NSString *zh_CellIdentifier = @"zh_wallViewCollectionCell";

@interface zhWallViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) zhWallViewLayout *wallLayout;
@property (nonatomic, strong) zhWallViewAppearance *wallAppearance;

@property (nonatomic, strong) NSArray<zhWallItemModel *> *models;

@property (nonatomic, weak) zhWallView *wallView;
@property (nonatomic, assign) NSInteger rowIndex;

@end

@implementation zhWallViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                       layout:(zhWallViewLayout *)layout
                   appearance:(zhWallViewAppearance *)appearance {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _wallLayout = layout;
        _wallAppearance = appearance;
        
        self.backgroundColor = appearance.sectionBackgroundColor;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = layout.itemPadding;
        flowLayout.itemSize = layout.itemSize;
        flowLayout.sectionInset = layout.itemEdgeInset;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[zhWallViewCollectionCell class]
            forCellWithReuseIdentifier:zh_CellIdentifier];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    zhWallViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:zh_CellIdentifier forIndexPath:indexPath];
    if (indexPath.row < _models.count) {
        id object = [_models objectAtIndex:indexPath.row];
        NSAssert([object isKindOfClass:[zhWallItemModel class]], @"** zhWallView ** - 传入的数据必须使用zhWallItemModel进行打包，不能是其它对象!");
        [cell setModel:object withLayout:_wallLayout appearance:_wallAppearance];
    }
    cell.imageView.tag = indexPath.row;
    [cell.imageView addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)itemClicked:(UIButton *)sender {
    zhWallView *wallView = self.wallView;
    if ([wallView.delegate respondsToSelector:@selector(wallView:didSelectItemAtIndexPath:)]) {
        NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:self.rowIndex];
        [wallView.delegate wallView:wallView didSelectItemAtIndexPath:_indexPath];
    }
}

#pragma mark - setter

- (void)setModels:(NSArray<zhWallItemModel *> *)models {
    _models = models;
    [_collectionView reloadData];
}

@end

// MARK - zhWallItemModel -

@implementation zhWallItemModel

+ (instancetype)modelWithImage:(UIImage *)image text:(NSString *)text {
    zhWallItemModel *model = [[zhWallItemModel alloc] init];
    model.image = image;
    model.text = text;
    return model;
}

@end

////////////////////////
// MARK -zhWallView - //
////////////////////////

@interface zhWallView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation zhWallView

- (instancetype)init  {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:240 / 255. green:240 / 255. blue:240 / 255. alpha:0xff / 255.];
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.delaysContentTouches = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
        _wallHeaderLabel = [self labelWithTextColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12] action:@selector(headerClicked)];
        _tableView.tableHeaderView = _wallHeaderLabel;
        
        _wallFooterLabel = [self labelWithTextColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17] action:@selector(footerClicked)];
        _wallFooterLabel.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = _wallFooterLabel;
    }
    return self;
}

- (UILabel *)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font action:(nullable SEL)action {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.text = @"zhWallView";
    label.textColor = textColor;
    label.font = font;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    return label;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self wallSectionHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    zhWallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zh_wallViewCell"];
    if (!cell) {
        cell = [[zhWallViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zh_wallViewCell" layout:[self layout] appearance:[self appearance]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.wallView = self;
    cell.rowIndex = indexPath.row;
    id object = [_models objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSArray class]]) {
        cell.models = (NSArray *)object;
    }
    return cell;
}

#pragma mark - Gesture block

- (void)headerClicked {
    if (self.didClickHeader) self.didClickHeader(self);
}

- (void)footerClicked {
    if (nil != self.didClickFooter) self.didClickFooter(self);
}

#pragma mark - <zhSheetViewConfigDelegate>

- (zhWallViewLayout *)layout {
    id <zhWallViewDelegateConfig> config = (id <zhWallViewDelegateConfig> )self.delegate;
    if ([config respondsToSelector:@selector(layoutOfItemInWallView:)]) {
        return [config layoutOfItemInWallView:self];
    }
    return [[zhWallViewLayout alloc] init];
}

- (zhWallViewAppearance *)appearance {
    id <zhWallViewDelegateConfig> config = (id <zhWallViewDelegateConfig> )self.delegate;
    if ([config respondsToSelector:@selector(appearanceOfItemInWallView:)]) {
        return [config appearanceOfItemInWallView:self];
    }
    return [[zhWallViewAppearance alloc] init];
}

#pragma mark - Setter

- (void)setModels:(NSArray<NSArray<zhWallItemModel *> *> *)models {
    _models = models;
    [self reloadTableViewHeaderAndFooterHeight];
    [_tableView reloadData];
}

- (void)reloadTableViewHeaderAndFooterHeight {
    _tableView.tableHeaderView.size = CGSizeMake(self.width, self.layout.wallHeaderHeight);
    _tableView.tableFooterView.size = CGSizeMake(self.width, self.layout.wallFooterHeight);
}

#pragma mark - Wall section height

- (CGFloat)wallSectionHeight {
    return self.layout.itemEdgeInset.top + self.layout.itemEdgeInset.bottom + self.layout.itemSize.height;
}

- (void)autoAdjustFitHeight {
    CGFloat totalHeight = [self wallSectionHeight] * _models.count;
    if (!CGRectEqualToRect(CGRectZero, _wallHeaderLabel.frame)) {
        totalHeight += self.layout.wallHeaderHeight;
    }
    if (!CGRectEqualToRect(CGRectZero, _wallFooterLabel.frame)) {
        totalHeight += self.layout.wallFooterHeight;
    }
    totalHeight += zh_safeAreaHeight();
    self.height = _tableView.height = totalHeight;
}

@end
