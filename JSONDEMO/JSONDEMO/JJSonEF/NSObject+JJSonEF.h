//
//  NSObject+JJSonEF.h
//  JSONDEMO
//
//  Created by macbook on 16/5/17.
//  Copyright © 2016年 likejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JJSonEF)
/**
 *  序列化 json
 *
 *  @return NSData
 */
- (NSData  *)JSONData;
/**
 *  json 转换成数组(非直接转换成模型)
 *
 *  @return 数组
 */
- (id)objectWithJSONSafeObject;
/**
 *
 *
 *  @param keyPath 找到指定某一列的值
 *
 *  @return 应该是 Nsstring
 */
- (id)valueForComplexKeyPath:(NSString *)keyPath;
/**
 *  找到某一个 key
 *
 *  @param key
 *
 *  @return values
 */
- (NSString *)stringValueForComplexKeyPath:(NSString *)key;


/**
 *json数组转换成模型数组
 * @param  任何类型
 */
+ (NSMutableArray *)j_ObjectFromAnyOne:(id )object;
@end
