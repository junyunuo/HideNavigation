
//
//  LaunchViewController.m
//  MahjongServiceApp
//
//  Created by 郭强 on 16/8/24.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "LaunchViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "UserBaseModel.h"
#import "MapLocation.h"
#import "TQLocationConverter.h"
#import "NotifyMessageDataBase.h"
#import "GuidancePageViewController.h"
@interface LaunchViewController ()<CLLocationManagerDelegate>
@property (nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)NSString* currentAppVersion;
@property(nonatomic,strong)NSString* currentAppBuild;


@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UserDataBase createTable];
    [NotifyMessageDataBase createTable];
    
    APPDelegate.isLaunchPage = true;

    //当前app的版本号
    self.currentAppVersion= [NSString stringWithFormat:@"%@",MaxSystemVersion];
    //当前app的Build
    self.currentAppBuild =  [NSString stringWithFormat:@"%@",MaxSystemBuild];
    
    APPDelegate.currentAppBuild = self.currentAppBuild;
    
    APPDelegate.isUpdateApp = @"0";
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkGuidePage) userInfo:nil repeats:false];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    APPDelegate.isLaunchPage = false;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self checkGuidePage];
}

//#pragma mark 检测版本升级
//- (void)checkVersionAction{
//
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    [dict setValue:@"qita" forKey:@"from_type"];
//    [dict setValue:self.currentAppBuild forKey:@"version_code"];
//    [dict setValue:@"1" forKey:@"type"];
//    [[AFNService shareInstance] postValueWithMethod:checkVersion andBody:dict successBlock:^(SuccessModel *successModel){
//
//        if([successModel.code integerValue]== 1){
//
//
//            NSString* down_url = EncodeStringFromDic(successModel.result,@"down_url");
//            NSString* title = EncodeStringFromDic(successModel.result,@"title");
//            NSString* desc = EncodeStringFromDic(successModel.result,@"desc");
//            NSString* version_code = EncodeStringFromDic(successModel.result,@"version_code");
//            //1普通更新，2强制更新
//            NSString* update_type = EncodeStringFromDic(successModel.result,@"update_type");
//
//            APPDelegate.down_url  = down_url;
//            APPDelegate.updateMessage = desc;
//            APPDelegate.isUpdateApp = update_type;
//
//
////            down_url = @"https://www.baidu.com/";
//
//            //需要升级
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新" message:desc preferredStyle:UIAlertControllerStyleAlert];
//
//            if([update_type integerValue] == 1){
//                APPDelegate.isUpdateApp = @"1";
//
//                UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"升级最新版本" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:down_url]];
//                }];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    [self checkGuidePage];
//                }];
//                [alertController addAction:cancelAction];
//                [alertController addAction:resetAction];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self presentViewController:alertController animated:YES completion:nil];
//                });
//            }else{
//                APPDelegate.isUpdateApp = @"2";
//
//                UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"升级最新版本" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:down_url]];
//
//                }];
//                [alertController addAction:resetAction];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self presentViewController:alertController animated:YES completion:nil];
//                });
//            }
//
//        }else{
//            APPDelegate.isUpdateApp = @"0";
//           // [self.view makeToast:successModel.message];
//            [self checkGuidePage];
//        }
//    } failBlock:^(NSString *errorMessage){
//        //[self.view makeToast:errorMessage];
//        [self checkGuidePage];
//    }];
//}

#pragma mark 判断是否显示引导页
- (void)checkGuidePage{
    
    NSString* firstLaunch = [[NSUserDefaults standardUserDefaults] stringForKey:@"firstLaunch"];
    if([firstLaunch isEqualToString:self.currentAppVersion]){
       // [self initViewController];

        [self restoreRootViewController:[[MainViewController alloc] init]];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:self.currentAppVersion forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        GuidancePageViewController* guidancePage = [[GuidancePageViewController alloc] init];
        [guidancePage setUpFeatureAttribute:^(NSArray *__autoreleasing *imageArray, UIColor *__autoreleasing *selColor, BOOL *showSkip, BOOL *showPageCount) {
            *imageArray = @[@"L_1",@"L_2",@"L_3",@"L_4"];
            *showPageCount = YES;
            *showSkip = YES;
        }];
        
//        // 设置窗口的根控制器
//        DCNewFeatureViewController *dcFVc = [[DCNewFeatureViewController alloc] init];
//        [dcFVc setUpFeatureAttribute:^(NSArray *__autoreleasing *imageArray, UIColor *__autoreleasing *selColor, BOOL *showSkip, BOOL *showPageCount) {
//            
//            *imageArray = @[@"guide1",@"guide2",@"guide3",@"guide4"];
//            *showPageCount = YES;
//            *showSkip = YES;
//        }];
        
     //   [SingletonShared sharedInstance].isShowPanelImage = true;
//        GuidancePageViewController* guidancePage = [[GuidancePageViewController alloc] init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = guidancePage;
    }
}
    

#pragma mark 切换根控制器
- (void)restoreRootViewController:(UIViewController *)rootViewController {
    
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.7f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
        
    } completion:nil];
}
    
- (void)initViewController{
    
    NSDictionary* dict = [UserDataBase selectUserInfo];
    [UserBaseModel saveUserInfoModel:dict];
    //APPDelegate.token = @"";
    if([NSString isBlankString:APPDelegate.token]){
        [LoginViewController checkLogin:self complete:^(BOOL isLogin){
            if(isLogin){
                MainViewController* mainView = [[MainViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainView;
            }
        }];
        return;
    }
   MainViewController* mainView = [[MainViewController alloc] init];
   [UIApplication sharedApplication].keyWindow.rootViewController = mainView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
