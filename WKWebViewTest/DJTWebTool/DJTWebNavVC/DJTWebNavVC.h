//
//  DJTWebNavVC.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJTWebNavVC : UINavigationController

// 侧滑手势
@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) BOOL isEnableScroll;

@end

@protocol DJTWebNavVCPanBackProtocol

/**
 能否侧滑
 
 @param panWebNavVc panNavigationController
 @return BooL
 */
- (BOOL)enablePanBack:(DJTWebNavVC *)panWebNavVc;

/**
 开始侧滑手势
 
 @param panWebNavVc DJTWebNavVC
 */
- (void)startPanBack:(DJTWebNavVC *)panWebNavVc;

/**
 完成侧滑
 
 @param panWebNavVc DJTWebNavVC
 */
- (void)finshPanBack:(DJTWebNavVC *)panWebNavVc;

/**
 重置侧滑手势
 
 @param panWebNavVc DJTWebNavVC
 */
- (void)resetPanBack:(DJTWebNavVC *)panWebNavVc;

@end


