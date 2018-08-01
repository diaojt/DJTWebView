//
//  DJTWKPanGestureRecognizer.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/27.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTWKPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation DJTWKPanGestureRecognizer
{
    CGPoint _startLocation;
    
}


- (CGPoint)startPointWithView:(UIView *)view
{
    return [view convertPoint:_startLocation toView:self.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _startLocation = [touch locationInView:self.view];
    _event = event;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStatePossible || event.timestamp-_event.timestamp > 0.3) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    [super touchesMoved:touches withEvent:event];
}


- (void)reset
{
    _startLocation = CGPointZero;
    _event = nil;
    [super reset];
}

@end
