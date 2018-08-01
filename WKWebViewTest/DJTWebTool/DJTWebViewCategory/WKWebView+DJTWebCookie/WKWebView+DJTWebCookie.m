//
//  WKWebView+DJTWebCookie.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/27.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "WKWebView+DJTWebCookie.h"

static NSString* const djt_WKCookiesKey = @"com.500.DJTWKShareInstanceCookies";

@implementation WKWebView (DJTWebCookie)

- (NSMutableArray *)djt_sharedHTTPCookieStorage
{
    @autoreleasepool {
        NSMutableArray *cookiesArr = [NSMutableArray array];
        //获取 NSHTTPCookieStorage cookies  WKHTTPCookieStore 的cookie 已经同步
        NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in shareCookie.cookies){
            [cookiesArr addObject:cookie];
        }
        
        // 获取自定义存储的cookies
        NSMutableArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: djt_WKCookiesKey]];
        
        //删除过期的cookies
        for (int i = 0; i < cookies.count; i++) {
            NSHTTPCookie *cookie = [cookies objectAtIndex:i];
            if (!cookie.expiresDate) {
                //当cookie不设置过期时间时，视cookie的有效期为长期有效
                [cookiesArr addObject:cookie];
                continue;
            }
            if ([cookie.expiresDate compare:self.currentTime]) {
                [cookiesArr addObject:cookie];
            }else
            {
                //清除过期的cookie
                [cookies removeObject:cookie];
                i--;
            }
        }
        
        //存储最新有效的cookies
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: cookies];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:djt_WKCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return cookiesArr;
    }
}

// 同步 cookies
- (void)djt_syncCookiesToWKHTTPCookieStore:(WKHTTPCookieStore *)cookieStore API_AVAILABLE(macosx(10.13), ios(11.0))
{
    NSMutableArray *cookieArr = [self djt_sharedHTTPCookieStorage];
    if (cookieArr.count == 0)return;
    for (NSHTTPCookie *cookie in cookieArr) {
        [cookieStore setCookie:cookie completionHandler:nil];
    }
}

//添加 cookie
- (void)djt_insertCookie:(NSHTTPCookie *)cookie
{
    @autoreleasepool {
        
        if (@available(iOS 11.0, *)) {
            WKHTTPCookieStore *cookieStore = self.configuration.websiteDataStore.httpCookieStore;
            [cookieStore setCookie:cookie completionHandler:nil];
        }
        
        NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [shareCookie setCookie:cookie];
        
        NSMutableArray *TempCookies = [NSMutableArray array];
        NSMutableArray *localCookies =[NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: djt_WKCookiesKey]];
        for (int i = 0; i < localCookies.count; i++) {
            NSHTTPCookie *TempCookie = [localCookies objectAtIndex:i];
            if ([cookie.name isEqualToString:TempCookie.name] &&
                [cookie.domain isEqualToString:TempCookie.domain]) {
                [localCookies removeObject:TempCookie];
                i--;
                break;
            }
        }
        [TempCookies addObjectsFromArray:localCookies];
        [TempCookies addObject:cookie];
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: TempCookies];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:djt_WKCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 删除 cookie
- (void)djt_deleteWKCookie:(NSHTTPCookie *)cookie completionHandler:(nullable void (^)(void))completionHandler;
{
    if (@available(iOS 11.0, *)) {
        
        //删除WKHTTPCookieStore中的cookies
        WKHTTPCookieStore *cookieStore = self.configuration.websiteDataStore.httpCookieStore;
        [cookieStore deleteCookie:cookie completionHandler:nil];
    }
    
    //删除NSHTTPCookieStorage中的cookie
    NSHTTPCookieStorage *NSCookiesStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [NSCookiesStore deleteCookie:cookie];
    
    //删除磁盘中的cookie
    NSMutableArray *localCookies =[NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: djt_WKCookiesKey]];
    for (int i = 0; i < localCookies.count; i++) {
        NSHTTPCookie *TempCookie = [localCookies objectAtIndex:i];
        if ([cookie.domain isEqualToString:TempCookie.domain] &&
            [cookie.domain isEqualToString:TempCookie.domain] ) {
            [localCookies removeObject:TempCookie];
            i--;
            break;
        }
    }
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: localCookies];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:djt_WKCookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    completionHandler ? completionHandler() : NULL;
}

