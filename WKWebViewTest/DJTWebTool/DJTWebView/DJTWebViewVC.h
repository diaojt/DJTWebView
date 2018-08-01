//
//  DJTWebViewVC.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/25.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTWebBaseVC.h"
#import <WebKit/WebKit.h>

@protocol DJTWebViewVCScriptMessageHandlerDelegate <NSObject>
@optional
//JS调用OC回调
- (void)DJTUserContentController:(WKUserContentController *)userContentController didReceiveScriptMassage:(WKScriptMessage *)massage;

@end

// 反馈菜单栏点击信息 Block
typedef void (^DJTWebMenuBlock)(UIAlertController *alertController, UIAlertAction *alerAction, NSInteger buttonIndex);

// QRCode内容 Block (包括手势长按或扫码)
typedef void (^DJTQRCodeInfoBlock)(NSString *codeInfo);

// JS调用OC时消息处理 Block
typedef void (^DJTMessageBlock)(WKUserContentController *userContentController, WKScriptMessage *message);

// OC调用JS时回调 Block
typedef void (^DJTResponseBlock)(id response, NSError *error);

// 清空缓存回调 Block
typedef void (^DJTClearCacheFinishBlock)(BOOL finish,NSError *error);


@interface DJTWebViewVC : DJTWebBaseVC

// WKWebView
//@property (nonatomic, strong) WKWebView *webView;
// 当前页面的URL
@property (nonatomic, copy)   NSString *currentURLString;
// 进度条颜色
@property (nonatomic, retain) UIColor *paprogressTintColor;
// 进度条填充颜色
@property (nonatomic, retain) UIColor *paprogressTrackTintColor;
// 缓存
@property (nonatomic, assign) BOOL openCache;
// 执行日志
@property (nonatomic, assign) BOOL showLog;

@property (nonatomic, weak) id<DJTWebViewVCScriptMessageHandlerDelegate> messageHandlerDelegate;


/**
 初始化

 @return self
 */
+ (instancetype)shareInstance;

/**
 加载网页

 (1)加载网页时注入cookies
 (2)把链接更改为 NSMutableURLRequest
 (3)自定义缓存的方式和其他的一些具体的设置
 */
- (void)loadRequestURL:(NSMutableURLRequest *)request;
- (void)loadRequestURL:(NSMutableURLRequest *)request params:(NSDictionary*)params;
- (void)loadLocalHTMLWithFileName:(NSString *)htmlName;


/**
 重新加载webview
 */
- (void)reload;

/**
 重新加载网页,忽略缓存
 */
- (void)reloadFromOrigin;


/**
 返回上一级
 */
- (void)goBack;

/**
 下一级
 */
- (void)goForward;



/**
 添加自定义菜单栏
 
 @param buttonTitle 菜单按钮标题
 @param block 反馈点击信息
 */
- (void)addMenuWithButtonTitle:(NSArray<NSString *> *)buttonTitle block:(DJTWebMenuBlock)block;

/**
 接收QRCode 的内容通知作相关处理

 @param block QRCode的内容(包括手势长按或扫码)
 */
- (void)notificationInfoFromQRCode:(DJTQRCodeInfoBlock)block;


/**
 JS 调用 OC 添加 messageHandler
 
 js 调用 OC，addScriptMessageHandler:name:有两个参数，第一个参数是 userContentController的代理对象，第二个参数是 JS 里发送 postMessage 的对象
 添加一个脚本消息的处理器,同时需要在 JS 中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用
 @param nameArr JS 里发送 postMessage 的对象数组，可同时添加多个对象
 */
- (void)addScriptMessageHandlerWithName:(NSArray<NSString *> *)nameArr;
- (void)addScriptMessageHandlerWithName:(NSArray<NSString *> *)nameArr observeValue:(DJTMessageBlock)callback;
- (void)removeScriptMessageHandlerForName:(NSString *)name;

/**
 OC 调用 JS 方法
 
 @param jsMethod 方法名
 */
- (void)callJS:(NSString *)jsMethod;
- (void)callJS:(NSString *)jsMethod handler:(DJTResponseBlock)handler;


/**
 清除 bakcForwardList 列表
 */
- (void)clearBackForwardList;


/**
 读取本地磁盘的cookies，包括WKWebview的cookies和sharedHTTPCookieStorage存储的cookies
 
 当系统低于 iOS11 时，cookies 将同步NSHTTPCookieStorage的cookies
 当系统大于iOS11时，cookies 将同步
 
 @return 返回包含所有的cookies的数组
 */
- (NSMutableArray *)wkSharedHTTPCookieStorage;


/**
 提供cookies插入，用于loadRequest 网页之前

 cookie 需要设置 cookie 的name，value，domain，expiresDate (过期时间，当不设置过期时间，cookie将不会自动清除);
 cookie 设置expiresDate时使用 [cookieProperties setObject:expiresDate forKey:NSHTTPCookieExpires];将不起作用，原因不明;
 使用 cookieProperties[expiresDate] = expiresDate; 设置cookies 过期时间
 
 @param cookie NSHTTPCookie 类型
 
 
 */
- (void)setCookie:(NSHTTPCookie *)cookie;


/**
 删除 Cookie, 删除某一个或者根据 host 删除
 */
- (void)deleteWKCookie:(NSHTTPCookie *)cookie completionHandler:(nullable void (^)(void))completionHandler;
- (void)deleteWKCookiesByHost:(NSURL *)host completionHandler:(nullable void (^)(void))completionHandler;

/**
 清空所有的cookies
 */
- (void)clearWKCookies;


/**
 清除所有缓存（cookie除外）
 */
- (void)clearWebCacheFinish:(DJTClearCacheFinishBlock)block;

/**
 存储URLSchemes

 存储URLSchemes主要用于识别urlschemes的来源名字和appstore的下载链接。系统默认输入一部分url，如需额外自定义添加或覆盖，请到registerURLSchemes查看样板
 @param URLSchemes URLSchemes 信息
 */
- (void)registerURLSchemes:(NSDictionary *)URLSchemes;

@end

