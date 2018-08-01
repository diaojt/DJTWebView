//
//  WKWebView+DJTWebCache.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/8/1.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (DJTWebCache)

// 清除 webView 缓存
- (void)clearWebCacheFinish:(void(^)(BOOL finish, NSError *error))block;

// 清理缓存的方法，这个方法会清除缓存类型为 HTML 类型的文件
- (void)clearHTMLCache;


@end
