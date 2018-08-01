//
//  NSURL+DJTTool.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/30.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (DJTTool)


/**
 组合请求参数
 
 @param baseURL 请求链接，？之前部分
 @param params ？之后的参数
 @return 完整的请求链接
 */
+ (NSURL *)djt_generateURL:(NSString*)baseURL params:(NSDictionary*)params;


/**
 打开跨域请求
 
 @param URL 请求链接
 */
+ (void)djt_openURL:(NSURL *)URL;

+ (void)djt_safariOpenURL:(NSURL *)URL;




@end
