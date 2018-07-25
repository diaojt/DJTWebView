//
//  DJTWebViewVC.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

/**
 与之交互用到的三大代理
 1.WKNavigationDelegate，与页面导航加载相关
 2.WKUIDelegate，与JS交互时的ui展示相关，比较JS的alert、confirm、prompt
 3.WKScriptMessageHandler，与js交互相关，通常是ios端注入名称，js端通过window.webkit.messageHandlers.{NAME}.postMessage()来发消息到ios端
 */

#import "DJTWebViewVC.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DJTWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progress;

@end

@implementation DJTWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadRequest];
    [self addObservers];
}

#pragma mark ======== setupUI ========
- (void)setupUI
{
    [self.view addSubview:self.wkWebView];
    WS(weakSelf);
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.view addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.equalTo(weakSelf.wkWebView);
        make.height.mas_equalTo(@2);
    }];
}

#pragma mark ======== 添加事件监听 ========
- (void)addObservers
{
    
    //对于WKWebView，有三个属性支持KVO，因此我们可以监听其值的变化，分别是：loading,title,estimatedProgress，对应功能表示为：是否正在加载中，页面的标题，页面内容加载的进度（值为0.0~1.0）
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark ======== load request ========
- (void)loadRequest
{
    // 网页url
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    // 网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 加载网页
    [self.wkWebView loadRequest:request];
}

#pragma mark ======== 加载文件 ========
- (void)loadFile
{
    // 创建url(可以随便从桌面拉张图片)
    NSURL *url = [NSURL fileURLWithPath:@"/Users/ios/Desktop/图片/xxx.jpg"];
    // 加载文件
    [self.wkWebView loadFileURL:url allowingReadAccessToURL:url];
}

#pragma mark ======== 其他几个加载方法 ========
// 其它三个加载函数
//- (WKNavigation *)loadRequest:(NSURLRequest *)request;
//- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
//- (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL;




#pragma mark ======== 初始化WKWebView ========
- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView  = [[WKWebView alloc] init];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

- (UIProgressView *)progress
{
    if (!_progress)
    {
        _progress = [[UIProgressView alloc] init];
        _progress.tintColor = [UIColor blueColor];
        _progress.backgroundColor = [UIColor lightGrayColor];
    }
    return _progress;
}


#pragma mark ======== WKNavigationDelegate ========

//// 1.在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
//{
//
//
//}
//
//// 2.页面开始加载
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//
//}
//
//// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//{
//
//}
//
//// 4 开始获取到网页内容时返回
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
//{
//
//}
//
//// 5.页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//
//}

#pragma mark ======== KVO 的监听代理 ========
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //网页title
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView)
        {
            self.title = self.wkWebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //加载进度值
    else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.wkWebView)
        {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.wkWebView.estimatedProgress animated:YES];
            if(self.wkWebView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}

//移除观察者
- (void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}






@end
