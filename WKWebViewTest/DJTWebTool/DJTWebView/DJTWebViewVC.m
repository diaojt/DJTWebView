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
#import "WKWebView+DJTWebCookie.h"
#import "NSURL+DJTTool.h"
#import "DJTWebViewMenu.h"
#import "WKWebView+DJTWebCache.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

NSString *const NotiName_LoadRequest = @"notiLoadRequest"; //通知跳转的通知名
NSString *const Key_LoadQRCodeUrl = @"Key_LoadQRCodeUrl"; //二维码识别（包括扫码和长按识别等）

static BOOL isReload = NO;
static BOOL isLoadSuccess = NO;
static DJTMessageBlock messageCallback = nil;

@interface DJTWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, retain) DJTWebViewMenu *menu;
@property (nonatomic,   copy) DJTWebMenuBlock menuBlock;

//进度条
@property (nonatomic, strong) UIProgressView *wkProgressView;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, copy)   DJTQRCodeInfoBlock qrcodeBlock;

@property (nonatomic, retain) NSArray *messageHandlerName;
@property (nonatomic, assign) BOOL longpress;

@end

@implementation DJTWebViewVC

- (instancetype)init
{
    if (self = [super init]) {
        self.openCache = YES;
        self.showLog = NO;
        //初始化提前加载
//        [self loadRequestURL:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    }
    return self;
}

#pragma mark ======== 生命周期 ========

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUI];
//    [self loadRequest];
    [self addObservers];
    self.navigationController.navigationBarHidden = YES;
//    [self getSandBoxPaths];
//    [self appCookie];
    [self loadRequestURL:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 并不是所有H5页面白屏的时候都会调用回调函数 webViewWebContentProcessDidTerminate:
    // 比如，最近遇到在一个高内存消耗的H5页面上 present 系统相机，
    // 拍照完毕后返回原来页面的时候出现白屏现象(拍照过程消耗了大量内存，导致内存紧张，WebContent Process 被系统挂起),但上面的回调函数并没有被调用;
    // 在WKWebView白屏的时候，另一种现象是 webView.titile 会被置空, 因此，可以在 viewWillAppear 的时候检测 webView.title 是否为空来 reload 页面
    if (!self.wkWebView.title) {
        [self.wkWebView reload];
    }
    
}

#pragma mark ======== setupUI ========
- (void)setupUI
{
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.wkProgressView];
    
    self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    
    WS(weakSelf);
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.wkProgressView.mas_bottom);
    }];
   
    [self.wkProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@2);
    }];
}

#pragma mark ======== 测试代码 ========

- (void)appCookie
{
    //1. 创建一个网络请求
    NSURL *url = [NSURL URLWithString:@"https://m.baidu.com"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //response ： 响应：服务器的响应
        //data：二进制数据：服务器返回的数据。（就是我们想要的内容）
        //error：链接错误的信息
        NSLog(@"------*********************------");
        NSLog(@"\n网络响应response:%@",response);
        NSLog(@"------*********************------");
 
    }];
    
    //5.执行任务
    [dataTask resume];
}

//获取文件夹路径
- (void)getSandBoxPaths
{
    //获取沙盒主目录路径
    NSString *homeDir = NSHomeDirectory();
    
    //获取documents目录路径
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    //获取caches目录路径
    NSString *cachesDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    //获取tmp目录文件
    NSString *tmpDir = NSTemporaryDirectory();
    
    NSLog(@"\n***沙盒主目录路径***：%@\n\n***Documents目录路径***：%@\n\n***Caches目录路径***：%@\n\n***Tmp目录路径***：%@",homeDir,docDir,cachesDir,tmpDir);
    
}

//加载文件
- (void)loadFile
{
    // 创建url(可以随便从桌面拉张图片)
    NSURL *url = [NSURL fileURLWithPath:@"/Users/ios/Desktop/图片/xxx.jpg"];
    // 加载文件
    [self.wkWebView loadFileURL:url allowingReadAccessToURL:url];
}

