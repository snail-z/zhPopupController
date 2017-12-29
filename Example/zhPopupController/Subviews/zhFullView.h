//
//  zhFullView.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROW_COUNT 4 // 每行显示4个
#define ROWS 2      // 每页显示2行
#define PAGES 2     // 共2页

@interface zhFullView : UIView

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<zhImageButtonModel *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<zhImageButton *> *items;

@property (nonatomic, copy) void (^didClickFullView)(zhFullView *fullView);
@property (nonatomic, copy) void (^didClickItems)(zhFullView *fullView, NSInteger index);

- (void)endAnimationsCompletion:(void (^)(zhFullView *fullView))completion; // 动画结束后执行block

@end
