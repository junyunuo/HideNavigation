//
//  ZJHCustomDatePickerView.h
//  DatePicker
//
//  Created by 花落永恒 on 16/12/1.
//  Copyright © 2016年 花落永恒. All rights reserved.
//

/**
 *  时间选择器
 *
 *  今天、明天、后天
 *
 */

#import <UIKit/UIKit.h>

@interface ZJHCustomDatePickerView : UIView

/**
 *  父视图 也是背景视图
 */
@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) void (^confirmBlock)(NSString *,NSString *);

- (void)showDatePickerView;
- (void)closeDatePickerView;

@end
