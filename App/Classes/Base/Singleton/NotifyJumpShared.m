//
//  NotifyJumpShared.m
//  DoctorApp
//
//  Created by 郭强 on 16/8/12.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "NotifyJumpShared.h"

@implementation NotifyJumpShared

+(NotifyJumpShared*)sharedInstance{
    static NotifyJumpShared *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[NotifyJumpShared alloc] init];
    });
    return sharedInstance;
}
@end
