//
//  UserBaseModel.h
//  YY_yijia
//
//  Created by guoqiang on 15-5-8.
//  Copyright (c) 2015年 com.yiyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBaseModel : NSObject
+(UserBaseModel*)sharedInstance;

+(void)saveUserInfoModel:(NSDictionary *)user;
+(NSString*)Decrypt:(NSString*)value;

+(void)cleanLocalUserData;


+ (NSString*)getUserStatus;

@end
