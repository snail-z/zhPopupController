//
//  zhFullView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhFullView.h"

@interface zhFullView () <UIScrollViewDelegate> {
    CGFloat _gap, _space;
}
@property (nonatomic, strong) UILabel  *dateLabel;
@property (nonatomic, strong) UILabel  *weekLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *closeIcon;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;

@end

@implementation zhFullView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewClicked:)]];
        
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
        
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {
    NSDate *date = [NSDate date];
    _dateLabel.text = [NSString stringWithFormat:@"%.2ld", (long)date.day];
    _dateLabel.size = [_dateLabel sizeThatFits:CGSizeMake(40, 40)];
    _dateLabel.origin = CGPointMake(15, 65);
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", date.dayFromWeekday, [NSDate stringWithFormat:[NSDate myFormat]]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [paragraphStyle setLineSpacing:5];
    _weekLabel.attributedText = string;
    _weekLabel.size = [_weekLabel sizeThatFits:CGSizeMake(100, 40)];
    _weekLabel.x = _dateLabel.right + 10;
    _weekLabel.centerY = _dateLabel.centerY;
    
    _closeButton.size = CGSizeMake([UIScreen width], 44);
    _closeButton.bottom = [UIScreen height] - zh_safeAreaHeight();
    _closeIcon.size = CGSizeMake(30, 30);
    _closeIcon.center = _closeButton.center;
    
    _scrollContainer = [UIScrollView new];
    _scrollContainer.bounces = NO;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.delaysContentTouches = YES;
    _scrollContainer.delegate = self;
    [self addSubview:_scrollContainer];
    
    _itemSize = CGSizeMake(60, 95);
    _gap = 15;
    _space = ([UIScreen width] - ROW_COUNT * _itemSize.width) / (ROW_COUNT + 1);
    
    _scrollContainer.size = CGSizeMake([UIScreen width], _itemSize.height * ROWS + _gap  + 150);
    _scrollContainer.bottom = _closeButton.y;
    _scrollContainer.contentSize = CGSizeMake(PAGES * [UIScreen width], _scrollContainer.height);
    
    _pageViews = @[].mutableCopy;
    for (NSInteger i = 0; i < PAGES; i++) {
        UIImageView *pageView = [UIImageView new];
        pageView.size = _scrollContainer.size;
        pageView.x = i * [UIScreen width];
        pageView.userInteractionEnabled = YES;
        [_scrollContainer addSubview:pageView];
        [_pageViews addObject:pageView];
    }
}

- (void)setModels:(NSArray<zhImageButtonModel *> *)models {
    
    _items = @[].mutableCopy;
    [_pageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < ROWS * ROW_COUNT; i++) {
            NSInteger l = i % ROW_COUNT;
            NSInteger v = i / ROW_COUNT;
            
            zhImageButton *item = [zhImageButton buttonWithType:UIButtonTypeCustom];
            [imageView addSubview:item];
            [_items addObject:item];
            item.tag = i + idx * (ROWS *ROW_COUNT);
            if (item.tag < models.count) {
                zhImageButtonModel *model = [models objectAtIndex:item.tag];
                item.userInteractionEnabled =  YES;
                item.titleLabel.font = [UIFont systemFontOfSize:14];
                [item setTitleColor:[UIColor r:82 g:82 b:82] forState:UIControlStateNormal];
                [item setTitle:model.text forState:UIControlStateNormal];
                [item setImage:model.icon forState:UIControlStateNormal];
                [item imagePosition:zhImageButtonPositionTop spacing:10 imageViewResize:CGSizeMake(45, 45)];
                item.size = _itemSize;
                item.x = _space + (_itemSize.width  + _space) * l;
                item.y = (_itemSize.height + _gap) * v + _gap + 100;
                [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
    
    [self startAnimationsCompletion:NULL];
}

- (void)fullViewClicked:(UITapGestureRecognizer *)recognizer {
    __weak typeof(self) _self = self;
    [self endAnimationsCompletion:^(zhFullView *fullView) {
        if (nil != self.didClickFullView) {
            _self.didClickFullView((zhFullView *)recognizer.view);
        }
    }];
}

- (void)itemClicked:(UIButton *)sender  {
    if (ROWS * ROW_COUNT - 1 == sender.tag) {
        [_scrollContainer setContentOffset:CGPointMake([UIScreen width], 0) animated:YES];
    } else {
        if (nil != self.didClickItems) {
            self.didClickItems(self, sender.tag);
        }
    }
}

- (void)closeClicked:(UIButton *)sender {
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x /[UIScreen width] + 0.5;
    _closeButton.userInteractionEnabled = index > 0;
    [_closeIcon setImage:[UIImage imageNamed:(index ? @"sina_返回" : @"sina_关闭")] forState:UIControlStateNormal];
}

- (void)startAnimationsCompletion:(void (^ __nullable)(BOOL finished))completion {
    
    [UIView animateWithDuration:0.5 animations:^{
        _closeIcon.transform = CGAffineTransformMakeRotation(M_PI_4);
    } completion:NULL];
    
    [_items enumerateObjectsUsingBlock:^(zhImageButton *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger firstPageCount = ROW_COUNT * ROWS;
        if (idx < firstPageCount) { // 只需首页的item做动画即可
            item.alpha = 0;
            item.transform = CGAffineTransformMakeTranslation(0, ROWS * _itemSize.height);
            [UIView animateWithDuration:0.55
                                  delay:idx * 0.035
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 item.alpha = 1;
                                 item.transform = CGAffineTransformIdentity;
                             } completion:completion];
        }
    }];
}

- (void)endAnimationsCompletion:(void (^)(zhFullView *))completion {
    NSInteger flag = _scrollContainer.contentOffset.x /[UIScreen width] + 0.5;
    
    if (!_closeButton.userInteractionEnabled) {
        [UIView animateWithDuration:0.35 animations:^{
            _closeIcon.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }
    
    [_items enumerateObjectsUsingBlock:^(zhImageButton * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger pageCount = ROW_COUNT *ROWS;
        NSInteger startIdx = (pageCount * flag);
        NSInteger endIdx = startIdx + pageCount;
        
        BOOL shouldAnimated = NO;
        if (idx >= startIdx && idx < endIdx) {
            shouldAnimated = YES;
        }
    
        if (shouldAnimated) {
            [UIView animateWithDuration:0.25
                                  delay:0.02f * (_items.count - idx)
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 item.transform = CGAffineTransformMakeTranslation(0, ROWS * _itemSize.height+50);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     if (idx == endIdx - 1) {
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             completion(self);
                                         });
                                     }
                                 }
                             }];
        }
    }];
}

@end
