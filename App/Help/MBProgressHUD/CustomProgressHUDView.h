//
//  CustomProgressHUDView.h
//  TaxiApp
//
//  Created by guoqiang on 17/1/12.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomProgressHUDView : UIView

/**
 *  父视图 也是背景视图
 */
@property(nonatomic,strong)UIView* parentView;
/**
 *  需要显示的子视图
 */
@property(nonatomic,strong)UIView* subView;
/**
 *  顶部按钮
 */
@property(nonatomic,strong)UIView* bottomView;

@property(nonatomic,strong)UIView *containerView;
/**
 *  显示
 */
- (void)showView;
/**
 *  关闭
 */
- (void)closeView;

@end
