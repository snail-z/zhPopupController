//
//  SnailFullScreenView.m
//  SnailQuickMaskPopupsDemo
//
//  Created by zhanghao on 2017/2/5.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "SnailFullScreenView.h"

@interface SnailFullScreenView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *advertisementView;
@property (nonatomic, strong) UILabel  *dateLabel;
@property (nonatomic, strong) UILabel  *weekLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *closeIcon;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;

@end

@implementation SnailFullScreenView
{
    CGFloat _gap;
    CGFloat _space;
}

- (void)selfWhenTapped:(UITapGestureRecognizer *)recognizer {
    [self endAnimationCompletion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(fullScreenViewWhenTapped:)]) {
            [_delegate fullScreenViewWhenTapped:(SnailFullScreenView *)recognizer.view];
        }
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfWhenTapped:)]];
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:42];
        _dateLabel.textColor = [UIColor r:21 g:21 b:21];
        _dateLabel.textColor = [UIColor blackColor];
        [self addSubview:_dateLabel];
        
        _weekLabel = [UILabel new];
        _weekLabel.numberOfLines = 0;
        _weekLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _weekLabel.textColor = [UIColor r:56 g:56 b:56];
        [self addSubview:_weekLabel];
        
        _advertisementView = [UIButton new];
        [_advertisementView addTarget:self action:@selector(advertisementClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_advertisementView];
        
        _closeButton = [UIButton new];
        _closeButton.backgroundColor = [UIColor whiteColor];
        _closeButton.userInteractionEnabled = NO;
        [_closeButton addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        _closeIcon = [UIButton new];
        _closeIcon.userInteractionEnabled = NO;
        _closeIcon.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_closeIcon setImage:[UIImage imageNamed:@"sina_关闭"] forState:UIControlStateNormal];
        [self addSubview:_closeIcon];
        
        [self setContent];
        [self commonInitialization];
    }
    return self;
}

- (void)setContent {
    NSDate *date = [NSDate date];
    _dateLabel.text = [NSString stringWithFormat:@"%.2ld", (long)date.day];
    _dateLabel.size = [_dateLabel sizeThatFits:CGSizeMake(40, 40)];
    _dateLabel.origin = CGPointMake(15, 50);
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", date.dayFromWeekday, [date stringWithFormat:[NSDate myFormat]]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [paragraphStyle setLineSpacing:5];
    _weekLabel.attributedText = string;
    _weekLabel.size = [_weekLabel sizeThatFits:CGSizeMake(100, 40)];
    _weekLabel.x = _dateLabel.right + 10;
    _weekLabel.centerY = _dateLabel.centerY;
    
    _advertisementView.size = CGSizeMake(130, 100);
    _advertisementView.right = [UIScreen width] - 15;
    _advertisementView.centerY = _dateLabel.bottom;
    
    _closeButton.size = CGSizeMake([UIScreen width], 44);
    _closeButton.bottom = [UIScreen height];
    _closeIcon.size = CGSizeMake(30, 30);
    _closeIcon.center = _closeButton.center;
    [UIView animateWithDuration:0.5 animations:^{
        _closeIcon.transform = CGAffineTransformMakeRotation(M_PI_4);
    } completion:NULL];
}

- (void)setAdvertisement:(UIImage *)advertisement {
    if ([advertisement isKindOfClass:[UIImage class]]) {
        [_advertisementView setImage:advertisement forState:UIControlStateNormal];
    }
}

- (void)advertisementClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(fullScreenViewDidClickAdvertisement:)]) {
        [_delegate fullScreenViewDidClickAdvertisement:sender];
    }
}

