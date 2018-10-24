//
//  DataBase.h
//  AppDemo
//
//  Created by guoqiang on 16/1/4.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface DataBaseClass : NSObject

+(NSString*)searchDataBaseFile;
+(FMDatabase*)openDataBase;
+(void)createTable:(NSDictionary*)dic andTableName:(NSString*)tableName;
+(void)createAllTable;
+(NSMutableArray*)executeQuery:(NSString*)sql;
+(BOOL)executeInsert:(NSString*)tableName setColumnAndValue:(NSDictionary*)dic;
#pragma mark 更新方法 包括 插入 删除 修改
+(BOOL)executeUpdate:(NSString*)sql andTableName:(NSString*)tableName;
+(BOOL)executeSql:(NSString*)sql;

@end
