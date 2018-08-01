//
//  DJTRegisterURLSchemes.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/8/1.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJTURLSchemeModel;
@interface DJTRegisterURLSchemes : NSObject


/**
 存储 urlSchemes 主要用于识别 urlSchemes 的来源名字

 @param urlSchemes urlSchemes 列表
 */
+ (void)registerURLSchemes:(NSDictionary *)urlSchemes;
+ (void)registerURLSchemeModel:(NSArray<DJTURLSchemeModel *> *)urlScheme;

// 需要注册的 URLSchemes数据，需要时添加
+ (NSDictionary *)urlSchemes;

@end
