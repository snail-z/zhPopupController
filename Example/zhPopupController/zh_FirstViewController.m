//
//  zh_FirstViewController.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zh_FirstViewController.h"
#import "zh_SecondViewController.h"

@interface zh_FirstViewController ()

@end

@implementation zh_FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zh_statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar zh_setBackgroundColor:[UIColor colorWithHexString:@"569EED"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:25];
    self.navigationController.navigationBar.titleTextAttributes = textAttrs;
    self.title = @"zhPopupController";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    NSMutableDictionary *backTextAttrs = [NSMutableDictionary dictionary];
    backTextAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:20];
    [backItem setTitleTextAttributes:backTextAttrs forState:UIControlStateNormal];
    [backItem setTitleTextAttributes:backTextAttrs forState:UIControlStateHighlighted];
    backItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backItem;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 7;
    button.backgroundColor = [UIColor colorWithHexString:@"569EED"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:22];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button zh_makeConstraints:^(SnailConstraintMaker *make) {
        [make.width zh_equalTo:150];
        [make.height zh_equalTo:55];
        [make.center equalTo:self.view];
    }];
}

- (void)next {
    zh_SecondViewController *vc = [zh_SecondViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
