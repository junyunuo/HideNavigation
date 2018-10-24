//
//  BaseViewController+PopLoginView.m
//  MahjongServiceApp
//
//  Created by guoqiang on 16/9/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "BaseViewController+PopLoginView.h"
#import "BaseNavigationController.h"
@implementation BaseViewController (PopLoginView)

#pragma mark 弹出登录界面
- (void)showLoginViewController{
    
    APPDelegate.token = @"";
    APPDelegate.uid = @"";
    [UserDataBase deleteUserInfo];
    [UserBaseModel cleanLocalUserData];
    
    [LoginViewController checkLogin:self complete:^(BOOL isLogin){
        
    }];
}


@end