#pragma mark ======== 添加KVO事件监听 ========
- (void)addObservers
{
    
    //对于WKWebView，有三个属性支持KVO，因此我们可以监听其值的变化，分别是：loading,title,estimatedProgress，对应功能表示为：是否正在加载中，页面的标题，页面内容加载的进度（值为0.0~1.0）
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    
}


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
            [self.wkProgressView setAlpha:1.0f];
            [self.wkProgressView setProgress:self.wkWebView.estimatedProgress animated:YES];
            if(self.wkWebView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.wkProgressView setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.wkProgressView setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"canGoBack"]){
        if (object == self.wkWebView){
            //是否可以返回前一个页面
            NSLog(@"canGoBack: -----------%d",self.wkWebView.canGoBack);
            self.backItem.customView.userInteractionEnabled = self.wkWebView.canGoBack;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

#pragma mark ======== 移除KVO ========
- (void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self forKeyPath:@"canGoBack"];
}

#pragma mark ======== 网络请求 ========


/**
 重新加载网页
 */
- (void)reload
{
    isReload = YES;
    [self.wkWebView reload];
}


/**
 重新加载网页，忽略缓存
 */
- (void)reloadFromOrigin
{
    isReload = YES;
    [self.wkWebView reloadFromOrigin];
}


//- (void)loadRequest
//{
//    // 网页url
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//    // 网络请求
//    NSURLRequest *request =[NSURLRequest requestWithURL:url];
//    // 加载网页
//    [self.wkWebView loadRequest:request];
//}


/**
 请求网络资源 post

 @param request 请求的具体地址
 @param params 参数
 */
- (void)loadRequestURL:(NSMutableURLRequest *)request params:(NSDictionary *)params
{
    NSURL *URLString = [NSURL djt_generateURL:request.URL.absoluteString params:params];
    request.URL = URLString;
    [self loadRequestURL:request];
}

/**
 请求网络资源

 @param request 请求的具体地址和设置
 */
- (void)loadRequestURL:(NSMutableURLRequest *)request
{
    _wkWebView = _wkWebView ? _wkWebView : self.wkWebView;
    NSString *domain = request.URL.host;
    
    //插入cookies JS
    if (domain) [self.config.userContentController addUserScript:[_wkWebView djt_searchCookieForUserScriptWithDomain:domain]];
    if (domain) [request setValue:[_wkWebView djt_phpCookieStringWithDomain:domain] forHTTPHeaderField:@"Cookie"];
    // 重置空白界面
//    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [_wkWebView loadRequest:request];
    
}


/**
 加载本地 HTML 页面

 @param htmlName html页面文件名称
 */
- (void)loadLocalHTMLWithFileName:(nonnull NSString*)htmlName
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding    error:nil];
    [self.wkWebView loadHTMLString:htmlCont baseURL:baseURL];
}

/**
 *  接收通知进行网页跳转
 *  @param noti 通知内容
 */
-(void)loadRequestFromNotification:(NSNotification *)noti
{
    NSString * urlStr = [NSString string];
    for (NSString * key in [noti userInfo]){
        if ([key isEqualToString:Key_LoadQRCodeUrl]) {
            urlStr = [noti userInfo][key];
        }
    }
    NSLog(@"urlStr = %@ ",urlStr);
    
    _qrcodeBlock ? _qrcodeBlock(urlStr) : NULL;
    
    NSURL * url = [NSURL URLWithString:urlStr];
    if ([urlStr containsString:@"http"] || [[UIApplication sharedApplication]canOpenURL:url]) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}
- (void)notificationInfoFromQRCode:(DJTQRCodeInfoBlock)block
{
    _qrcodeBlock = block;
}



#pragma mark ======== JS交互 messageHandler ========


/**
 OC 调用 JS

 @param jsMethod JS 方法
 */
- (void)callJS:(NSString *)jsMethod
{
    [self callJS:jsMethod handler:nil];
}

- (void)callJS:(NSString *)jsMethod handler:(DJTResponseBlock)handler
{
    NSLog(@"call js : %@",jsMethod);
    [self.wkWebView evaluateJavaScript:jsMethod completionHandler:^(id response, NSError *error) {
        handler ? handler(response, error) : NULL;
    }];
}

- (void)addScriptMessageHandlerWithName:(NSArray<NSString *> *)nameArr
{
    // removeScriptMessageHandlerForName 同时使用，否则内存泄漏
    for (NSString *objStr in nameArr) {
        @try{
            // WKUserContentController是用于给JS注入对象的，注入对象后，JS端就可以使用
            [self.config.userContentController addScriptMessageHandler:self name:objStr];
        }@catch(NSException *e){
            NSLog(@"异常信息：%@",e);
        }@finally{
            
        }
    }
    self.messageHandlerName = nameArr;
}

- (void)addScriptMessageHandlerWithName:(NSArray<NSString *> *)nameArr observeValue:(DJTMessageBlock)callback
{
    messageCallback = callback;
    [self addScriptMessageHandlerWithName:nameArr];
}


