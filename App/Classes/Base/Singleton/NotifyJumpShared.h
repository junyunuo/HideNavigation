//
//  NotifyJumpShared.h
//  DoctorApp
//
//  Created by 郭强 on 16/8/12.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyJumpShared : NSObject

+(NotifyJumpShared*)sharedInstance;

//是否在 消息界面
@property(nonatomic,assign)BOOL isMessageVc;

//跳转类型
@property(nonatomic,assign)NSInteger jumpType;


//是否要显示好友消息 红点
@property(nonatomic,assign)BOOL isShowFriendsRed;

@end
