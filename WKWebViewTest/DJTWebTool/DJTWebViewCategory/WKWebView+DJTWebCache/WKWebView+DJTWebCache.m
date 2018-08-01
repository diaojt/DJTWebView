//
//  WKWebView+DJTWebCache.m
//  WKWebViewTest
//
//  Created by Smy_D on 2018/8/1.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "WKWebView+DJTWebCache.h"

@implementation WKWebView (DJTWebCache)

// 获取当前北京时间
- (NSDate *)beijingTime
{
    NSDate *date = [NSDate date];
    NSTimeInterval inter = [[NSTimeZone systemTimeZone] secondsFromGMT];
    return [date dateByAddingTimeInterval:inter];
}

#pragma mark ======== 清除webView缓存 ========
- (void)clearWebCacheFinish:(void (^)(BOOL, NSError *))block
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes = [NSSet setWithArray:
                                    @[WKWebsiteDataTypeDiskCache,
                                      WKWebsiteDataTypeOfflineWebApplicationCache,
                                      WKWebsiteDataTypeMemoryCache,
                                      //WKWebsiteDataTypeCookies,
                                      WKWebsiteDataTypeLocalStorage,
                                      WKWebsiteDataTypeSessionStorage,
                                      WKWebsiteDataTypeIndexedDBDatabases,
                                      WKWebsiteDataTypeWebSQLDatabases
                                      ]];
        
        //date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            block ? block(YES, nil) : NULL;
        }];
        
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
        block ? block(YES,errors): NULL;
    }
    
}
#pragma mark ======== 清理缓存的方法，这个方法会清除缓存类型为 HTML 类型的文件 ========
- (void)clearHTMLCache
{
    // 取得library文件夹的位置
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    // 取得 bundle id，进行文件拼接
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    // 拼接缓存地址，具体目录为 App/Library/Caches/你的APPBundleID/fsCachedData
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleID];
    
    NSError *error;
    
    // 取得目录下所有的文件，取得文件数组
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // fileList是包含该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:webKitFolderInCachesfs error:&error];
    
    // 遍历文件组成的数组
    for(NSString * fileName in fileList){
        // 定位每个文件的位置
        NSString *path = [[NSBundle bundleWithPath:webKitFolderInCachesfs] pathForResource:fileName ofType:@""];
        
        // 将文件转换为 NSData类型的数据
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        
        // 如果 FileData 的长度大于2，说明 FileData 不为空
        if(fileData.length > 2)
        {
            // 创建两个用于显示文件类型的变量
            int char1 = 0;
            int char2 = 0;
            
            [fileData getBytes:&char1 range:NSMakeRange(0,1)];
            [fileData getBytes:&char2 range:NSMakeRange(1,1)];
            
            // 拼接两个变量
            NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
            
            // 如果该文件前四个字符是6033，说明是 HTML 文件，删除掉本地的缓存
            if ([numStr isEqualToString:@"6033"]) {
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",webKitFolderInCachesfs,fileName] error:&error];
                continue;
            }
        }
    }
}



@end
