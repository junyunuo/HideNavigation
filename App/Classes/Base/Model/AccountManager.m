//
//  MyCenterViewController.h
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "AccountManager.h"
#import "AppDelegate.h"
#import "AccountBean.h"
@interface AccountManager ()

@end

@implementation AccountManager
@synthesize bean;

+ (AccountManager *)shareAccountManager;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    return _sharedObject;
}
- (id)init {
    self = [super init];
    if (self) {
        AccountBean * a = [[AccountBean alloc] init];
        self.bean = a;
    }
    return self;
}
@end
