//
//  AppDelegate+NotificationHandle.m
//  TaxiApp
//
//  Created by guoqiang on 17/1/6.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import "AppDelegate+NotificationHandle.h"

@implementation AppDelegate (NotificationHandle)

//const int dis;
//- (void)setOrderDicts:(NSDictionary *)orderDicts{
//    objc_setAssociatedObject(self,&dis, orderDicts, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSDictionary*)orderDicts{
//    return objc_getAssociatedObject(self, &dis);
//}

#pragma mark 接受通知的处理方法
- (void)receiveNotification:(UIApplication*)application andData:(NSDictionary*)userInfo{
    
//    NSString* msgtype = EncodeStringFromDic(userInfo,@"msgtype");
//    if([msgtype integerValue] == 100){
//        if([[userInfo allKeys] containsObject:@"userInfo"]){
//            [self jumpMapViewController:userInfo];
//        }
//    }else if([msgtype integerValue] == 108){
//        //订单已被乘客取消
//        [[NSNotificationCenter defaultCenter] postNotificationName:CancelOrderNotificationCenter object:nil];
//    }else if([msgtype integerValue] == 300){
//        //乘客发起预约订单 司机端需要显示预约数量
//        NSString* bespeakNum = EncodeStringFromDic(userInfo,@"bespeakNum");
//        if([bespeakNum integerValue] >0){
//            [[NSNotificationCenter defaultCenter] postNotificationName:MakeNumberNotificationCenter object:bespeakNum];
//        }
//    }else if([msgtype integerValue] == 301){
//        //乘客响应预约订单 司机端弹出匹配成功视图
//        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeDataNotificationCenter object:nil];
//    }else if([msgtype integerValue] == 400){
//        //动态通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:FriendsRedPoint object:@"1" userInfo:nil];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NewDynamicMessageNotificationCenter object:userInfo userInfo:nil];
//    }
}




- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
