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

/**
 状态栏样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)setupNav
{
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    [titleView setBackgroundColor:[UIColor blackColor]];
//    self.navigationItem.titleView = titleView;
//    self.navigationItem.title = @"Test";
    
    //大标题模式
//    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    //左边 close 和 back 按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem,self.closeItem];
    
    //右边选项按钮
    self.navigationItem.rightBarButtonItem = self.menuItem;
    
}




#pragma mark - init
- (UIBarButtonItem *)backItem
{
    if (!_backItem)
    {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        backBtn.bounds = CGRectMake(0, 0, 30, 30);
        //backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        //backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//[backBtn setTitle:@"关闭" forState:UIControlStateNormal];
//        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backItem.customView = backBtn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem)
    {
        _closeItem = [[UIBarButtonItem alloc] init];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"ic_closed"] forState:UIControlStateNormal];
        [closeBtn setImage:[UIImage imageNamed:@"ic_closed"] forState:UIControlStateHighlighted];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.bounds = CGRectMake(0, 0, 30, 30);
        _closeItem.customView = closeBtn;
    }
    return _closeItem;
}


- (UIBarButtonItem *)menuItem
{
    if (!_menuItem)
    {
        _menuItem = [[UIBarButtonItem alloc] init];

        //右边选项按钮
        UIButton *menuBtn = [[UIButton alloc] init];
        [menuBtn setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
        [menuBtn setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
        [menuBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.bounds = CGRectMake(0, 0, 70, 30);
        menuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
        _menuItem.customView = menuBtn;
    }
    
    return _menuItem;
}



- (void)close
{
    NSLog(@"DJTWebBaseVC-----close");
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)back
{
    NSLog(@"DJTWebBaseVC-----back");
}


- (void)showMenu
{
    NSLog(@"DJTWebBaseVC-----showMenu");
    
}

@end
