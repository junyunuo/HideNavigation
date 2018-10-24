//
//  MBProgressHUDView.h
//  Weida
//
//  Created by MacBook on 5/7/14.
//  Copyright (c) 2014 yn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBProgressHUDView : UIView

+(void)initWithView:(UIView *)view labelText:(NSString *)text;
+(void)hideHUDForView:(UIView *)view;
+(void)initCustomProgressView:(UIView*)view labelText:(NSString *)text;
+ (void)initCustomProgressView;
+(void)hideHUDForView;
@end
