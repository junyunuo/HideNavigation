//
//  BaseViewController.h
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoNetworkView.h"
#import "MBProgressHUD.h"
@interface BaseViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    int HudNum;
}
@property(nonatomic,strong)UIBarButtonItem* leftItem;


/**
 *  右边按钮
 */
@property (nonatomic,strong)UIBarButtonItem* rightButtonItem;

/**
 *  右边按钮
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
@property (nonatomic,strong)UIButton *rightButton;

/**
 *  错误界面
 */
@property(nonatomic,strong) NoNetworkView *noNetworkView;



/**
 *  导航栏返回按钮
 */
@property (nonatomic, strong) UIButton * backButton;
/**
 *  push到下个控制器
 *
 *  @param viewController
 */
- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated;
/**
 *  返回
 */
- (void)backAction;
/**
 *  销毁
 */
- (void)dismissViewControllerAnimated;
/**
 *  直接返回到上个界面
 *  @return
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/**
 *  返回到指定界面
 *  @param viewController
 *  @param animated
 */
- (void)popToViewControllerAnimated:(UIViewController*)viewController animated:(BOOL)animated;

/**
 *  右边按钮事件
 */
- (void)rightItemAction;

- (void)popRootViewControllerAnimated:(BOOL)animated;

-(void)showHUD:(NSString *)str;
-(void)hiddenHUD;

@end
