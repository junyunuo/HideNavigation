//
//  UITabBar+Badge.h
//  DoctorApp
//
//  Created by 郭强 on 16/8/13.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index;

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index;

@end
