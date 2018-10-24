//  Created by 郭强 on 16/7/28.
//  Copyright © 2016年 郭强. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SuccessModel.h"
#import <QiniuSDK.h>

typedef void (^successBlock)(SuccessModel *successModel);
typedef void (^failBlock)(NSString *errorMessage);

@interface AFNService : NSObject
@property (nonatomic, strong) QNUploadManager *uploadManager;

+(instancetype) shareInstance;

/**
 * 请求服务端数据
 */
-(AFHTTPSessionManager *)postValueWithMethod:(NSString *)method andBody:(NSDictionary *)body successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


/**
 * 上传文件 如图片
 */
- (AFHTTPSessionManager *)postUpLoadFileWithMethod:(NSString*)method andFile:(NSData*)data isImageType:(NSString*)imageType successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


/**
 *  上传文件
 */
- (AFHTTPSessionManager *)postUpLoadFileWithMethod:(NSString*)method andFile:(NSData*)data andBody:(NSDictionary*)dataDict successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


/**
 七牛上传图片
 */
- (void)uploadImageFileWithFile:(NSData *)data
                   successBlock:(void(^)(QNResponseInfo *info, NSString *key, NSDictionary *resp))block;


@end