// 根据host删除cookies
- (void)djt_deleteWKCookiesByHost:(NSURL *)host completionHandler:(nullable void (^)(void))completionHandler{
    
    if (@available(iOS 11.0, *)) {
        //删除WKHTTPCookieStore中的cookies
        WKHTTPCookieStore *cookieStore = self.configuration.websiteDataStore.httpCookieStore;
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * cookies) {
            
            NSArray *WKCookies = cookies;
            for (NSHTTPCookie *cookie in WKCookies) {
                
                NSURL *domainURL = [NSURL URLWithString:cookie.domain];
                if ([domainURL.host isEqualToString:host.host]) {
                    [cookieStore deleteCookie:cookie completionHandler:nil];
                }
            }
        }];
    }
    
    //删除NSHTTPCookieStorage中的cookies
    NSHTTPCookieStorage *NSCookiesStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *NSCookies = NSCookiesStore.cookies;
    for (NSHTTPCookie *cookie in NSCookies) {
        
        NSURL *domainURL = [NSURL URLWithString:cookie.domain];
        if ([domainURL.host isEqualToString:host.host]) {
            [NSCookiesStore deleteCookie:cookie];
        }
    }
    
    //删除磁盘中的cookies
    NSMutableArray *localCookies =[NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: djt_WKCookiesKey]];
    for (int i = 0; i < localCookies.count; i++) {
        
        NSHTTPCookie *TempCookie = [localCookies objectAtIndex:i];
        NSURL *domainURL = [NSURL URLWithString:TempCookie.domain];
        if ([host.host isEqualToString:domainURL.host]) {
            [localCookies removeObject:TempCookie];
            i--;
            break;
        }
    }
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: localCookies];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:djt_WKCookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    completionHandler ? completionHandler() : NULL;
    
}

- (void)djt_clearWKCookies
{
    if (@available(iOS 11.0, *)) {
        NSSet *websiteDataTypes = [NSSet setWithObject:WKWebsiteDataTypeCookies];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }
    
    //删除NSHTTPCookieStorage中的cookies
    NSHTTPCookieStorage *NSCookiesStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [NSCookiesStore removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: @[]];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:djt_WKCookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/** js获取domain的cookie */
- (NSString *)djt_jsCookieStringWithDomain:(NSString *)domain
{
    @autoreleasepool {
        NSMutableString *cookieSting = [NSMutableString string];
        NSArray *cookieArr = [self djt_sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieArr) {
            if ([cookie.domain containsString:domain]) {
                [cookieSting appendString:[NSString stringWithFormat:@"document.cookie = '%@=%@';",cookie.name,cookie.value]];
            }
        }
        return cookieSting;
    }
}

- (WKUserScript *)djt_searchCookieForUserScriptWithDomain:(NSString *)domain
{
    NSString *cookie = [self djt_jsCookieStringWithDomain:domain];
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    return cookieScript;
}

/** PHP 获取domain的cookie */
- (NSString *)djt_phpCookieStringWithDomain:(NSString *)domain
{
    @autoreleasepool {
        NSMutableString *cookieSting =[NSMutableString string];
        NSArray *cookieArr = [self djt_sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieArr) {
            if ([cookie.domain containsString:domain]) {
                [cookieSting appendString:[NSString stringWithFormat:@"%@ = %@;",cookie.name,cookie.value]];
            }
        }
        if (cookieSting.length > 1)[cookieSting deleteCharactersInRange:NSMakeRange(cookieSting.length - 1, 1)];
        
        return (NSString *)cookieSting;
    }
}

- (NSDate *)currentTime
{
    return [NSDate dateWithTimeIntervalSinceNow:0];
}


@end
