//
//  NSObject+JJSonEF.m
//  JSONDEMO
//
//  Created by macbook on 16/5/17.
//  Copyright © 2016年 likejin. All rights reserved.
//

#import "NSObject+JJSonEF.h"
#import <objc/runtime.h>
@implementation NSObject (JJSonEF)

- (NSData *)JSONData{
    return [NSJSONSerialization dataWithJSONObject:[self objectWithJSONSafeObject] options:0 error:nil];
}
/**
 * json数组转换成模型数组
 * @param  任何类型
 */
+ (NSMutableArray *)j_ObjectFromAnyOne:(id )object{
    NSMutableArray *arry =[NSMutableArray array];
    NSArray *selfName = [self fitterPropertys];//获取模型的所以属性
    if ([object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSSet class]]) { //数组类型
        for (NSDictionary * models  in object) {
            id tempobj = [[NSClassFromString(NSStringFromClass(self)) alloc] init]; //将模型转换成对象,并实例化
            //Class rectClass = [NSClassFromString([self class]) class];
            for (id keys in selfName) {
                NSString *valus = [models valueForKey:keys];
                [tempobj setValue:valus forKey:keys];
            }
            [arry addObject:tempobj];
        }
    } //直接是字典类型

    return arry;
}

/**
 *动态获取模型的属性
 */
- (NSArray *)fitterPropertys{
    NSMutableArray *props =[NSMutableArray array];
    unsigned int outCount,i;
    
 objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for ( i = 0; i<outCount; i++) {
              const char* char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    return props;
}
/**
 *找到指定的某一个
 */
- (id)valueForComplexKeyPath:(NSString *)keyPath {
    
    id currentObject = self;
    
    NSMutableString *path			= [NSMutableString string];
    NSMutableString *subscriptKey	= [NSMutableString string];
    NSMutableString *string			= path;
    
    for (int i = 0; i < keyPath.length; i++) {
        
        unichar c = [keyPath characterAtIndex:i];
        
        if (c == '[') {
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@". \n"]];
            currentObject = [currentObject valueForKeyPath:trimmedPath];
            [subscriptKey setString:@""];
            string = subscriptKey;
            continue;
        }
        
        if (c == ']') {
            if (!currentObject) return nil;
            if (![currentObject isKindOfClass:[NSArray class]]) return nil;
            NSUInteger index = 0;
            if ([subscriptKey isEqualToString:@"first"]) {
                index = 0;
            }
            else if ([subscriptKey isEqualToString:@"last"]) {
                index = [currentObject count] - 1;
            }
            else {
                index = [subscriptKey intValue];
            }
            if ([currentObject count] == 0) return nil;
            if (index > [currentObject count] - 1) return nil;
            currentObject = [currentObject objectAtIndex:index];
            if ([currentObject isKindOfClass:[NSNull class]]) return nil;
            [path setString:@""];
            string = path;
            continue;
        }
        
        [string appendString:[NSString stringWithCharacters:&c length:1]];
        
        if (i == keyPath.length - 1) {
            NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@". \n"]];
            currentObject = [currentObject valueForKeyPath:trimmedPath];
            break;
        }
    }
    
    return currentObject;
}

- (NSString *)stringValueForComplexKeyPath:(NSString *)key {
    id object = [self valueForComplexKeyPath:key];
    
    if ([object isKindOfClass:[NSString class]])
        return object;
    
    if ([object isKindOfClass:[NSNull class]])
        return @"";
    
    if ([object isKindOfClass:[NSNumber class]])
        return [object stringValue];
    
    if ([object isKindOfClass:[NSDate class]])
        return [NSString stringWithFormat:@"%@", [self safeObjectFromObject:object]];
    
    return [object description];
}
- (id)objectWithJSONSafeObject{
    if ([self isKindOfClass:[NSDictionary class]]) {
        return  [self safeDictionaryFromDictionary:self];
    }
    else if ([self isKindOfClass:[NSArray class]]||[self isKindOfClass:[NSSet class]]){
        return  [self safeArrayFromArray:self];
    }else{
        return  [self safeObjectFromObject:self];
    }
}

#pragma mark - Private Methods
/*
 * NSMutableDictionary to NSMutableDictionary
 */
- (id)safeDictionaryFromDictionary:(id)dictionary{
    NSMutableDictionary *strDictionary = [NSMutableDictionary dictionary];
    for (id key in [dictionary allKeys]) {
        id objects = [dictionary valueForKey:key];
        
        if ([objects isKindOfClass:[NSDictionary class]]) { //字典
             [strDictionary setObject:[objects safeDictionaryFromDictionary:objects ]forKey:key];
        }else if ([objects isKindOfClass:[NSArray class]]){ //数组
             [strDictionary setObject:[objects safeArrayFromArray:objects ]forKey:key];
        }else{ //字符串
            [strDictionary setObject:[objects safeObjectFromObject:objects ]forKey:key];
        }
    }
    return   strDictionary;
}

- (id)safeArrayFromArray:(id)array{
    NSMutableArray *strArrary =[NSMutableArray array];
    for (id object  in array) {
        if ([object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSSet class]]) {
            [strArrary addObject:[self safeArrayFromArray:object]];
        }else if ([object isKindOfClass:[NSDictionary class]]){
            [strArrary addObject:[self safeDictionaryFromDictionary:object]];
        }else{
            [strArrary addObject:[self safeObjectFromObject:object]];
        }
    }
    return strArrary;
}

- (id)safeObjectFromObject:(id)object{
    NSArray *strClass= @[[NSString class],[NSNumber class],[NSNull class]];
    for (Class c  in strClass) {
        if ([object isKindOfClass:c])
            return  object;
    }
    //这里有点不明白
    if ([object isKindOfClass:[NSDate class]]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSString *ISOString = [formatter stringFromDate:object];
        return ISOString;
    }
    return  [object description];
}
@end
