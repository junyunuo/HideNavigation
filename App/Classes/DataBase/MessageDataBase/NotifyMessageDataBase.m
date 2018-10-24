//
//  NotifyMessageDataBase.m
//  DoctorApp
//
//  Created by 郭强 on 16/8/12.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "NotifyMessageDataBase.h"
#import "DataBaseClass.h"

static NSString *const tableName = @"NotifyMessageTable";

@implementation NotifyMessageDataBase

#pragma mark - 创建表
+ (void)createTable{
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"TEXT" forKey:@"notify_id"];
    [dict setValue:@"TEXT" forKey:@"title"];
    [dict setValue:@"TEXT" forKey:@"msginfo"];
    [dict setValue:@"timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'" forKey:@"insert_time"];
    [dict setValue:@"TEXT" forKey:@"is_readed"];
    [dict setValue:@"TEXT" forKey:@"content"];
    [dict setValue:@"TEXT" forKey:@"createtime"];
    [dict setValue:@"TEXT" forKey:@"login_userId"];
    
    [DataBaseClass createTable:dict andTableName:tableName];
}

#pragma makr 插入数据
+ (void)insertDataWithDict:(NSMutableArray *)array{
    
    for(NSMutableDictionary* dict in array){
        
        
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        
        [dic setValue:EncodeStringFromDic(dict,@"id") forKey:@"notify_id"];
        [dic setValue:EncodeStringFromDic(dict,@"title") forKey:@"title"];
        [dic setValue:EncodeStringFromDic(dict,@"createtime") forKey:@"createtime"];
        [dic setValue:EncodeStringFromDic(dict,@"content") forKey:@"content"];
        [dic setValue:EncodeStringFromDic(dict,@"msginfo") forKey:@"msginfo"];
        [dic setValue:@"0" forKey:@"is_readed"];
        [dic setValue:APPDelegate.uid forKey:@"login_userId"];
        
        [DataBaseClass executeInsert:tableName setColumnAndValue:dic];
    }
}


#pragma mark 查询为读消息
+ (NSMutableArray*)selectMessageForNoReaded{
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSString* sql = [NSString stringWithFormat:@"select * from %@ where login_userId = '%@' and is_readed ='0'",tableName,APPDelegate.uid];
    
    array = [DataBaseClass executeQuery:sql];
    
    return (NSMutableArray*)array;
    //return (NSMutableArray*)[[array reverseObjectEnumerator] allObjects];
}

#pragma mark 获取全部消息
+ (NSMutableArray*)selectAllMessage{
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSString* sql = [NSString stringWithFormat:@"select * from %@ where login_userId = '%@' order by id desc",tableName,APPDelegate.uid];
    
    array = [DataBaseClass executeQuery:sql];
    
    return (NSMutableArray*)array;
    //return (NSMutableArray*)[[array reverseObjectEnumerator] allObjects];
}

#pragma mark 把消息改为已读状态
+(BOOL)updateMessageReadedWithMessageId:(NSString*)messageId{
    
    NSString* sql =[NSString stringWithFormat:@"update %@ set is_readed ='1' where  id = '%@' and login_userId='%@' ",tableName,messageId,APPDelegate.uid];
    
    return [DataBaseClass executeSql:sql];
}

#pragma mark 获取未读消息
+ (NSMutableArray*)getMessageNoReaded{
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSString* sql = [NSString stringWithFormat:@"select * from %@ where is_readed ='0' and login_userId = '%@'",tableName,APPDelegate.uid];
    
    array = [DataBaseClass executeQuery:sql];
    
    return array;
}

/**
 *  删除消息
 *
 *  @return
 */
+ (BOOL)deleteNotifyMessage{
    
    
    NSString* sql = [NSString stringWithFormat:@"delete from %@ where login_userId = '%@'",tableName,APPDelegate.uid];
    
    
    return [DataBaseClass executeSql:sql];
    
}

+ (BOOL)deleteMessageById:(NSString*)messageId{
    
    
    
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where login_userId = '%@' and id = '%@'",tableName,APPDelegate.uid,messageId];
    
    return [DataBaseClass executeSql:sql];
    
}


@end
