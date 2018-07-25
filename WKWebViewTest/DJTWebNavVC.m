//
//  DJTWebNavVC.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTWebNavVC.h"
@interface DJTWebNavVC ()

@end

@implementation DJTWebNavVC

+ (void)initialize
{
    UIImage *bg = [UIImage imageNamed:@"navigationbarBackgroundWhite"];
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.bounds = CGRectMake(0, 0, 70, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}


@end
