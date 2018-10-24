//
//  WXLoginShare.h
//  NinthStreet
//
//  Created by zhucheng on 16/3/24.
//  Copyright © 2016年 CherryPocketTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//#define AppID @"wx9b893f8e82ce23e0"
//#define AppSecret @"ef778d60268495c37f13efd1033c3a32"

@protocol WXLoginShareDelegate <NSObject>

@optional
/**
 *  登录成功
 *
 *  @param dice 微信后台返回的数据
 */
- (void)WXLoginShareLoginSuccess:(NSDictionary *)dice;
/**
 *  登录失败
 *
 *  @param dice 微信后台返回的数据
 */
- (void)WXLoginShareLoginFail:(NSDictionary *)dice;

/**
 *  授权成功
 *
 *  @param code 微信后台返回的数据
 */
- (void)WXLoginAuthSuccess:(NSString *)code;

/**
 *  授权失败
 *
 *
 */
- (void)WXLoginAuthFailed;

/**
 *  支付成功
 *
 *
 */
- (void)WXPaySuccessed;
/**
 *  支付失败
 *
 *
 */
- (void)WXPayFailed:(NSString*)errStr;

/**
 *  分享成功
 *
 *
 */
-(void)WXShareSucceed;

/**
 *  分享失败
 *
 *
 */
-(void)WXShareFailed;


@end


@interface WXLoginShare : NSObject<WXApiDelegate>

@property (nonatomic,assign)id<WXLoginShareDelegate>delegate;
@property (nonatomic,retain)NSString * kWeiXinRefreshToken;

+ (WXLoginShare *)shareInstance;
/**
 *  注册ID
 */
- (void)WXLoginShareRegisterApp;
/**
 *  微信登录
 */
- (void)WXLogin;

-(BOOL)isWXInstalled;

- (void)WXSendWebToWX:(int)scene title:(NSString*)nssTitle description:(NSString*)nssDesc image:(UIImage*)img url:(NSString*)nssUrl;

@end
