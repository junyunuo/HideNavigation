//
//  HttpRequestDemo.m
//  CalendarManagerApp
//
//  Created by guoqiang on 15/11/3.
//  Copyright © 2015年 guoqiang. All rights reserved.
//

#import "HttpRequestDemo.h"
#import "HttpRequestSign.h"


@implementation HttpRequestDemo
#pragma mark 请求网络数据例子
-(void)httpRequestData{
    
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];

    NSString* timestamp = GetTimestamp();
    NSString* passWord = MD5String(@"a123456");
    
    [body setValue:passWord forKey:@"a1"];
    [body setValue:@"2" forKey:@"type"];
    [body setValue:@"18675149171" forKey:@"uin"];
    
    [body setValue:@"2" forKey:@"client_type"];
    [body setValue:@"4" forKey:@"platform_id"];
    
    HttpRequestSign* httpRequestSing = [[HttpRequestSign alloc] init];

    //生成 签名
    NSString* sing = [httpRequestSing createRequestSing:body.mutableCopy orTimestamp:timestamp];
    [body setValue:sing forKey:@"sign"];
    [body setValue:timestamp forKey:@"timestamp"];

    [[AFNService shareInstance] postValueWithMethod:@"" andBody:body successBlock:^(SuccessModel *successModel) {
        
        NSLog(@"%@",successModel.result);
        
    } failBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}


@end
