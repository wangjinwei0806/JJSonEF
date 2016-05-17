//
//  ViewController.m
//  JSONDEMO
//
//  Created by macbook on 16/5/17.
//  Copyright © 2016年 likejin. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+JJSonEF.h"
#import <AFNetworking.h>
#import "TestOne.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setJson];
}
- (void)setJson{
 NSDictionary *  _testDictionary = @{
                        @"parent" : @{
                                @"name" : @"Nathan",
                                @"children" : @[ @{
                                                     @"name" : @"adam",
                                                     @"apple_products" : @[ @{
                                                                                @"title"		: @"macbook",
                                                                                @"price"		: @1399.99,
                                                                                @"date_bought"	: [NSDate dateWithTimeInterval:-22342 sinceDate:[NSDate date]],
                                                                                @"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
                                                                                },
                                                                            @{
                                                                                @"title"		: @"mac mini",
                                                                                @"price"		: @599.99,
                                                                                @"date_bought"	: [NSDate dateWithTimeInterval:-30223 sinceDate:[NSDate date]],
                                                                                @"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
                                                                                },
                                                                            @{
                                                                                @"title"		: @"iphone",
                                                                                @"price"		: @199.99,
                                                                                @"date_bought"	: [NSDate dateWithTimeInterval:-123453 sinceDate:[NSDate date]],
                                                                                @"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
                                                                                }]
                                                     },
                                                 @{
                                                     @"name" : @"amanda",
                                                     @"apple_products" : @[ @{
                                                                                @"title"		: @"nano",
                                                                                @"price"		: @299.99,
                                                                                @"date_bought"	: [NSDate dateWithTimeInterval:-123453 sinceDate:[NSDate date]],
                                                                                @"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
                                                                                }]
                                                     },
                                                 @{
                                                     @"name" : @"andrew",
                                                     @"apple_products" : @[ @{
                                                                                @"title"		: @"ipad",
                                                                                @"price"		: @499.99,
                                                                                @"date_bought"	: [NSDate dateWithTimeInterval:-2452342 sinceDate:[NSDate date]],
                                                                                @"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
                                                                                },
                                                                            @{
                                                                                @"title"		: @"ipod touch",
                                                                                @"price"		: @399.99,
                                                                                @"date_bought"	: [NSDate dateWithTimeInterval:-430223 sinceDate:[NSDate date]],
                                                                                @"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
                                                                                }]
                                                     }]
                                }
                        };
    
    
     NSString *dt = [_testDictionary  valueForComplexKeyPath:@"parent.name"];
     NSLog(@"%@",dt);
    NSString *dt2 = [_testDictionary valueForComplexKeyPath:@"parent.children[1].name"];
      NSLog(@"%@",dt2);
    NSString *dt3 = [_testDictionary stringValueForComplexKeyPath:@"parent.children[last].apple_products[last].date_bought"];
      NSLog(@"%@",dt3);
}
/**
 *  网络请求的 json 序列化
 */
- (void)test2{
    //http://api.budejie.com/api/api_open.php?a=list&c=subscribe&category_id=35
    //http://news.coolban.com/Api/Index/news_list/app/2/cat/3/limit/20/time/1450854446/type/0?channel=appstore&uuid=F937C67E-AE3D-4A17-895C-FEBCBF7F1115&net=5&model=iPhone&ver=1.0.5
 [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php?a=list&c=subscribe&category_id=35" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSArray *arry = [TestOne  j_ObjectFromAnyOne:responseObject[@"list"]];
     
     for (TestOne *mode in arry) {
         NSLog(@"%@",mode.introduction);
     }
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
 }];
}

@end
