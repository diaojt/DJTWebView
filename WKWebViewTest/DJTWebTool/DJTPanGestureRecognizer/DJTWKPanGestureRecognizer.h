//
//  DJTWKPanGestureRecognizer.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/27.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJTWKPanGestureRecognizer : UIPanGestureRecognizer
//屏幕的手势事件
@property (readonly, nonatomic) UIEvent *event;

- (CGPoint)startPointWithView:(UIView *)view;

@end
