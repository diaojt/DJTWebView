//
//  UIAlertController+DJTWebAlert.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/30.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^djt_alertControllerButtonActionBlock)(UIAlertController * __nonnull alertController, UIAlertAction * __nonnull action, NSInteger buttonIndex);

typedef void (^djt_alertControllerPopoverPresentationControllerBlock) (UIPopoverPresentationController * __nonnull popover);

typedef void (^djt_alertControllerTextFieldConfigurationActionBlock)(UITextField * _Nullable textField, NSUInteger index);


@interface UIAlertController (DJTWebAlert)

+ (BOOL)isAlert;


+ (NSArray *)djt_ivarList;


+ (void)djt_alertWithTitle:(NSString *)title
                   message:(NSString *)message
                completion:(void(^)(void))completion;


+ (void)djt_alertWithTitle:(NSString *)title
                  message:(NSString *)message
             action1Title:(NSString *)action1Title
             action2Title:(NSString *)action2Title
                  action1:(void(^)(void))action1
                  action2:(void(^)(void))action2;



/**
 创建一个 UIAlertController-ActionSheet

 @param viewController 显示的 vc
 @param title 显示的title
 @param message message
 @param buttonTitleArray 按钮数组
 @param buttonTitleColorArray 按钮颜色数组，默认：系统蓝色，如果颜色数组个数小于title数组个数，则全为默认蓝色
 @param popoverPresentationControllerBlock  popoverPresentationControllerBlock
 @param btnActionBlock actionBlock
 @return UIAlertController-ActionSheet
 */
+ (nonnull instancetype)djt_actionSheetShowInViewController:(nonnull UIViewController *)viewController
                                                      title:(nullable NSString *)title
                                                    message:(nullable NSString *)message
                                           buttonTitleArray:(nullable NSArray *)buttonTitleArray
                                      buttonTitleColorArray:(nullable NSArray<UIColor *>*)buttonTitleColorArray
                         popoverPresentationControllerBlock:(nullable djt_alertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock block:(nullable djt_alertControllerButtonActionBlock)btnActionBlock;

@end
