//
//  Utility.h
//  parkplus
//
//  Created by zhidao on 16/8/4.
//  Copyright © 2016年 zhikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
//边框线
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

// 判断手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isPayPwdStr:(NSString *)payPwdStr;
@end
