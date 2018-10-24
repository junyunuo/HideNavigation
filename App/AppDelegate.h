//
//  AppDelegate.h
//  App
//
//  Created by guoqiang on 2018/5/17.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//用户token
@property(nonatomic,strong)NSString* token;
//用户id
@property(nonatomic,strong)NSString* uid;
//用户昵称
@property(nonatomic,strong)NSString* nickname;
//用户头像
@property(nonatomic,strong)NSString* portrait;


@property(nonatomic,strong)NSString* rongyunToken;


//极光推送别名
@property(nonatomic,strong)NSString* jpushAlias;
//注册极光 id
@property(nonatomic,strong)NSString* registrationID;
//纬度
@property(nonatomic,strong)NSString* latitude;
//经度
@property(nonatomic,strong)NSString* longitude;
//当前城市
@property(nonatomic,strong)NSString* cityName;
//当前城市ID
@property(nonatomic,strong)NSString* city_id;
//七牛云
@property(nonatomic,strong)NSString* qiniuToken;
//图片url
@property(nonatomic,strong)NSString* fileUrl;
//是否设置了登录密码
@property(nonatomic,strong)NSString* login_psw_status;

//phone
@property(nonatomic,strong)NSString* phone;

//是否在 LaunchViewController 界面
@property(nonatomic,assign)BOOL isLaunchPage;
//app 是否需要更新  //1普通更新，2强制更新  0 不需要
@property(nonatomic,strong)NSString *isUpdateApp;
@property(nonatomic,strong)NSString *down_url;
@property(nonatomic,strong)NSString *updateMessage;
@property(nonatomic,strong)NSString* currentAppBuild;



@end

