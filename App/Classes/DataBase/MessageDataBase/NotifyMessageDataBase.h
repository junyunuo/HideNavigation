//
//  NotifyMessageDataBase.h
//  DoctorApp
//
//  Created by 郭强 on 16/8/12.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyMessageDataBase : NSObject
/**
 *  创建表
 */
+ (void)createTable;
/**
 *  插入数据
 *
 *  @param dict
 */
+ (void)insertDataWithDict:(NSMutableArray *)array;

/**
 *  设置已读
 */
+(BOOL)updateMessageReadedWithMessageId:(NSString*)messageId;

/**
 *  查询消息
 *
 *  @return
 */
+ (NSMutableArray*)selectAllMessage;


/**
 *  获取 未读消息
 */
+ (NSMutableArray*)getMessageNoReaded;


/**
 *  删除消息
 */
+ (BOOL)deleteNotifyMessage;

/**
 *  删除消息
 */
+ (BOOL)deleteMessageById:(NSString*)messageId;

/**
 *  查询未读消息
 */
+ (NSMutableArray*)selectMessageForNoReaded;

@end
