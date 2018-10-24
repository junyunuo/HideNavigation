//
//  NSObject+ModifyRegistration.h
//  MahjongServiceApp
//
//  Created by guoqiang on 16/9/26.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ModifyRegistration)


/**
 *  上报 极光注册 设备
 */
- (void)modifyRegistration;

/**
 *  上传设备id
 */
- (void)saveRegistrationId:(NSString*)registration_id;


@end
