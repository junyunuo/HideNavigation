//
//  NSObject+ProgressHUDView.h
//  TaxiApp
//
//  Created by guoqiang on 17/1/13.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomProgressHUDView.h"

@interface NSObject (ProgressHUDView)

@property(nonatomic,strong)CustomProgressHUDView* customProgressHUDView;

//显示
- (void)showCustomProgressView;
//隐藏
- (void)hideCustomProgressView;

@end
