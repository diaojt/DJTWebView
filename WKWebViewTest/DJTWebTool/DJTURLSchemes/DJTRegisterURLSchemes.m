//
//  DJTRegisterURLSchemes.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/8/1.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTRegisterURLSchemes.h"
#import "DJTURLSchemeModel.h"

@implementation DJTRegisterURLSchemes

+ (NSString *)urlSchemesPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) firstObject];
    return path = [path stringByAppendingPathComponent:@"appURLSchemes"];
}

+ (void)registerURLSchemes:(NSDictionary *)urlSchemes
{
    NSString *path = [self urlSchemesPath];
    [urlSchemes writeToFile:path atomically:YES];
}

+ (void)registerURLSchemeModel:(NSArray<DJTURLSchemeModel *> *)urlScheme
{
    NSMutableDictionary *contantDic = [NSMutableDictionary dictionary];
    for (DJTURLSchemeModel *model in urlScheme) {
        NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
        [subDic setValue:model.appstoreUrl forKey:@"url"];
        [subDic setValue:model.appid forKey:@"id"];
        [subDic setValue:model.displayName forKey:@"name"];
        
        [contantDic setObject:subDic forKey:model.scheme];
    }
    
    [self registerURLSchemes:contantDic];
}

+ (NSDictionary *)urlSchemes
{
    //把信息注册到 info plist 列表
    NSDictionary *mainUrlSchemes = @{
                                     @"weixin":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id414478124?mt=8",
                                             @"id":@"414478124",
                                             @"name":@"微信",
                                             },
                                     @"wechat":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id414478124?mt=8",
                                             @"id":@"414478124",
                                             @"name":@"微信",
                                             },
                                     @"alipay":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id333206289?mt=8",
                                             @"id":@"333206289",
                                             @"name":@"支付宝",
                                             },
                                     @"alipayshare":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id333206289?mt=8",
                                             @"id":@"333206289",
                                             @"name":@"支付宝",
                                             },
                                     @"taobao":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id387682726?mt=8",
                                             @"id":@"387682726",
                                             @"name":@"淘宝",
                                             },
                                     @"mqq":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id444934666?mt=8",
                                             @"id":@"444934666",
                                             @"name":@"QQ",
                                             },
                                     @"mqqapi":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id444934666?mt=8",
                                             @"id":@"444934666",
                                             @"name":@"QQ",
                                             },
                                     @"mqzone":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id444934666?mt=8",
                                             @"id":@"444934666",
                                             @"name":@"QQ",
                                             },
                                     @"mqqwpa":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id444934666?mt=8",
                                             @"id":@"444934666",
                                             @"name":@"QQ",
                                             },
                                     @"mqqapi":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id444934666?mt=8",
                                             @"id":@"444934666",
                                             @"name":@"QQ",
                                             },
                                     @"BaiduSSO":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id382201985?mt=8",
                                             @"id":@"382201985",
                                             @"name":@"百度",
                                             },
                                     @"ucbrowser":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id527109739?mt=8",
                                             @"id":@"527109739",
                                             @"name":@"UC浏览器",
                                             },
                                     @"bdmap":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id452186370?mt=8",
                                             @"id":@"452186370",
                                             @"name":@"百度地图",
                                             },
                                     @"snssdk141":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id529092160?mt=8",
                                             @"id":@"529092160",
                                             @"name":@"今日头条",
                                             },
                                     @"imeituan":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id423084029?mt=8",
                                             @"id":@"414245413",
                                             @"name":@"美团",
                                             },
                                     @"openapp.jdmoble":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id414245413?mt=8",
                                             @"id":@"414245413",
                                             @"name":@"京东",
                                             },
                                     @"VSSpecialSwitch":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id417200582?mt=8",
                                             @"id":@"417200582",
                                             @"name":@"唯品会",
                                             },
                                     @"dianping":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id351091731?mt=8",
                                             @"id":@"351091731",
                                             @"name":@"大众点评",
                                             },
                                     @"sinaweibo":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id350962117?mt=8",
                                             @"id":@"350962117",
                                             @"name":@"微博",
                                             },
                                     @"weibosdk2.5":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id350962117?mt=8",
                                             @"id":@"350962117",
                                             @"name":@"微博",
                                             },
                                     @"weibosdk":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id350962117?mt=8",
                                             @"id":@"350962117",
                                             @"name":@"微博",
                                             },
                                     @"sinaweibosso":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id350962117?mt=8",
                                             @"id":@"350962117",
                                             @"name":@"微博",
                                             },
                                     @"sinaweibohd":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id350962117?mt=8",
                                             @"id":@"350962117",
                                             @"name":@"微博",
                                             },
                                     @"diditaxi":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id554499054?mt=8",
                                             @"id":@"554499054",
                                             @"name":@"滴滴打车",
                                             },
                                     @"kugouURL":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id472208016?mt=8",
                                             @"id":@"472208016",
                                             @"name":@"酷狗音乐",
                                             },
                                     @"qqmusic":@{
                                             @"url":@"https://itunes.apple.com/cn/app/id472208016?mt=8",
                                             @"id":@"472208016",
                                             @"name":@"酷狗音乐",
                                             },
                                     @"zhihu":@{
                                             @"url":@"https://itunes.apple.com/cn/app/%E7%9F%A5%E4%B9%8E-%E5%8F%91%E7%8E%B0%E6%9B%B4%E5%A4%A7%E7%9A%84%E4%B8%96%E7%95%8C/id432274380?mt=8",
                                             @"id":@"432274380",
                                             @"name":@"知乎",
                                             },
                                     };
    
    NSMutableDictionary *urlSchemesDic = [NSMutableDictionary dictionaryWithDictionary:mainUrlSchemes];
    NSString *path = [self urlSchemesPath];
    NSDictionary *registerURLSchemes = [NSDictionary dictionaryWithContentsOfFile:path];
    [urlSchemesDic addEntriesFromDictionary:registerURLSchemes];
    
    return urlSchemesDic;
    
}

@end
