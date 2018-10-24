//
//  SingletonShared.h
//  OneHome
//
//  Created by 郭强 on 16/3/24.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonShared : NSObject

+(SingletonShared*)sharedInstance;

//是否禁用手势 全局
@property(nonatomic,assign)BOOL isBanGesture;



/**
 *  如果是从通知栏进入 添加标示条件 为notifyPusy 表示是从通知栏进入
 *
 *  @param
 */
+ (void)addNotifyPushFlag:(NSDictionary*)jumpDic;

/**
 * 将通知栏标示条件置空，以防通过正常情况下导航栏进入该页面时无法返回上一级页面
 */
+(void)cleanNotifyPushFlag;
/**
 *  获取通知栏标示
 *
 *  @return
 */
+ (BOOL)getNotifyPushFlag;
/**
 *  #pragma mark 获取通知信息
 */
+ (NSDictionary*)getNotifyUserInfo;


#pragma mark 记录最后一次的登录用户数据
+ (void)setLastUserLoginInfo:(NSDictionary*)dict;
#pragma mark 获取最后一次登录的用户数据
+ (NSDictionary*)getLastUserLoginInfo;

/**
 *  芝麻信用分数
 */
@property(nonatomic,strong)NSDictionary* zmxyDict;
@property(nonatomic,assign)BOOL isSelf;
@property(nonatomic,strong)NSString* nickName;
@property(nonatomic,strong)NSString* headUrl;

#pragma mark 添加黑名单
+ (void)setHeiMingDan:(NSMutableArray*)array wityType:(NSInteger)type;

#pragma mark 获取黑名单
+ (NSMutableArray*)getHeiMingDan:(NSInteger)type;


@end

