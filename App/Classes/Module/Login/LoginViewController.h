//
//  LoginViewController.h
//  jianzhiApp
//
//  Created by 花落永恒 on 16/10/10.
//  Copyright © 2016年 花落永恒. All rights reserved.
//

#import "BaseViewController.h"
#import "ZLYTextField.h"

typedef void (^LoginReturnBlock)(BOOL);

@interface LoginViewController : BaseViewController

@property(nonatomic,strong)LoginReturnBlock loginReturn;
@property (nonatomic,assign) BOOL isLoginReturn;

@property (weak, nonatomic) IBOutlet ZLYTextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;


//验证是否已经登录
+ (void)checkLogin:(UIViewController *)viewController complete:(LoginReturnBlock)complete;

#pragma mark 退出登录
+ (void)logout:(UIViewController*)viewController complete:(LoginReturnBlock)complete;

@end
