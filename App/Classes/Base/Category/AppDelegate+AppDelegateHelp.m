//
//  AppDelegate+AppDelegateHelp.m
//  TaxiApp
//
//  Created by guoqiang on 16/12/8.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import "AppDelegate+AppDelegateHelp.h"

@implementation AppDelegate (AppDelegateHelp)


#pragma mark 获取七牛token
- (void)getQiNiuToken {
   // __weak typeof(self) weakSelf = self;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [[AFNService shareInstance] postValueWithMethod:getQiNiuTokenApi andBody:paramDic successBlock:^(SuccessModel *successModel) {
        if([successModel.code integerValue] == 1) {
            NSDictionary *resultDict = successModel.result;
            APPDelegate.qiniuToken =  EncodeStringFromDic(resultDict, @"token");
            APPDelegate.fileUrl =   EncodeStringFromDic(resultDict, @"url");
        }
    } failBlock:^(NSString *errorMessage) {
      //  [weakSelf.view makeToast:errorMessage];
    }];
}

@end
