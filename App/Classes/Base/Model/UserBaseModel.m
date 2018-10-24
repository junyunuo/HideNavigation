//
//  UserBaseModel.m
//

#import "UserBaseModel.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "SecurityUtil.h"

#define KEY @"ABCDEFGHIJKLMNOP" //AES加密的key  可修改
@implementation UserBaseModel


+(UserBaseModel*)sharedInstance{
    static UserBaseModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserBaseModel alloc] init];
    });
    return sharedInstance;
}

#pragma 保存用户的信息和归档
+(void)saveUserInfoModel:(NSDictionary *)dict
{
    
  AccountBean *bean = [[AccountBean alloc] init];
    
    bean.uid = EncodeStringFromDic(dict,@"id");

    bean.mobile = EncodeStringFromDic(dict,@"username");
    
    if([NSString isBlankString:bean.mobile]){
        bean.mobile = @"";
    }
    bean.token = EncodeStringFromDic(dict,@"token");
    bean.refresh_token = EncodeStringFromDic(dict,@"refresh_token");
    bean.portrait = EncodeStringFromDic(dict,@"portrait");
    bean.rongytoken = EncodeStringFromDic(dict,@"rongytoken");
    bean.nickName = EncodeStringFromDic(dict,@"nickname");
    if([NSString isBlankString:bean.nickName]){
        bean.nickName = @"";
    }
    
    bean.sex = EncodeStringFromDic(dict,@"sex");
    [AccountManager shareAccountManager].bean = bean;
    APPDelegate.uid = EncodeStringFromDic(dict,@"id");
    APPDelegate.token = EncodeStringFromDic(dict,@"token");
    APPDelegate.rongyunToken = EncodeStringFromDic(dict,@"rongytoken");
    
    APPDelegate.nickname = EncodeStringFromDic(dict,@"nickname");
    APPDelegate.portrait = EncodeStringFromDic(dict,@"portrait");
    APPDelegate.phone = EncodeStringFromDic(dict,@"username");
    if([NSString isBlankString:APPDelegate.rongyunToken]){
//        [RongYunShared refreshTokenMethod];
    }else{
//        [RongYunShared loginRongYun];
    }
    
    [self modifyRegistration];
    [self JpushSetAlias];
   // [self registerRongyun];
}

//#pragma mark 注册融云
//+ (void)registerRongyun{
//    NSLog(@"%@",APPDelegate.rongyunToken);
//
//    if(![NSString isBlankString:APPDelegate.rongyunToken]){
//        [[RCIM sharedRCIM] connectWithToken:APPDelegate.rongyunToken success:^(NSString *userId) {
//            NSLog(@"连接服务器成功------%@",userId);
//        } error:^(RCConnectErrorCode status) {
//            NSLog(@"融云连接错误：%ld",status);
//        } tokenIncorrect:^{
//            //870090
//        }];
//    }else{
//        NSLog(@"融云token 为空");
//    }
//}

#pragma mark 极光设置别名
+ (void)JpushSetAlias{
    
//    if(![NSString isBlankString:APPDelegate.uid]){
//        NSString* alias = MD5String(APPDelegate.uid);
//        [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
//
//            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
//            NSLog(@"userId-------%@",APPDelegate.uid);
//        }];
//    }
}



#pragma mark 保存 数据
+ (void)saveUserStatus:(NSDictionary*)dict{
    
    AccountBean * accountBean = [[AccountBean alloc] init];
    accountBean.token =  EncodeStringFromDic(dict,@"token");
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"userStatus.data"];
    [NSKeyedArchiver archiveRootObject:accountBean toFile:path];
    
}

#pragma 获取用户状态
+ (NSString*)getUserStatus{

    @try {
        
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
        NSString *path=[docPath stringByAppendingPathComponent:@"userStatus.data"];
      
        
        NSString* is_status =  [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        return is_status;

    } @catch (NSException *exception) {

    }
    return nil;
    
}


#pragma mark 加密
+(NSString*)Encryption:(NSString*)value
{
    NSString *encryptionValue= [SecurityUtil encryptAESData:value app_key:KEY];
    return encryptionValue;
}

#pragma mark 解密
+(NSString*)Decrypt:(NSString*)value
{
    
    NSData *EncryptData = [GTMBase64 decodeString:value]; //解密前进行GTMBase64编码
    NSString * string = [SecurityUtil decryptAESData:EncryptData app_key:KEY];
    return string;
}
#pragma mark 退出登录时 清除 用户Model数据
+(void)cleanLocalUserData{
    APPDelegate.token = @"";
    APPDelegate.uid = @"";
    [AccountManager shareAccountManager].bean = nil;
    [UserDataBase deleteUserInfo];

}


@end
