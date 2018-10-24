//
//  DataBase.m
//  AppDemo
//
//  Created by guoqiang on 16/1/4.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import "DataBaseClass.h"

__strong static FMDatabase *_sharedDatabase;

#define DBFileName @"Test"

@implementation DataBaseClass


#pragma mark --- 查找本地数据库文件 如果没有则创建
+(NSString*)searchDataBaseFile{
    //查找本地数据库路径
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                               NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    //往应用程序路径中添加数据库文件名称，把它们拼接起来， 这里用到了宏定义（目的是不易出错)
    NSString* dbFilePath= [documentFolderPath stringByAppendingPathComponent:DBFileName];
    //通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbFilePath];
    if (isExist) {
    }
    return dbFilePath;
}
#pragma mark --- 打开数据
+(FMDatabase*)openDataBase{
    NSString* fileName=[self searchDataBaseFile];
    return [FMDatabase databaseWithPath:fileName];
}

#pragma mark 创建表 
+(void)createTable:(NSDictionary*)dic andTableName:(NSString*)tableName{
        
    NSMutableArray* arr=[[NSMutableArray alloc] init];
    for(NSString* key in [dic allKeys]){
        [arr addObject:[NSString stringWithFormat:@"%@ %@",key,[dic objectForKey:key]]];
    }
    NSString* str=[arr componentsJoinedByString:@","];
    NSString* sql=[NSString stringWithFormat:@"create table if not exists '%@'(id integer primary key autoincrement,%@) ",tableName,str];
    NSString *fileName = [self searchDataBaseFile];
    
    _sharedDatabase = [FMDatabase databaseWithPath:fileName];
    [_sharedDatabase open];
    BOOL res = [_sharedDatabase executeUpdate:sql];
    if (res) {
        NSLog(@"创建%@成功",tableName);
    }
    else{
        NSLog(@"创建%@失败",tableName);
    }
    [_sharedDatabase close];
}



#pragma mark 创建表
+(void)createAllTable{


    NSMutableArray* arr=[[NSMutableArray alloc] init];
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    [dic setObject:@"TEXT" forKey:@"themeId"];
    [dic setObject:@"id" forKey:@"userId"];
    [dic setObject:@"TEXT" forKey:@"themeType"];
    [dic setObject:@"TEXT" forKey:@"roomType"];
    
    
    for(NSString* key in [dic allKeys]){
        [arr addObject:[NSString stringWithFormat:@"%@ %@",key,[dic objectForKey:key]]];
    }

    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        NSString *fileName = [self searchDataBaseFile];
        _sharedDatabase = [FMDatabase databaseWithPath:fileName];
        [_sharedDatabase open];
        [_sharedDatabase close];
    });
}

#pragma mark 更新方法 包括 插入 删除 修改
+(BOOL)executeUpdate:(NSString*)sql andTableName:(NSString*)tableName{
    
        NSString *fileName = [self searchDataBaseFile];
        _sharedDatabase = [FMDatabase databaseWithPath:fileName];
        [_sharedDatabase open];
        BOOL res = [_sharedDatabase executeUpdate:sql];
        if (res) {
            NSLog(@"executeUpdate%@成功",tableName);
        }
        else{
            NSLog(@"executeUpdate%@失败",tableName);
        }
        [_sharedDatabase close];
        return res;
}

#pragma mark 插入语句
+(BOOL)executeInsert:(NSString*)tableName setColumnAndValue:(NSDictionary*)dic{

    NSMutableArray* keyArray=[[NSMutableArray alloc] init];
    NSMutableArray* valuesArray=[[NSMutableArray alloc] init];
    for(NSString* key in [dic allKeys]){
        NSString* columns=[NSString stringWithFormat:@"'%@'",key];
        NSString* value=[NSString stringWithFormat:@"'%@'",[dic objectForKey:key]];
        [keyArray addObject:columns];
        [valuesArray addObject:value];
    }
    NSString* column=[keyArray componentsJoinedByString:@","];
    NSString* values=[valuesArray componentsJoinedByString:@","];
   
    
    NSString* sql=[NSString stringWithFormat:@"insert or replace into %@(%@) values(%@)",tableName,column,values];
    
        NSString *fileName = [self searchDataBaseFile];
        _sharedDatabase = [FMDatabase databaseWithPath:fileName];
        [_sharedDatabase open];
        BOOL res = [_sharedDatabase executeUpdate:sql];
        if (res) {
            NSLog(@"插入%@成功",tableName);
        }
        else{
            NSLog(@"插入%@失败",tableName);
        }
        [_sharedDatabase close];
    return res;
}

#pragma mark 查找表数据
+(NSMutableArray*)executeQuery:(NSString*)sql{
    NSMutableArray* resultArray=[[NSMutableArray alloc] init];
   

        NSString *fileName = [self searchDataBaseFile];
        _sharedDatabase = [FMDatabase databaseWithPath:fileName];
        [_sharedDatabase open];
        FMResultSet* result = [_sharedDatabase executeQuery:sql];
        NSMutableDictionary* columnDic;
        int i=0;
        while ([result next]){
            i++;
            if(i<2){
                 columnDic=[result columnNameToIndexMap];
            }
            NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
            for(NSString* key in [columnDic allKeys]){
                if(![NSString isBlankString:[result stringForColumn:key]]){
                    [dic setObject:[result stringForColumn:key] forKey:key];
                }
            }
            [resultArray addObject:dic];
        }
        [_sharedDatabase close];
    return resultArray;
}

#pragma mark 根据Sql语句执行操作
+(BOOL)executeSql:(NSString *)sql{
    NSString *fileName = [self searchDataBaseFile];
    _sharedDatabase = [FMDatabase databaseWithPath:fileName];
    [_sharedDatabase open];
    BOOL result=[_sharedDatabase executeUpdate:sql];
    [_sharedDatabase close];
    return result;
}

@end
