//
//  NSURL+DJTTool.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/30.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "NSURL+DJTTool.h"
#import "UIAlertController+DJTWebAlert.h"
#import "DJTRegisterURLSchemes.h"

#define IOS10BWK [[UIDevice currentDevice].systemVersion floatValue] >= 10
#define IOS9BWK [[UIDevice currentDevice].systemVersion floatValue] >= 9

@implementation NSURL (DJTTool)


/**
 组合请求参数
 
 @param baseURL 请求链接，？之前部分
 @param params ？之后的参数
 @return 完整的请求链接
 */
+ (NSURL *)djt_generateURL:(NSString*)baseURL params:(NSDictionary*)params
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableArray* pairs = [NSMutableArray array];
    
    for (NSString* key in param.keyEnumerator) {
        NSString *value = [NSString stringWithFormat:@"%@",[param objectForKey:key]];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSString *query = [pairs componentsJoinedByString:@"&"];
    
#ifdef IOS9BWK
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet];
    baseURL = [baseURL stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
#else
    baseURL = [baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    
    NSString* url = @"";
    if ([baseURL containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&%@",baseURL, query];
    }
    else {
        url = [NSString stringWithFormat:@"%@?%@",baseURL, query];
    }
    return [NSURL URLWithString:url];
}


/**
 打开跨域请求
 
 @param URL 请求链接
 */
+ (void)djt_openURL:(NSURL *)URL
{
    NSLog(@"%@",URL.host.lowercaseString);
    if ([URL.host.lowercaseString isEqualToString:@"itunes.apple.com"] ||
        [URL.host.lowercaseString isEqualToString:@"itunesconnect.apple.com"]) {
        
        [UIAlertController djt_alertWithTitle:[NSString stringWithFormat:@"即将打开Appstore下载应用"] message:@"如果不是本人操作，请取消" action1Title:@"取消" action2Title:@"打开" action1:^{
            return;
        } action2:^{
            [self djt_safariOpenURL:URL];
        }];
    }else{
        
        //获取应用名字
        NSDictionary *urlschemes = [DJTRegisterURLSchemes urlSchemes];
        NSDictionary *appInfo = [urlschemes objectForKey:URL.scheme];
        NSString *name =[appInfo objectForKey:@"name"];
        
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            if (!name) {
                name = URL.scheme;
            }
            [UIAlertController djt_alertWithTitle:[NSString stringWithFormat:@"即将打开%@",name] message:@"如果不是本人操作，请取消" action1Title:@"取消" action2Title:@"打开" action1:^{
                
                return;
            } action2:^{
                [self djt_safariOpenURL:URL];
            }];
        }else{
            if (!appInfo) return;
            NSString *urlString = [appInfo objectForKey:@"url"];
            if (!urlString) return;
            NSURL *appstoreURL = [NSURL URLWithString:urlString];
            [UIAlertController djt_alertWithTitle:[NSString stringWithFormat:@"前往Appstore下载"] message:@"你还没安装该应用，是否前往Appstore下载？" action1Title:@"取消" action2Title:@"去下载" action1:^{
                return;
            } action2:^{
                [self djt_safariOpenURL:appstoreURL];
            }];
        }
    }
}

+ (void)djt_safariOpenURL:(NSURL *)URL
{

#ifdef IOS10BWK
    [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
        
        if (!success) {
            [UIAlertController djt_alertWithTitle:@"提示" message:@"打开失败" completion:nil];
            
        }
    }];
#else
    if (![[UIApplication sharedApplication] openURL:URL]) {
        [UIAlertController djt_alertWithTitle:@"提示" message:@"打开失败" completion:nil];
    }
#endif
}
@end
