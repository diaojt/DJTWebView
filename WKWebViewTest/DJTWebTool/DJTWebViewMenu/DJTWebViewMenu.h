//
//  DJTWebViewMenu.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/31.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIAlertController+DJTWebAlert.h"

typedef NS_ENUM(NSInteger, DJTWebViewMenuType){
    OPEN_SAFARI,
    COPY_URL,
    RELOAD_URL,
    SHARE_URL,
};

NS_ASSUME_NONNULL_BEGIN
@interface DJTWebViewMenu : NSObject

@property (nonatomic, assign) BOOL defaultType;

+ (instancetype)shareInstance;

- (void)defaultMenuShowInViewController:(nonnull UIViewController *)viewController
                                  title:(nullable NSString *)title
                                message:(nullable NSString *)message
                       buttonTitleArray:(nullable NSArray *)buttonTitleArray
                  buttonTitleColorArray:(nullable NSArray <UIColor *>*)buttonTitleColorArray
     popoverPresentationControllerBlock:(nullable djt_alertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                                  block:(nullable djt_alertControllerButtonActionBlock)btnActionBlock;


- (void)customMenuShowInViewController:(nonnull UIViewController *)viewController
                                 title:(nullable NSString *)title
                               message:(nullable NSString *)message
                      buttonTitleArray:(nullable NSArray *)buttonTitleArry
                      buttonTitleColorArray:(nullable NSArray<UIColor *> *)buttonTitleColorArray
    popoverPresentationControllerBlock:(nullable djt_alertControllerPopoverPresentationControllerBlock)popoverPesentationControllerBlock
                                 block:(nullable djt_alertControllerButtonActionBlock)btnActionBlock;

@end

NS_ASSUME_NONNULL_END