//注销 注册过的JS 回调OC通知方式，适用于iOS8 后
- (void)removeScriptMessageHandlerForName:(NSString *)name
{
    [_config.userContentController removeScriptMessageHandlerForName:name];
}
// 调用 JS
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void(^_Nullable)(_Nullable id, NSError * _Nullable error))completionHandler {
    
    NSString *promptCode = javaScriptString;
    [self.wkWebView evaluateJavaScript:promptCode completionHandler:completionHandler];
    
}

// messageHandler 代理 - JS 调用 OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@" message.body =   %@ ",message.body);
    NSLog(@" message.name =   %@ ",message.name);
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    
    if (_messageHandlerDelegate && [_messageHandlerDelegate respondsToSelector:@selector(DJTUserContentController:didReceiveScriptMassage:)]) {
        [_messageHandlerDelegate DJTUserContentController:userContentController didReceiveScriptMassage:message];
    }
    
    messageCallback ? messageCallback(userContentController,message) : NULL;

}

#pragma mark ======== 其他几个加载方法 ========
// 其它三个加载函数
//- (WKNavigation *)loadRequest:(NSURLRequest *)request;
//- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
//- (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL;


#pragma mark ======== Cookies 和 Cache 处理========
- (void)setCookie:(NSHTTPCookie *)cookie
{
    [self.wkWebView djt_insertCookie:cookie];
}

// 获取本地磁盘的Cookies
- (NSMutableArray *)wkSharedHTTPCookieStorage
{
    return [self.wkWebView djt_sharedHTTPCookieStorage];
}

//删除某一个 cookies
- (void)deleteWKCookie:(NSHTTPCookie *)cookie completionHandler:(void (^)(void))completionHandler
{
    [self.wkWebView djt_deleteWKCookie:cookie completionHandler:completionHandler];
}

- (void)deleteWKCookiesByHost:(NSURL *)host completionHandler:(void (^)(void))completionHandler
{
    [self.wkWebView djt_deleteWKCookiesByHost:host completionHandler:completionHandler];
}


// 清除缓存，不包括cookies
- (void)clearWebCacheFinish:(DJTClearCacheFinishBlock)block
{
    [self.wkWebView clearWebCacheFinish:block];
}

// 删除所有的cookies
- (void)clearWKCookies
{
    [self.wkWebView djt_clearWKCookies];
}





#pragma mark ======== WKNavigationDelegate ========

//// 1.在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
//{
//
//
//}
//
// 2.页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    isLoadSuccess = NO;

}
//
// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    WS(weakSelf);
    if (@available(iOS 11.0, *)) {
        //浏览器自动存储cookie
    }
    else{//手动存储cookie
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            @try{
                //存储cookies
                for (NSHTTPCookie *cookie in cookies) {
                    [weakSelf.wkWebView djt_insertCookie:cookie];
                }
            }@catch(NSException *e){
                NSLog(@"failed:%@", e);
            }@finally{
                
            }
        });
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);

}
//
//// 4 开始获取到网页内容时返回
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
//{
//
//}
//
// 5.页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%@",webView.URL.absoluteString);
    isLoadSuccess = YES;
    WS(weakSelf);
    //获取当前 URLString
    [webView evaluateJavaScript:@"window.location.href" completionHandler:^(id _Nullable urlStr, NSError * _Nullable error) {
        if (error == nil) {
            weakSelf.currentURLString = urlStr;
            NSLog(@"currentURLStr : %@ ",weakSelf.currentURLString);
        }
    }];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    // 当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用这个回调函数，
    // 我们在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）
    // 解决白屏问题
    [webView reload];
}




#pragma mark ======== 导航栏选项控制-父类方法 ========
- (void)close
{
    NSLog(@"DJTWebViewVC----close");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)back
{
    NSLog(@"DJTWebViewVC-----back");
    //判断是否有上一层H5页面
    if ([self.wkWebView canGoBack])
    {
        //如果有则返回
        [self.wkWebView goBack];
    }else
    {
        NSLog(@"已经是第一个页面！");
    }
    
}

