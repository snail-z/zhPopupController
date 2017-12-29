//
//  zh_ViewController+Extension.m
//  zhPopupController
//
//  Created by zhanghao on 2016/8/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zh_SecondViewController+Extension.h"

@implementation zh_SecondViewController (Extension)

- (zhAlertView *)alertView1 {
    zhAlertView *alertView = [[zhAlertView alloc] initWithTitle:@"提示"
                                                        message:@"切换城市失败，是否重试？"
                                                  constantWidth:290];
    return alertView;
}

- (zhAlertView *)alertView2 {
    zhAlertView *alertView = [[zhAlertView alloc] initWithTitle:@"先来\n告诉我们你的喜好吧"
                                                        message:@"我们会通过你的喜欢！了解你的喜好并为你推荐作品"
                                                  constantWidth:250];
    alertView.titleLabel.textColor = [UIColor r:80 g:72 b:83];
    alertView.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    alertView.messageLabel.textColor = [UIColor blackColor];
    return alertView;
}

- (zhOverflyView *)overflyView {
    
    NSString *title1 = @"通知", *title2 = @"一大波福利即将到来~";
    NSString *text = [NSString stringWithFormat:@"%@\n%@", title1, title2];
    NSMutableAttributedString *attiTitle = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attiTitle addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[text rangeOfString:title1]];
    [attiTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[text rangeOfString:title1]];
    
    [attiTitle addAttribute:NSForegroundColorAttributeName value:[UIColor r:236 g:78 b:39] range:[text rangeOfString:title2]];
    [attiTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[text rangeOfString:title2]];
    
    [attiTitle addAttribute:NSKernAttributeName value:@1.2 range:[text rangeOfString:title2]];//字距调整
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attiTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];//行距调整
    
    NSString *msg = @"     两国元首重点就当前朝鲜半岛局势交换了看法。习近平强调，中方坚定不移致力于实现朝鲜半岛无核化，维护国际核不扩散体系";
    for (int i = 0; i < 3; i++) {
        msg = [msg stringByAppendingString:msg];
    }
    
    NSMutableAttributedString *attiMessage = [[NSMutableAttributedString alloc] initWithString:msg];
    [attiMessage addAttribute:NSKernAttributeName value:@1.1 range:NSMakeRange(0, [msg length])];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:7];
    [attiMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [msg length])];
    [attiMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [msg length])];
    [attiMessage addAttribute:NSForegroundColorAttributeName value:[UIColor r:49 g:49 b:39      ] range:NSMakeRange(0, [msg length])];
    
    CGFloat fac = 475; // 已知透明区域高度
    UIImage *image = [UIImage imageNamed:@"fire_arrow"];

    zhOverflyView *overflyView = [[zhOverflyView alloc]
                                  initWithFlyImage:image
                                  highlyRatio:(fac / image.size.height)
                                  attributedTitle:attiTitle
                                  attributedMessage:attiMessage
                                  constantWidth:290];
    overflyView.layer.cornerRadius = 4;
    overflyView.messageEdgeInsets = UIEdgeInsetsMake(10, 22, 10, 22);
    overflyView.titleLabel.backgroundColor = [UIColor whiteColor];
    overflyView.titleLabel.textAlignment = NSTextAlignmentCenter;
    overflyView.splitLine.hidden = YES;
    [overflyView reloadAllComponents];
    return overflyView;
}

- (zhCurtainView *)curtainView {
    
    zhCurtainView *curtainView = [[zhCurtainView alloc] init];
    curtainView.width = [UIScreen width];
    [curtainView.closeButton setImage:[UIImage imageNamed:@"qzone_close"] forState:UIControlStateNormal];
    NSArray *imageNames = @[@"说说", @"照片", @"视频", @"签到", @"大头贴"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:imageNames.count];
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:[@"qzone_" stringByAppendingString:imageName]];
        [models addObject:[zhImageButtonModel modelWithTitle:imageName image:image]];
    }
    curtainView.models = models;
    return curtainView;
}

- (zhSidebarView *)sidebarView {
    
    zhSidebarView *sidebarView = [zhSidebarView new];
    sidebarView.size = CGSizeMake([UIScreen width] - 90, [UIScreen height]);
    sidebarView.backgroundColor = [UIColor r:24 g:28 b:45 alphaComponent:0.8];
    sidebarView.models = @[@"我的故事", @"消息中心", @"我的收藏", @"近期阅读", @"离线阅读"];
    return sidebarView;
}

- (zhFullView *)fullView {
    
    zhFullView *fullView = [[zhFullView alloc] initWithFrame:self.view.frame];
    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"点评", @"好友圈", @"更多", @"音乐", @"商品", @"签到", @"秒拍", @"头条文章", @"红包", @"直播", @"点评"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array) {
        zhImageButtonModel *item = [zhImageButtonModel new];
        item.icon = [UIImage imageNamed:[NSString stringWithFormat:@"sina_%@", string]];
        item.text = string;
        [models addObject:item];
    }
    fullView.models = models;
    return fullView;
}

- (zhWallView *)wallView {
    CGRect rect = CGRectMake(100, 100, [UIScreen width], 300);
    zhWallView *wallView = [[zhWallView alloc] initWithFrame:rect];
    wallView.wallHeaderLabel.text = @"此网页由 mp.weixin.qq.com 提供";
    wallView.wallFooterLabel.text = @"取消";
    wallView.models = [self wallModels];
    [wallView autoAdjustFitHeight];
    return wallView;
}

#define titleKey @"title"
#define imgNameKey @"imageName"

- (NSArray *)wallModels {
    
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
        [array1 addObject:[zhWallItemModel modelWithImage:[UIImage imageNamed:imgName] text:text]];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (NSDictionary *dict in arr2) {
        NSString *text = [dict objectForKey:titleKey];
        NSString *imgName = [dict objectForKey:imgNameKey];
        [array2 addObject:[zhWallItemModel modelWithImage:[UIImage imageNamed:imgName] text:text]];
    }
    
    return [NSMutableArray arrayWithObjects:array1, array2, nil];
}

@end
