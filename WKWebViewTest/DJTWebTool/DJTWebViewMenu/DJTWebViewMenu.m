//
//  DJTWebViewMenu.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/31.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTWebViewMenu.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DJTWebViewMenu

+ (instancetype)shareInstance
{
    static DJTWebViewMenu *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[DJTWebViewMenu alloc] init];
    });
    
    return menu;
}


- (void)defaultMenuShowInViewController:(nonnull UIViewController *)viewController
                                  title:(nullable NSString *)title
                                message:(nullable NSString *)message
                       buttonTitleArray:(nullable NSArray *)buttonTitleArray
                  buttonTitleColorArray:(nullable NSArray <UIColor *>*)buttonTitleColorArray
     popoverPresentationControllerBlock:(nullable djt_alertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                                  block:(nullable djt_alertControllerButtonActionBlock)btnActionBlock

{
    
    [UIAlertController djt_actionSheetShowInViewController:viewController title:title message:message buttonTitleArray:buttonTitleArray buttonTitleColorArray:buttonTitleColorArray popoverPresentationControllerBlock:popoverPresentationControllerBlock block:btnActionBlock];

}


- (void)customMenuShowInViewController:(nonnull UIViewController *)viewController
                                 title:(nullable NSString *)title
                               message:(nullable NSString *)message
                      buttonTitleArray:(nullable NSArray *)buttonTitleArry
                 buttonTitleColorArray:(nullable NSArray<UIColor *> *)buttonTitleColorArray
    popoverPresentationControllerBlock:(nullable djt_alertControllerPopoverPresentationControllerBlock)popoverPesentationControllerBlock
                                 block:(nullable djt_alertControllerButtonActionBlock)btnActionBlock
{
    [UIAlertController djt_actionSheetShowInViewController:viewController title:title message:message buttonTitleArray:buttonTitleArry buttonTitleColorArray:buttonTitleColorArray popoverPresentationControllerBlock:popoverPesentationControllerBlock block:btnActionBlock];
}

@end
NS_ASSUME_NONNULL_END
