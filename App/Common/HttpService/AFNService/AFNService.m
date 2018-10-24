//  Created by 郭强 on 16/7/28.
//  Copyright © 2016年 郭强. All rights reserved.

#import "AFNService.m"
#import "HttpRequestSign.h"

@implementation AFNService

static AFNService * _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance ;
}

#pragma mark 请求数据
- (AFHTTPSessionManager*)postValueWithMethod:(NSString *)method andBody:(NSDictionary *)body successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock
{
    
    
  //  [self showCustomProgressView];

    
    HttpRequestSign* httpRequestSing = [[HttpRequestSign alloc] init];
    NSString* timestamp = GetTimestamp();
    if(![NSString isBlankString:APPDelegate.token]){
        [body setValue:APPDelegate.token forKey:@"token"];
    }
    
    //生成 签名
    NSString* sing = [httpRequestSing createRequestSing:body.mutableCopy orTimestamp:timestamp];
   [body setValue:sing forKey:@"sign"];
   [body setValue:timestamp forKey:@"timestamp"];
   [body setValue:@"2" forKey:@"client_type"];
   [body setValue:MaxSystemVersion forKey:@"version"];

    NSString * postUrl = [NSString stringWithFormat:@"%@",BASE_URL];
    postUrl = [postUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:postUrl]];
    
    NSMutableSet *acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes mutableCopy];
    [acceptableContentTypes addObject:@"text/html"];
    sessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    [sessionManager.securityPolicy setAllowInvalidCertificates:YES];
    
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString* requestUrl=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,method,[body JSONFragment]];
    
    NSLog(@"%@",requestUrl);

    [sessionManager POST:method parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
     
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideCustomProgressView];
        NSLog(@"request 回调成功-----------------");

        NSData *responseData = responseObject;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * response =  [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        if(!dict){
            NSLog(@"request出错-------：%@",response);
        }
        
        [self hideCustomProgressView];

        
        SuccessModel *model=[[SuccessModel alloc] initWithDictionary:dict];
        if([model.code integerValue] == 1){
            successBlock(model);
        }else if([model.code isEqualToString:@"-300"]||[model.code isEqualToString:@"-2000"]||[model.code isEqualToString:@"-500"]||[model.code isEqualToString:@"-6000"]){
            successBlock(model);
        }else if([model.code isEqualToString:@"-101"]||[model.code isEqualToString:@"-102"]||[model.code isEqualToString:@"-103"]||[model.code isEqualToString:@"-1001"]||[model.code isEqualToString:@"-1004"]){
        
            [[NSNotificationCenter defaultCenter] postNotificationName:PopLoginViewController object:self userInfo:nil];
        }else{
            successBlock(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [self hideCustomProgressView];

        NSDictionary * userInfo = error.userInfo;
        NSString* description = userInfo[@"NSLocalizedDescription"];

        if (failBlock!=nil) {
            failBlock(description);
        }
    }];
    return sessionManager;
}

#pragma marck 上传文件
-(AFHTTPSessionManager *)postUpLoadFileWithMethod:(NSString*)method andFile:(NSData*)data isImageType:(NSString*)imageType successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock
{
    HttpRequestSign* httpRequestSing = [[HttpRequestSign alloc] init];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    NSString* timestamp = GetTimestamp();
    
    NSArray* array = [imageType componentsSeparatedByString:@","];
    if(array.count >1){
        [body setValue:array[0] forKey:@"type"];
        [body setValue:array[1] forKey:@"is_friend_ring"];

    }else{
        [body setValue:imageType forKey:@"type"];

    }
    

    if(![NSString isBlankString:APPDelegate.token]){
        [body setValue:APPDelegate.token forKey:@"token"];
    }
    //生成 签名
    NSString* sing = [httpRequestSing createRequestSing:body.mutableCopy orTimestamp:timestamp];
    
    [body setValue:sing forKey:@"sign"];
    [body setValue:timestamp forKey:@"timestamp"];
    
    
    NSString* requestUrl=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,method,[body JSONFragment]];
    
    NSLog(@"%@",requestUrl);

    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableSet *acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes mutableCopy];
    [acceptableContentTypes addObject:@"text/html"];
    
    sessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sessionManager POST:method parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"filedata" fileName:@"*.jpg" mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideCustomProgressView];

        
        NSData *responseData = responseObject;
        NSString * response =  [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary* dict = [response JSONValue];
        SuccessModel *model=[[SuccessModel alloc] initWithDictionary:dict];
        if (successBlock!=nil) {
             if([model.code isEqualToString:@"-101"]||[model.code isEqualToString:@"-102"]||[model.code isEqualToString:@"-103"]||[model.code isEqualToString:@"-1001"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:PopLoginViewController object:self userInfo:nil];
//                [JPUSHService setTags:nil alias:@"zzz" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
//                }];
             }else{
                 successBlock(model);
             }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideCustomProgressView];

        NSLog(@"%@", error.userInfo);
        NSDictionary * userInfo = error.userInfo;
        NSString* description = userInfo[@"NSLocalizedDescription"];
        if (failBlock!=nil) {
            failBlock(description);
        }
    }];

    return sessionManager;
}