// 菜单按钮点击
- (void)showMenu
{
    NSLog(@"DJTWebViewVC-----showMenu");
    if (self.menu.defaultType) {
        
        NSMutableArray *buttonTitleArray = [NSMutableArray array];
        [buttonTitleArray addObjectsFromArray:@[@"safari打开",@"复制链接",@"分享",@"截图",@"刷新"]];
        if (self.showLog) [buttonTitleArray addObject:@"执行日志"];
        [self.menu defaultMenuShowInViewController:self title:@"更多" message:nil buttonTitleArray:buttonTitleArray buttonTitleColorArray:nil popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            
        } block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                if (self.currentURLString.length > 0) {
                    //safari打开
                    [NSURL djt_safariOpenURL:[NSURL URLWithString:self.currentURLString]];
                    return;
                }else{
                    [UIAlertController djt_alertWithTitle:@"提示" message:@"无法获取当前链接" completion:nil];
                }
            }
            else if (buttonIndex == 1){
                //复制链接
                if(self.currentURLString.length > 0){
                    [UIPasteboard generalPasteboard].string = self.currentURLString;
                    return;
                }else{
                    [UIAlertController djt_alertWithTitle:@"提示" message:@"无法获取当前链接" completion:nil];
                }
            }
            else if(buttonIndex == 2)
            {
                
            }
            else if (buttonIndex == 3)
            {
                
            }
            else if (buttonIndex == 4)
            {
                //刷新
                [self.wkWebView reloadFromOrigin];
            }
        }];
    }else
    {
        [self.menu customMenuShowInViewController:self
                                            title:@"更多"
                                          message:nil
                                 buttonTitleArray: nil
                            buttonTitleColorArray:nil
               popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover){}
                                          block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex){
                                              
                                                self.menuBlock ? self.menuBlock(alertController, action, buttonIndex):NULL;
                                              
                                          }];
    
    }
}

#pragma mark ======== menu 实例 ========
- (DJTWebViewMenu *)menu
{
    if (!_menu) {
        _menu = [DJTWebViewMenu shareInstance];
        _menu.defaultType = YES;
    }
    
    return _menu;
}




#pragma mark ======== wkWebView实例 ========

//初始化 WKWebView
- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView  = [[WKWebView alloc] init];
        
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.delegate = self;
        
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.multipleTouchEnabled = YES;
        _wkWebView.userInteractionEnabled = YES;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        
        _wkWebView.scrollView.bounces = YES;
        _wkWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _wkWebView.scrollView.showsVerticalScrollIndicator = YES;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            WKHTTPCookieStore *cookieStore = _wkWebView.configuration.websiteDataStore.httpCookieStore;
            [_wkWebView djt_syncCookiesToWKHTTPCookieStore:cookieStore];
        }
        
        //对于WKWebView，有三个属性支持KVO，因此我们可以监听其值的变化，分别是：loading,title,estimatedProgress，对应功能表示为：是否正在加载中，页面的标题，页面内容加载的进度（值为0.0~1.0）
//        [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
//        [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        //添加页面跳转通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRequestFromNotification:) name:NotiName_LoadRequest object:nil];
        //添加长按手势
//        [_webView  addGestureRecognizerObserverWebElements:^(BOOL longpress) {
//            _longpress = longpress;
//        }];
        
    }
    return _wkWebView;
}

#pragma mark ======== 进度条 ========
//初始化 UIProgressView
- (UIProgressView *)wkProgressView
{
    if (!_wkProgressView)
    {
        _wkProgressView = [[UIProgressView alloc] init];
        _wkProgressView.tintColor = [UIColor blueColor];
        _wkProgressView.backgroundColor = [UIColor lightGrayColor];
    }
    return _wkProgressView;
}

- (void)setPaprogressTintColor:(UIColor *)paprogressTintColor
{
    _paprogressTintColor = paprogressTintColor;
    self.wkProgressView.progressTintColor = paprogressTintColor;
}

- (void)setPaprogressTrackTintColor:(UIColor *)paprogressTrackTintColor
{
    _paprogressTrackTintColor = paprogressTrackTintColor;
    self.wkProgressView.trackTintColor = paprogressTrackTintColor;
    
}


#pragma mark ======== 配置wkWebView ========
//配置 WKWebViewConfiguration
-(WKWebViewConfiguration *)config
{
    if (!_config) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.userContentController = [[WKUserContentController alloc] init];
        _config.preferences = [[WKPreferences alloc] init];
        _config.preferences.minimumFontSize = 10;
        //是否支持 JavaScript
        _config.preferences.javaScriptEnabled = YES;
        _config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _config.processPool = [[WKProcessPool alloc] init];
        //允许在线播放
        _config.allowsInlineMediaPlayback = YES;
        if (@available(iOS 9.0, *)) {
            //允许视频播放
            _config.allowsAirPlayForMediaPlayback = YES;
        }
        
        NSMutableString *javascript = [NSMutableString string];
        //禁止长按
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [_config.userContentController addUserScript:noneSelectScript];
    }
    return _config;
}



@end
