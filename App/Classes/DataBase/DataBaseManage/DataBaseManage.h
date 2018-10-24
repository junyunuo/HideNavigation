//
//  DataBaseManage.h
//  MahjongServiceApp
//
//  Created by guoqiang on 16/9/2.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface DataBaseManage : NSObject

+(NSString*)searchDataBaseFile;

/**
 *  打开数据库
 *
 *  @return <#return value description#>
 */
+(FMDatabase*)openDataBase;
/**
 *  创建表
 *
 *  @param dic       表字段
 *  @param tableName 表明
 */
+(void)createTable:(NSDictionary*)dic andTableName:(NSString*)tableName;
/**
 *  查询表数据
 *
 *  @param sql 查询语句
 *
 *  @return 返回数组
 */
+(NSMutableArray*)executeQuery:(NSString*)sql;

/**
 *  操作语句
 *
 *  @param tableName 表
 *  @param dic       字段
 *
 *  @return
 */
+(BOOL)executeInsert:(NSString*)tableName setColumnAndValue:(NSDictionary*)dic;
/**
 *  更新方法 包括 插入 删除 修改
 *
 *  @param sql
 *  @param tableName
 *
 *  @return
 */
+(BOOL)executeUpdate:(NSString*)sql andTableName:(NSString*)tableName;
/**
 *  更新方法 包括 插入 删除 修改
 *
 *  @param sql
 *  @param tableName
 *
 *  @return
 */
+(BOOL)executeSql:(NSString*)sql;

@end
