//
//  UserDataBase.h
//  DoctorApp
//
//  Created by 郭强 on 16/7/28.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataBase : NSObject

/**
 *  创建表
 */
+ (void)createTable;

+ (void)insertDataWithDict:(NSMutableDictionary *)dict;

+ (NSDictionary*)selectUserInfo;

#pragma mark 删除用户数据
+ (void)deleteUserInfo;


/**
 *  修改 融云token
 *
 *  @param rongytoken
 *
 *  @return
 */
+ (BOOL)updateRongytoken:(NSString*)rongytoken;


+ (BOOL)updateNickName:(NSString*)name;

#pragma mark 修改名称
+ (BOOL)updatePortrait:(NSString*)portrait;

@end
