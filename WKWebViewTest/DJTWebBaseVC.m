//
//  DJTWebBaseVC.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTWebBaseVC.h"

@interface DJTWebBaseVC ()

@end

@implementation DJTWebBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}



- (void)setupNav
{
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    [titleView setBackgroundColor:[UIColor blackColor]];
//    self.navigationItem.titleView = titleView;
//    self.navigationItem.title = @"Test";
    
    //大标题模式
//    self.navigationController.navigationBar.prefersLargeTitles = YES;

    //左边关闭按钮
    UIButton *leftBarButton = [[UIButton alloc] init];
    [leftBarButton setImage:[UIImage imageNamed:@"mine-sun-icon"] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:@"mine-sun-icon-click"] forState:UIControlStateHighlighted];
    leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBarButton setTitle:@"关闭" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [leftBarButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    leftBarButton.bounds = CGRectMake(0, 0, 70, 30);
    leftBarButton.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    leftBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
    
    //右边选项按钮
    UIButton *rightBarButton = [[UIButton alloc] init];
    [rightBarButton setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [rightBarButton setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
//    rightBarButton.backgroundColor = [UIColor redColor];
    [rightBarButton addTarget:self action:@selector(doOperation) forControlEvents:UIControlEventTouchUpInside];
    rightBarButton.bounds = CGRectMake(0, 0, 70, 30);
    rightBarButton.contentEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


- (void)doOperation
{
    
}

@end
