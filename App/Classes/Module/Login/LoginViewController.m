//
//  LoginViewController.m


#import "LoginViewController.h"
#import "UserBaseModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "BaseNavigationController.h"
#import "MainViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) NSString *from_type;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

@end

@implementation LoginViewController

#pragma mark 记录登录次数 以防二次出现
static NSInteger loginCount = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号登录";
    loginCount = 1;
    
    self.backButton.hidden = true;    
    self.mobileTextField.MaxWordNumber = 11;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    loginCount = 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    APPDelegate.isLaunchPage = false;
    APPDelegate.isUpdateApp = @"0";
}


- (IBAction)codeLoginAction:(id)sender {
    
//    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
//   // [self pushViewController:registerVC animated:true];
//    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark 登录Action
- (IBAction)loginAction:(id)sender {
    
    if (self.mobileTextField.text.length != 11) {
        [self.view makeToast:@"请输入正确的手机号"];
    }else if(self.passWordTextField.text.length < 1){
        [self.view makeToast:@"密码不能为空"];
    }else{
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.mobileTextField.text forKey:@"mobile"];
        [dict setValue:MD5String(self.passWordTextField.text)  forKey:@"pwd"];
        [dict setValue:@"1" forKey:@"user_type"];

        [self loginRequest:dict];
    }
}

- (void)loginRequest:(NSDictionary *)dict{
    
    __weak typeof(self) weakSelf = self;
    [self showCustomProgressView];
    
    [self.mobileTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    
    [[AFNService shareInstance] postValueWithMethod:@"" andBody:dict successBlock:^(SuccessModel *successModel) {
        [weakSelf hideCustomProgressView];
        if([successModel.code integerValue]==1){
            NSDictionary* resultDict = successModel.result;
            [weakSelf loginDataSave:resultDict];
        }else{
            [weakSelf.view makeToast:successModel.message];
        }
    } failBlock:^(NSString *errorMessage) {
        [weakSelf.view makeToast:errorMessage];
    }];
}

#pragma mark 保存用户信息
- (void)loginDataSave:(NSDictionary *)dict{
    
    NSDictionary* resultDict = dict;
    [UserBaseModel cleanLocalUserData];
    [UserBaseModel saveUserInfoModel:resultDict];
    [UserDataBase deleteUserInfo];
    [UserDataBase insertDataWithDict:resultDict.mutableCopy];
    
    if(![self executeLoginReturn:YES])
    {
        [self nextViewController];
    }
    
   //getTotalUnreadCount
}

- (void)nextViewController{
    
    MainViewController* mainView = [[MainViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainView;
}

-(BOOL)executeLoginReturn:(BOOL)loginSuccess
{
    if(_isLoginReturn)
    {
        if (_loginReturn)
        {
            _loginReturn(loginSuccess);
            _loginReturn=nil;
        }
        
        [self dismissViewControllerAnimated:true completion:nil];
        return true;
    }
    else
    {
        return false;
    }
}

#pragma 验证是否登录
+ (void)checkLogin:(UIViewController *)viewController complete:(LoginReturnBlock)complete{
    if(loginCount>=1){
        return;
    }
    loginCount ++;
    NSDictionary* lastLoginInfo = [SingletonShared getLastUserLoginInfo];
//    if(lastLoginInfo){
//        //上一次登录数据
//        LastLoginViewController* vc = [[LastLoginViewController alloc] init];
////        [viewController presentViewController:vc animated:true completion:nil];
//        BaseNavigationController* nav=[[BaseNavigationController alloc] initWithRootViewController:vc];
//        nav.navigationBarHidden = true;
//        [viewController presentViewController:nav animated:YES completion:nil];
//    }else{
//        LoginViewController* loginVC = [[LoginViewController alloc] init];
//        BaseNavigationController* nav=[[BaseNavigationController alloc] initWithRootViewController:loginVC];
//        loginVC.loginReturn = complete;
//        [viewController presentViewController:nav animated:YES completion:nil];
//    }
}

#pragma mark 退出登录
+ (void)logout:(UIViewController*)viewController complete:(LoginReturnBlock)complete{
    

}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    self.lineView2.gq_height = 0.5;
}

-(void)setLoginReturn:(LoginReturnBlock)loginReturn
{
    _loginReturn = loginReturn;
    _isLoginReturn = true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
