//
//  UIAlertController+DJTWebAlert.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/30.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "UIAlertController+DJTWebAlert.h"
#import "NSObject+DJTRuntime.h"
@interface UIViewController (DJTKit)
- (UIViewController *)djt_currentViewController;
@end


@implementation UIAlertController (DJTWebAlert)

+ (BOOL)isAlert
{
    for (UIWindow *window in [UIApplication sharedApplication].windows)
    {
        NSArray *subviews = window.subviews;
        if([subviews count] > 0)
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]] || [[subviews objectAtIndex:0] isKindOfClass:[UIAlertController class]]) {
                return YES;
            }
    }
    
    return NO;
}

+ (void)djt_alertWithTitle:(NSString *)title
                   message:(NSString *)message
                completion:(void(^)(void))completion
{
    UIAlertController *showSecreetDefault = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionTrue = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion ? completion() : NULL;
    }];
    [showSecreetDefault addAction:actionTrue];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showSecreetDefault animated:YES completion:nil];
    });
    
}

+ (void)djt_alertWithTitle:(NSString *)title
                   message:(NSString *)message
              action1Title:(NSString *)action1Title
              action2Title:(NSString *)action2Title
                   action1:(void (^)(void))action1
                   action2:(void (^)(void))action2
{
    UIAlertController *showSecreetDefault = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:action1Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        action1 ? action1():NULL;
    }];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:action2Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        action2 ? action2() : NULL;
    }];
    [showSecreetDefault addAction:actionOne];
    [showSecreetDefault addAction:actionTwo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showSecreetDefault animated:YES completion:nil];
    });
    
}

+ (nonnull instancetype)djt_actionSheetShowInViewController:(UIViewController *)viewController
                                                      title:(NSString *)title
                                                    message:(NSString *)message
                                           buttonTitleArray:(NSArray *)buttonTitleArray
                                      buttonTitleColorArray:(NSArray<UIColor *> *)buttonTitleColorArray
                         popoverPresentationControllerBlock:(djt_alertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                                                      block:(djt_alertControllerButtonActionBlock)btnActionBlock
{
    return [self djt_alertControllerShowInViewController:viewController
                                                   title:title
                                         attributedTitle:nil
                                                 message:message
                                       attributedMessage:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet
                                        buttonTitleArray:buttonTitleArray
                                   buttonTitleColorArray:buttonTitleColorArray
                           buttonEnabledNoWithTitleArray:nil
                               textFieldPlaceholderArray:nil
                       textFieldConfigurationActionBlock:nil
                      popoverPresentationControllerBlock:popoverPresentationControllerBlock
                                                   block:btnActionBlock];
    
}


+ (instancetype)djt_alertControllerShowInViewController:(UIViewController *)viewController
                                                  title:(NSString *)title
                                        attributedTitle:(nullable NSMutableAttributedString *)attributedTitle
                                                message:(NSString *)message
                                      attributedMessage:(nullable NSMutableAttributedString *)attributedMessage
                                         preferredStyle:(UIAlertControllerStyle)preferredStyle
                                       buttonTitleArray:(nullable NSArray *)buttonTitleArray
                                  buttonTitleColorArray:(nullable NSArray<UIColor *>*)buttonTitleColorArray
                          buttonEnabledNoWithTitleArray:(NSArray <NSString *>*_Nullable)buttonEnableNoWithTitleArray
                              textFieldPlaceholderArray:(NSArray <NSString *> *_Nullable)textFieldPlaceholderArray
                      textFieldConfigurationActionBlock:(nullable djt_alertControllerTextFieldConfigurationActionBlock)textFieldConfActionBlock
                     popoverPresentationControllerBlock:(nullable djt_alertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock block:(djt_alertControllerButtonActionBlock)actionBlock
{
    
    UIAlertController *strongController = [self alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:preferredStyle];
    __weak UIAlertController *alertController = strongController;
    //
    if (buttonTitleArray)
    {
        for (NSUInteger i = 0; i < buttonTitleArray.count; i++)
        {
            NSString *buttonTitle = buttonTitleArray[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                if (actionBlock){
                    actionBlock(alertController, action, i);
                }
            }];
            [alertController addAction:action];
            for (NSInteger j = 0; j < buttonEnableNoWithTitleArray.count; j ++)
            {
                if ([buttonEnableNoWithTitleArray[j] isEqualToString:buttonTitle])
                {
                    action.enabled = NO;
                }
            }
            if (buttonTitleColorArray)
            {
                [strongController setAlertWithAlert:strongController
                             mutableAttributedTitle:attributedTitle
                           mutableAttributedMessage:attributedMessage
                                             Action:action
                                   buttonTitleColor:buttonTitleColorArray[i]];
            }
        }
    }
    //
    if (textFieldPlaceholderArray)
    {
        for (NSInteger i = 0; i < textFieldPlaceholderArray.count; i++)
        {
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
                textField.placeholder = textFieldPlaceholderArray[i];
                if (textFieldConfActionBlock)
                {
                    textFieldConfActionBlock(textField, i);
                }
            }];
        }
    }
    //
    if (preferredStyle == UIAlertControllerStyleActionSheet)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取 消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alertController addAction:action];
    }
    //
    if (popoverPresentationControllerBlock)
    {
        popoverPresentationControllerBlock(alertController.popoverPresentationController);
    }
    
    [viewController.djt_currentViewController presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
    
}


- (void)setAlertWithAlert:(UIAlertController * __nonnull )alert
   mutableAttributedTitle:(NSMutableAttributedString *)mutableAttributedTitle
 mutableAttributedMessage:(nullable NSMutableAttributedString *)mutableAttributedMessage
                   Action:(UIAlertAction * __nonnull )action
         buttonTitleColor:(UIColor *)buttonTitleColor
{
    
    //获得成员变量
    NSArray *ivarListArray = [[UIAlertAction class] djt_ivarList];
    for (NSUInteger i = 0; i < ivarListArray.count; i++) {
        NSString *ivarName = ivarListArray[i];
        if ([ivarName isEqualToString:@"_titleTextColor"]) {
            [action setValue:buttonTitleColor forKey:@"titleTextColor"];
        }
    }
    //改变显示提示字体颜色
    NSArray *propertysListArray2 = [[UIAlertController class] djt_ivarList];
    for (NSInteger i = 0; i < propertysListArray2.count; i++) {
        NSString *ivarName = propertysListArray2[i];
        if ([ivarName isEqualToString:@"_attributedTitle"])
        {
            [alert setValue:mutableAttributedTitle forKey:@"attributedTitle"];
        }
        if ([ivarName isEqualToString:@"_attributedMessage"]) {
            [alert setValue:mutableAttributedMessage forKey:@"attributedMessage"];
        }
    }
}

@end


@implementation UIViewController(DJTKit)

- (UIViewController *)djt_currentViewController
{
    UIViewController *topVC = self;
    UIViewController *above;
    while ((above = topVC.presentedViewController)) {
        topVC = above;
    }
    return topVC;
}

@end


