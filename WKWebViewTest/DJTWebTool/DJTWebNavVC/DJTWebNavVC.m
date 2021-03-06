//
//  DJTWebNavVC.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTWebNavVC.h"
#import "DJTWKPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define MIN_TAN_VALUE tan(M_PI / 6)

@interface DJTWebNavVC ()<UIGestureRecognizerDelegate>

@property (nonatomic, retain) DJTWKPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL animatedFlag;

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
    //禁用系统侧滑
    self.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _pan = [[DJTWKPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    _pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:_pan];
    //默认开始侧滑
    self.isEnableScroll = YES;
    
}

#pragma mark ======== pan侧滑响应 ========
- (void)pan:(UIPanGestureRecognizer *)pan
{
    UIGestureRecognizerState state = pan.state;
    switch (state){
            
        case UIGestureRecognizerStatePossible:
            
            break;
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translationPoint = [self.pan translationInView:self.view];
            self.visibleViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, translationPoint.x, 0);
            break;
        }
        case UIGestureRecognizerStateEnded:
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        default:
            break;
    }
}

#pragma mark ======== UIGestureRecognizerDelegate ========
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count < 2) return NO;
    if (self.animatedFlag) return NO;
    //询问当前vc是否允许右滑返回
    if (![self enablePanBack]) return NO;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.visibleViewController.view.superview];
    if (touchPoint.x < 0 || touchPoint.y < 10 || touchPoint.x > 220) return NO;
    
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if (translation.x <= 0) return NO;
    
    // 是否是右滑
    BOOL succeed = fabs(translation.y / translation.x) < MIN_TAN_VALUE;
    if (!self.isEnableScroll) {
        //个别页面不允许侧滑
        succeed = NO;
    }
    return succeed;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer != self.pan) return NO;
    if (self.pan.state != UIGestureRecognizerStateBegan) return NO;
    if (otherGestureRecognizer.state != UIGestureRecognizerStateBegan) return YES;

    CGPoint touchPoint = [_pan startPointWithView:self.visibleViewController.view.superview];
    //点击区域判断 如果在左边 30 以内，强制手势后退
    if (touchPoint.x < 30) {
        [self cancelOtherGestureRecognizer:otherGestureRecognizer];
        return YES;
    }
    
    // 如果是scrollview 判断scrollview contentOffset 是否为0，
    // 是: cancel scrollview 的手势    否: cancel自己
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
        if (scrollView.contentOffset.x <= 0) {
            [self cancelOtherGestureRecognizer:otherGestureRecognizer];
            return YES;
        }
    }
    
    return NO;
    
}


- (void)cancelOtherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSSet *touchs = [self.pan.event touchesForGestureRecognizer:otherGestureRecognizer];
    [otherGestureRecognizer touchesCancelled:touchs withEvent:self.pan.event];
}

#pragma mark ======== push ========
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    UIViewController *previousViewController = [self.viewControllers lastObject];
    if (previousViewController) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 动画标识，在动画的情况下，禁掉右滑手势
    [self startAnimated:animated];
    [super pushViewController:viewController animated:animated];
}

#pragma mark ======== pop ========
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self startAnimated:animated];
    return [super popViewControllerAnimated:animated];
}


- (void)startAnimated:(BOOL)animated
{
    _animatedFlag = YES;
    NSTimeInterval delay = animated ? 0.8 : 0.1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishedAnimated) object:nil];
    [self performSelector:@selector(finishedAnimated) withObject:nil afterDelay:delay];
}

- (void)finishedAnimated
{
    _animatedFlag = NO;
}

#pragma mark ======== DJTWebNavVCPanBackProtocol ========

- (BOOL)enablePanBack {
    BOOL enable = YES;
    if ([self.visibleViewController respondsToSelector:@selector(enablePanBack:)]) {
        UIViewController<DJTWebNavVCPanBackProtocol> *viewController = (UIViewController<DJTWebNavVCPanBackProtocol> *)self.visibleViewController;
        enable = [viewController enablePanBack:self];
    }
    if ([self.visibleViewController isKindOfClass:[UITabBarController class]]) {
        enable = NO;
    }
    return enable;
}


- (void)startPanBack {
    if ([self.visibleViewController respondsToSelector:@selector(startPanBack:)]) {
        UIViewController<DJTWebNavVCPanBackProtocol> *viewController = (UIViewController<DJTWebNavVCPanBackProtocol> *)self.visibleViewController;
        [viewController startPanBack:self];
    }
}

- (void)finshPanBackWithReset:(BOOL)reset {
    if (reset) {
        [self resetPanBack];
    } else {
        [self finshPanBack];
    }
}

- (void)finshPanBack {
    if ([self.visibleViewController respondsToSelector:@selector(finshPanBack:)]) {
        UIViewController<DJTWebNavVCPanBackProtocol> *viewController = (UIViewController<DJTWebNavVCPanBackProtocol> *)self.visibleViewController;
        [viewController finshPanBack:self];
    }
}

- (void)resetPanBack {
    if ([self.visibleViewController respondsToSelector:@selector(resetPanBack:)]) {
        UIViewController<DJTWebNavVCPanBackProtocol> *viewController = (UIViewController<DJTWebNavVCPanBackProtocol> *)self.visibleViewController;
        [viewController resetPanBack:self];
    }
}


#pragma mark ======== ChildViewController ========

- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count] > 0) {
        result = [self.viewControllers lastObject];
    }
    return result;
}

#pragma mark ======== ParentViewController ========
- (UIViewController *)previousViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count] > 1) {
        result = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    return result;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:[UIControl class]]) {
            [tabBar removeFromSuperview];
        }
    }
}




@end
