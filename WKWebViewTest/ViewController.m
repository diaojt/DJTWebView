//
//  ViewController.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "ViewController.h"
#import "DJTWebViewVC.h"
#import "DJTWebNavVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
- (IBAction)nextVC:(id)sender {
    
    DJTWebViewVC *webvc = [[DJTWebViewVC alloc] init];
    DJTWebNavVC *webnav = [[DJTWebNavVC alloc] initWithRootViewController:webvc];
    [self presentViewController:webnav animated:YES completion:^{
        
    }];
    
}


@end
