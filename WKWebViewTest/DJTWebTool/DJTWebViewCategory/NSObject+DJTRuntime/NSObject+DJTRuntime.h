//
//  NSObject+DJTRuntime.h
//  WKWebViewTest
//
//  Created by Smy_D on 2018/7/31.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DJTRuntime)

/**
 将“字典数组”转换成当前模型的对象数组

 @param array 字典数组
 @return 返回模型对象的数组
 */
+ (NSArray *)djt_objectsWithArray:(NSArray *)array;


/**
 返回当前类的所有属性列表

 @return 属性名称
 */
+ (NSArray *)djt_propertysList;

/**
 返回当前类的所有成员变量数组

 @return 当前类的所有成员变量
 */
+ (NSArray *)djt_ivarList;

/**
 返回当前类的所有方法

 @return 当前类的所有方法
 */
+ (NSArray *)djt_methodList;

/**
 返回当前类的所有协议

 @return 当前类的所有协议
 */
+ (NSArray *)djt_protocolList;


@end
