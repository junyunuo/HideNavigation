//
//  SingletonShared.m
//  OneHome
//
//  Created by 郭强 on 16/3/24.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import "SingletonShared.h"

@implementation SingletonShared

+(SingletonShared*)sharedInstance{
    static SingletonShared *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[SingletonShared alloc] init];
    });
    return sharedInstance;
}
#pragma mark 获取通知栏标示
+ (BOOL)getNotifyPushFlag{
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    NSString * type = [pushJudge objectForKey:@"pushControllerFlag"];
    //如果是从通知栏进入
    if([type isEqualToString:@"notifyPush"]){
        return true;
    }
    return false;
}
#pragma mark 获取通知信息
+ (NSDictionary*)getNotifyUserInfo{
    
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    NSString * notifyUserInfo = [pushJudge objectForKey:@"jumpData"];
    NSDictionary* dic;
    if(![NSString isBlankString:notifyUserInfo]){
        dic = (NSDictionary*)[notifyUserInfo JSONValue];
        return dic;
    }
    return dic;
}

#pragma mark 如果是从通知栏进入 添加标示条件 为notifyPusy 表示是从通知栏进入
+ (void)addNotifyPushFlag:(NSDictionary*)jumpDic{
    //保存跳转数据
    if(jumpDic){
        NSString* jumpData = [jumpDic JSONFragment];
        NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@"share" forKey:@"shareFlag"];
        [pushJudge setObject:jumpData forKey:@"jumpData"];
        [pushJudge synchronize];
    }
}

#pragma mark 将通知栏标示条件置空，以防通过正常情况下导航栏进入该页面时无法返回上一级页面
+ (void)cleanNotifyPushFlag{
    
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"" forKey:@"pushControllerFlag"];
    [pushJudge setObject:@"" forKey:@"jumpData"];
    [pushJudge synchronize];
}

#pragma mark 记录最后一次的登录用户数据
+ (void)setLastUserLoginInfo:(NSDictionary*)dict{
    if(dict){
        NSString* str = [dict JSONFragment];
        NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:str forKey:@"last_login"];
        [pushJudge synchronize];
    }
}

#pragma mark 获取最后一次登录的用户数据
+ (NSDictionary*)getLastUserLoginInfo{
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    NSString * userInfo = [pushJudge objectForKey:@"last_login"];
    NSDictionary* dic;
    if(![NSString isBlankString:userInfo]){
        dic = (NSDictionary*)[userInfo JSONValue];
        return dic;
    }
    return dic;
}

#pragma mark 添加黑名单
+ (void)setHeiMingDan:(NSMutableArray*)array wityType:(NSInteger)type{
    if(array.count >0){
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:array forKey:@"list"];
        NSString* userInfo = [dic JSONFragment];
        NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
        if(type == 1){
            //私聊用户
            [pushJudge setObject:userInfo forKey:@"heimingdan"];
        }else{
            [pushJudge setObject:userInfo forKey:@"heimingdan_group"];
        }
        [pushJudge synchronize];
    }
}

#pragma mark 获取黑名单
+ (NSMutableArray*)getHeiMingDan:(NSInteger)type{
    
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    NSString * userInfo;
    if(type == 1){
        userInfo = [pushJudge objectForKey:@"heimingdan"];
    }else{
        userInfo = [pushJudge objectForKey:@"heimingdan_group"];
    }
    NSArray* array;
    if(![NSString isBlankString:userInfo]){
       NSDictionary* dic = (NSDictionary*)[userInfo JSONValue];
        if(dic.count >0){
            array = EncodeArrayFromDic(dic,@"list");
            NSMutableArray* mArray = [[NSMutableArray alloc] initWithArray:array];
            return mArray;
        }
    }
    return [[NSMutableArray alloc] init];
}

@end

