//
//  WKWebView+DJTWebCookie.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/27.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (DJTWebCookie)

/**
 ios11 同步 cookies
 */
- (void)djt_syncCookiesToWKHTTPCookieStore:(WKHTTPCookieStore *)cookieStroe API_AVAILABLE(macosx(10.13), ios(11.0));

/**
 插入 cookies 存储于磁盘
 */
- (void)djt_insertCookie:(NSHTTPCookie *)cookie;

/**
 获取本地磁盘的 cookies
 */
- (NSMutableArray *)djt_sharedHTTPCookieStorage;

/**
 删除所有的 cookies
 */
- (void)djt_clearWKCookies;

/**
 删除某一个 cookies
 */
- (void)djt_deleteWKCookie:(NSHTTPCookie *)cookie completionHandler:(nullable void (^)(void))completionHandler;
- (void)djt_deleteWKCookiesByHost:(NSURL *)host completionHandler:(nullable void (^)(void))completionHandler;

/**
 js获取 domain 的 cookie
 */
- (NSString *)djt_jsCookieStringWithDomain:(NSString *)domain;
- (WKUserScript *)djt_searchCookieForUserScriptWithDomain:(NSString *)domain;

/**
 PHP 获取 domain 的 cookie
 */
- (NSString *)djt_phpCookieStringWithDomain:(NSString *)domain;
@end