- (AFHTTPSessionManager *)postUpLoadFileWithMethod:(NSString*)method andFile:(NSData*)data andBody:(NSDictionary*)dataDict successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    HttpRequestSign* httpRequestSing = [[HttpRequestSign alloc] init];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    NSString* timestamp = GetTimestamp();
    
    [body addEntriesFromDictionary:dataDict];
    
    if(![NSString isBlankString:APPDelegate.token]){
        [body setValue:APPDelegate.token forKey:@"token"];
    }
    //生成 签名
    NSString* sing = [httpRequestSing createRequestSing:body.mutableCopy orTimestamp:timestamp];
    
    [body setValue:sing forKey:@"sign"];
    [body setValue:timestamp forKey:@"timestamp"];
    
    
    NSString* requestUrl=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,method,[body JSONFragment]];
    
    NSLog(@"%@",requestUrl);
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableSet *acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes mutableCopy];
    [acceptableContentTypes addObject:@"text/html"];
    
    sessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sessionManager POST:method parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"filedata" fileName:@"*.jpg" mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideCustomProgressView];

        
        NSData *responseData = responseObject;
        NSString * response =  [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSDictionary* dict = [response JSONValue];
        SuccessModel *model=[[SuccessModel alloc] initWithDictionary:dict];
        if (successBlock!=nil) {
            successBlock(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self hideCustomProgressView];

        
        NSLog(@"%@", error.userInfo);
        NSDictionary * userInfo = error.userInfo;
        NSString* description = userInfo[@"NSLocalizedDescription"];
        if (failBlock!=nil) {
            failBlock(description);
        }
    }];
    
    return sessionManager;
}


#pragma mark - qiniu 上传图片

- (void)uploadImageFileWithFile:(NSData *)data
                   successBlock:(void(^)(QNResponseInfo *info, NSString *key, NSDictionary *resp))block {
    
    NSString *token = APPDelegate.qiniuToken;
    
    if([NSString isBlankString:token]){
        
    }
    
    if (![AFNService shareInstance].uploadManager) {
        [AFNService shareInstance].uploadManager = [[QNUploadManager alloc] init];
    }
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time * 1000] longLongValue];
    NSString *dateString = [NSString stringWithFormat:@"image/%llu", dTime];
    NSLog(@"%@",dateString);
    [self.uploadManager putData:data key:dateString token:token
                       complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                           if (block) {
                               block(info, key, resp);
                           }
                       } option:nil];
}

- (void)getQiNiuToken {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [[AFNService shareInstance] postValueWithMethod:@"public/qiniu/getToken" andBody:paramDic successBlock:^(SuccessModel *successModel) {
        if([successModel.code integerValue] == 1) {
            NSDictionary *resultDict = successModel.result;
            APPDelegate.qiniuToken = EncodeStringFromDic(resultDict, @"token");
            APPDelegate.fileUrl = EncodeStringFromDic(resultDict, @"url");
       
        }else {
            
        }
    } failBlock:^(NSString *errorMessage) {
        
    }];
}




@end