- (void)commonInitialization {
    _scrollContainer = [UIScrollView new];
    _scrollContainer.bounces = NO;
    _scrollContainer.scrollEnabled = NO;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.delaysContentTouches = YES;
    _scrollContainer.delegate = self;
    [self addSubview:_scrollContainer];
    
    if (_itemSize.width == 0 && _itemSize.height == 0) { // 设置item的默认宽高
        _itemSize.width = 85;
        _itemSize.height = 115;
    }
    _gap = 15;
    _space = ([UIScreen width] - _rowCount * _itemSize.width) / (_rowCount + 1);
    
    _scrollContainer.size = CGSizeMake([UIScreen width], _itemSize.height * _rows + _gap  + 70);
    _scrollContainer.bottom = [UIScreen height] - _closeButton.height;
    _scrollContainer.contentSize = CGSizeMake(_pages * [UIScreen width], _scrollContainer.height);
    
    _pageViews = @[].mutableCopy;
    for (NSInteger i = 0; i < _pages; i++) {
        UIImageView *pageView = [UIImageView new];
        pageView.size = _scrollContainer.size;
        pageView.x = i * [UIScreen width];
        pageView.userInteractionEnabled = YES;
        [_scrollContainer addSubview:pageView];
        [_pageViews addObject:pageView];
    }
}

- (void)setItems:(NSArray<SnailImageLabelItem *> *)items {
    _itemViews = @[].mutableCopy;
    [_pageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < _rows * _rowCount; i++) {
            NSInteger l = i % _rowCount;
            NSInteger v = i / _rowCount;
            
            SnailImageLabel *item = [SnailImageLabel new];
            item.tag = i + idx * (_rows *_rowCount);
            NSLog(@"item.tag_%lu", item.tag);
            NSLog(@"idx_%lu", idx);
            item.size = _itemSize;
            item.x = _space + (_itemSize.width  + _space) * l;
            item.y = (_itemSize.height + _gap) * v + _gap;
            [imageView addSubview:item];
            [_itemViews addObject:item];
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)]];
            if (item.tag < items.count) {
                [item setItem:items[item.tag]];
                item.imgView.userInteractionEnabled = NO;
                item.textLabel.font = [UIFont systemFontOfSize:14];
                item.textLabel.textColor = [UIColor r:82 g:82 b:82];
            }
            
            item.alpha = 0;
            item.transform = CGAffineTransformMakeTranslation(0, _rows * _itemSize.height);
            [UIView animateWithDuration:0.75 delay:i * 0.03 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                item.transform = CGAffineTransformIdentity;
                item.alpha = 1;
            } completion:NULL];
        }
    }];
}

- (void)itemClicked:(UITapGestureRecognizer *)recognizer  {
    NSMutableArray *values = @[].mutableCopy;
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [self shakeToShow:recognizer.view animationValues:values duration:0.35];
    if (recognizer.view.tag == _rows * _rowCount - 1) {
         [_scrollContainer setContentOffset:CGPointMake([UIScreen width], 0) animated:YES];
    } else {
        if ([_delegate respondsToSelector:@selector(fullScreenView:didClickItemAtIndex:)]) {
            [_delegate fullScreenView:self didClickItemAtIndex:recognizer.view.tag];
        }
    }
}

- (void)shakeToShow:(UIView*)aView animationValues:(NSArray *)values duration:(CFTimeInterval)duration {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)closeClicked:(UIButton *)sender {
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)endAnimationCompletion:(void (^ __nullable)(BOOL finished))completion {
    if (!_closeButton.userInteractionEnabled) {
        [UIView animateWithDuration:0.35 animations:^{
            _closeIcon.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }
    [_itemViews enumerateObjectsUsingBlock:^(SnailImageLabel *item, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:0.25 delay:0.03 * (_itemViews.count - idx) options:UIViewAnimationOptionCurveEaseOut animations:^{
            item.transform = CGAffineTransformMakeTranslation(0, _rows * _itemSize.height);
            item.alpha = 0;
        } completion:^(BOOL finished) {
            if (idx == _itemViews.count - 1) completion(finished);
        }];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x /[UIScreen width] + 0.5;
    _closeButton.userInteractionEnabled = index > 0;
    [_closeIcon setImage:[UIImage imageNamed:(index ? @"sina_返回" : @"sina_关闭")] forState:UIControlStateNormal];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / [UIScreen width];
    _scrollContainer.scrollEnabled = index;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / [UIScreen width];
    _scrollContainer.scrollEnabled = index;
}

@end
