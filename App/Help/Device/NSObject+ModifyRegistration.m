//
//  NSObject+ModifyRegistration.m
//  MahjongServiceApp
//
//  Created by guoqiang on 16/9/26.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "NSObject+ModifyRegistration.h"

@implementation NSObject (ModifyRegistration)


#pragma mark 上报 极光注册设备id
- (void)modifyRegistration{

    if([NSString isBlankString:APPDelegate.uid]){
        return;
    }
    NSString* registrationId = APPDelegate.registrationID;
    if([NSString isBlankString:APPDelegate.registrationID]){
        registrationId = [[NSUserDefaults standardUserDefaults] stringForKey:@"registrationId"];
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:registrationId forKey:@"registration_id"];

    if([NSString isBlankString:registrationId]){
        
        [dict setValue:@"" forKey:@"registration_id"];
    }
//    [[AFNService shareInstance] postValueWithMethod:ModifyRegistrations andBody:dict successBlock:^(SuccessModel *successModel){
//        
//        if([successModel.code integerValue]== 1){
//            NSLog(@"上报设备号成功.............");
//        }else{
//            NSLog(@"上报设备号失败.............");
//        }
//    } failBlock:^(NSString *errorMessage){
//
//    }];
}


#pragma makr 保存 设备id
- (void)saveRegistrationId:(NSString*)registration_id{

    [[NSUserDefaults standardUserDefaults] setValue:registration_id forKey:@"registrationId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


@end
