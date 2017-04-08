//
//  ViewController+Extension.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "ViewController+Extension.h"

@implementation ViewController (Extension)

- (SnailAlertView *)alertView1 {
    
    SnailAlertView *alertView = [[SnailAlertView alloc] initWithTitle:@"提示" message:@"切换城市失败，是否重试？" fixedWidth:290];
    alertView.linesColor = [UIColor colorWithHexString:@"#FC7541"];
    return alertView;
}

- (SnailAlertView *)alertView2 {
    
    SnailAlertView *alertView = [[SnailAlertView alloc] initWithTitle:@"先来\n告诉我们你的喜好吧" message:@"我们会通过你的喜欢！了解你的喜好并为你推荐作品" fixedWidth:250];
    alertView.titleLabel.textColor = [UIColor r:80 g:72 b:83];
    alertView.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    alertView.messageLabel.textColor = [UIColor blackColor];
    alertView.linesHidden = YES;
    return alertView;
}

- (SnailCurtainView *)curtainView {
    
    SnailCurtainView *curtainView = [[SnailCurtainView alloc] init];
    curtainView.width = [UIScreen width];
    [curtainView.closeButton setImage:[UIImage imageNamed:@"qzone_close"] forState:UIControlStateNormal];
    NSArray *imageNames = @[@"说说", @"照片", @"视频", @"签到", @"大头贴"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:imageNames.count];
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:[@"qzone_" stringByAppendingString:imageName]];
        [models addObject:[SnailIconLabelModel modelWithTitle:imageName image:image]];
    }
    curtainView.models = models;
    return curtainView;
}

- (SnailSidebarView *)sidebarView {
    
    SnailSidebarView *sidebarView = [SnailSidebarView new];
    sidebarView.size = CGSizeMake([UIScreen width] - 90, [UIScreen height]);
    sidebarView.backgroundColor = [UIColor r:24 g:28 b:45 alphaComponent:0.8];
    sidebarView.models = @[@"我的故事", @"消息中心", @"我的收藏", @"近期阅读", @"离线阅读"];
    return sidebarView;
}

- (SnailFullView *)fullView {
    
    SnailFullView *fullView = [[SnailFullView alloc] initWithFrame:self.view.frame];
//    fullView.size = [UIScreen size];
    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"点评", @"好友圈", @"更多", @"音乐", @"商品", @"签到", @"秒拍", @"头条文章", @"红包", @"直播", @"点评"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array) {
        SnailIconLabelModel *item = [SnailIconLabelModel new];
        item.icon = [UIImage imageNamed:[NSString stringWithFormat:@"sina_%@", string]];
        item.text = string;
        [models addObject:item];
    }
    fullView.models = models;
    return fullView;
}

- (SnailSheetView *)sheetViewWithConfig:(id<SnailSheetViewConfig>)config {
    
    CGRect rect = CGRectMake(100, 100, [UIScreen width], 300);
    SnailSheetView *sheet = [[SnailSheetView alloc] initWithConfig:config frame:rect];
    sheet.headerLabel.text = @"此网页由 mp.weixin.qq.com 提供";
    sheet.models = [self sheetModels];
    [sheet autoresizingFlexibleHeight];
    return sheet;
}

#define titleKey @"title"
#define imgNameKey @"imageName"

- (NSArray *)sheetModels {

    NSArray *arr1 = @[@{titleKey   : @"发送给朋友",
                        imgNameKey : @"sheet_Share"},
                      
                      @{titleKey   : @"分享到朋友圈",
                        imgNameKey : @"sheet_Moments"},
                      
                      @{titleKey   : @"收藏",
                        imgNameKey : @"sheet_Collection"},
                      
                      @{titleKey   : @"分享到\n手机QQ",
                        imgNameKey : @"sheet_qq"},
                      
                      @{titleKey   : @"分享到\nQQ空间",
                        imgNameKey : @"sheet_qzone"},
                      
                      @{titleKey   : @"在QQ浏览器\n中打开",
                        imgNameKey : @"sheet_qqbrowser"}];
    
    NSArray *arr2 = @[@{titleKey   : @"查看公众号",
                        imgNameKey : @"sheet_Verified"},
                      
                      @{titleKey   : @"复制链接",
                        imgNameKey : @"sheet_CopyLink"},
                      
                      @{titleKey   : @"复制文本",
                        imgNameKey : @"sheet_CopyText"},
                      
                      @{titleKey   : @"刷新",
                        imgNameKey : @"sheet_Refresh"},
                      
                      @{titleKey   : @"调整字体",
                        imgNameKey : @"sheet_Font"},
                      
                      @{titleKey   : @"投诉",
                        imgNameKey : @"sheet_Complaint"}];
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (NSDictionary *dict in arr1) {
        NSString *text = [dict objectForKey:titleKey];
        NSString *imgName = [dict objectForKey:imgNameKey];
        [array1 addObject:[SnailSheetItemModel modelWithText:text
                                                       image:[UIImage imageNamed:imgName]]];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (NSDictionary *dict in arr2) {
        NSString *text = [dict objectForKey:titleKey];
        NSString *imgName = [dict objectForKey:imgNameKey];
        [array2 addObject:[SnailSheetItemModel modelWithText:text
                                                       image:[UIImage imageNamed:imgName]]];
    }
    
    return [NSMutableArray arrayWithObjects:array1, array2, nil];
}

@end
