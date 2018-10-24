//
//  AppDelegate+NotificationHandle.h
//  TaxiApp
//
//  Created by guoqiang on 17/1/6.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (NotificationHandle)

#pragma mark 订单数据
@property(nonatomic,strong)NSDictionary* orderDicts;

#pragma mark 通知处理
- (void)receiveNotification:(UIApplication*)application andData:(NSDictionary*)userInfo;


@end
