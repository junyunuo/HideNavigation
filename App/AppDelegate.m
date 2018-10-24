//
//  AppDelegate.m
//  App
//
//  Created by guoqiang on 2018/5/17.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"

@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic,strong)WXLoginShare * weChatSdk;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    [self getQiNiuToken];
    [self registerConfig];
    
    NSString* sourceApp = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(url)
    {
        NSDictionary* jumpDic = @{@"url":url.absoluteString,@"sourceApp":sourceApp};
        if(jumpDic){
            [SingletonShared addNotifyPushFlag:jumpDic];
        }
    }
    return YES;
}


#pragma make 注册配置
- (void)registerConfig{
    
//     //注册Bugly
//    [Bugly startWithAppId:BuglyAppId];
//
//    //注册微信
//    self.weChatSdk  = [WXLoginShare shareInstance];
//    [WXApi registerApp:WXKey];
//
//    //融云
//    [[RCIM sharedRCIM] initWithAppKey:RongYunKey];
//    //注册融云自定义消息
//    [[RCIM sharedRCIM] setEnableMessageAttachUserInfo:true];
//    [[RCIM sharedRCIM] setEnablePersistentUserInfoCache:true];
//
//
//
//    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
//    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformSubTypeWechatSession)]
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//
//             default:
//                 break;
//         }
//     }
//                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:WXKey
//                                       appSecret:WXSecret];
//                 break;
//             default:
//                 break;
//         }
//     }];
    
}

//#pragma mark 接受消息
//- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
//
//    int messageCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
//    if(messageCount >0){
//        [UIApplication sharedApplication].applicationIconBadgeNumber = messageCount;
//        // [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
//       // [UIApplication sharedApplication].applicationIconBadgeNumber = messageCount;
//    }
////    if([message.objectName isEqualToString:@"RCD:RedPacketMsg"]){
////        RedPacketMessage* redMessage = (RedPacketMessage*)message;
////        redMessage.content = @"您收到了一个红包";
////       // [[RCIMClient sharedRCIMClient] setMes]
////    }
//
//    dispatch_sync(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:MessageRedDot object:self userInfo:nil];
//    });
//}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}


/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
  //  [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:ZHIFUBAOCAllBack object:resultDic];
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
                  [[NSNotificationCenter defaultCenter] postNotificationName:ZHIFUBAOAUTHCALLBACK object:resultDic];
            
        }];
        return YES;
    }
    id idwXLoginShare = self.weChatSdk;
    [WXApi handleOpenURL:url delegate:idwXLoginShare];
    
    NSString* sourceApplication =  options[@"UIApplicationOpenURLOptionsSourceApplicationKey"];    
    NSString* fromUrl = url.absoluteString;
   
    [self openKaLiaoChatListViewController:fromUrl withSourceApp:sourceApplication];
    return true;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    NSLog(@"url=====%@ \n  sourceApplication=======%@ \n  annotation======%@", url, sourceApplication, annotation);
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:ZHIFUBAOCAllBack object:resultDic];
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:ZHIFUBAOAUTHCALLBACK object:resultDic];
            
        }];
        
        return YES;
    }
    id idwXLoginShare = self.weChatSdk;
    [WXApi handleOpenURL:url delegate:idwXLoginShare];
    
    [self openKaLiaoChatListViewController:url.absoluteString withSourceApp:sourceApplication];
    
    
    return YES;
}


#pragma mark 打开咔聊聊天界面 进行分享
- (void)openKaLiaoChatListViewController:(NSString*)fromUrl withSourceApp:(NSString*)sourceApplication{
    
  
    
   
}


- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    
   // return rootViewController;
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


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    id idwXLoginShare = self.weChatSdk;
    [WXApi handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:idwXLoginShare];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    int messageCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
//    if(messageCount >0){
//        // [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
//        [UIApplication sharedApplication].applicationIconBadgeNumber = messageCount;
//    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if(!APPDelegate.isLaunchPage){
        //只有在LaunchViewController 界面才会判断升级判断
        return;
    }
  //  [self checkVersionAction];
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
