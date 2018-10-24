//
//  UserDataBase.m
//  DoctorApp
//
//  Created by 郭强 on 16/7/28.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "UserDataBase.h"

#import "DataBaseManage.h"

static NSString *const tableName = @"UserTable";

@implementation UserDataBase


#pragma mark - 创建表
+ (void)createTable{

    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];

    [dict setValue:@"TEXT" forKey:@"login_userid"];
    [dict setValue:@"TEXT" forKey:@"username"];
    [dict setValue:@"TEXT" forKey:@"portrait"];
    [dict setValue:@"TEXT" forKey:@"nickname"];
    [dict setValue:@"TEXT" forKey:@"token"];
    [dict setValue:@"TEXT" forKey:@"refresh_token"];
    [dict setValue:@"TEXT" forKey:@"rongytoken"];
    [dict setValue:@"TEXT" forKey:@"status"];
    [dict setValue:@"TEXT" forKey:@"is_last_user"];
    [DataBaseManage createTable:dict andTableName:tableName];
}

#pragma mark 删除用户数据
+ (void)deleteUserInfo{
    NSString* delete = [NSString stringWithFormat:@"delete from %@ ",tableName];
    [DataBaseManage executeSql:delete];
}

#pragma mark - 插入
+ (void)insertDataWithDict:(NSMutableDictionary *)dict{
   
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:EncodeStringFromDic(dict,@"id") forKey:@"login_userid"];
    [dic setValue:EncodeStringFromDic(dict,@"username") forKey:@"username"];
    [dic setValue:EncodeStringFromDic(dict,@"portrait") forKey:@"portrait"];
    [dic setValue:EncodeStringFromDic(dict,@"token") forKey:@"token"];
    [dic setValue:EncodeStringFromDic(dict,@"refresh_token") forKey:@"refresh_token"];
    [dic setValue:EncodeStringFromDic(dict,@"rongytoken") forKey:@"rongytoken"];
    [dic setValue:@"true" forKey:@"is_last_user"];
    [dic setValue:EncodeStringFromDic(dict,@"nickname") forKey:@"nickname"];
    [dic setValue:EncodeStringFromDic(dict,@"status") forKey:@"status"];
    [DataBaseManage executeInsert:tableName setColumnAndValue:dic];
}
#pragma mark 查找 数据
+ (NSDictionary*)selectUserInfo{
    
    NSString* sql = @"select * from UserTable where is_last_user = 'true'";
    
    NSMutableArray* arr = [DataBaseManage executeQuery:sql];
    
    for(NSMutableDictionary* dict in arr){
    
        NSString* userId = EncodeStringFromDic(dict,@"login_userid");
        [dict setValue:userId forKey:@"id"];
    }
    if(arr.count>0){
        return arr[0];
    }
    return nil;
}

#pragma mark 修改融云Token
+ (BOOL)updateRongytoken:(NSString*)rongytoken{

    NSString* sql =[NSString stringWithFormat:@"update %@ set rongytoken ='%@' where  login_userId='%@' ",tableName,rongytoken,APPDelegate.uid];
    
    return [DataBaseManage executeSql:sql];
}

#pragma mark 修改名称
+ (BOOL)updateNickName:(NSString*)name{

    NSString* sql =[NSString stringWithFormat:@"update %@ set nickname ='%@' where  login_userId='%@' ",tableName,name,APPDelegate.uid];
    
    return [DataBaseManage executeSql:sql];

}

#pragma mark 修改名称
+ (BOOL)updatePortrait:(NSString*)portrait{
    NSString* sql =[NSString stringWithFormat:@"update %@ set portrait ='%@' where  login_userId='%@' ",tableName,portrait,APPDelegate.uid];
    return [DataBaseManage executeSql:sql];
    
}

@end
