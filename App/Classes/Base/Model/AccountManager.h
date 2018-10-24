//
//  MyCenterViewController.h
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountBean.h"
@protocol AccountDelegate <NSObject>
@end

@interface AccountManager : NSObject

@property(nonatomic,strong)AccountBean* bean;
@property(weak,nonatomic)id<AccountDelegate> delegate;
+ (AccountManager *)shareAccountManager;


@end
