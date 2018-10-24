//
//  BaseViewController.m
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "BaseViewController+PopLoginView.h"
#import "BaseViewController+NotifyJumpController.h"
#import "Reachability.h"
#import "NSObject+ModifyRegistration.h"

@interface BaseViewController ()
/**
 *  第一次的push 时间
 */
@property(nonatomic,assign)double firstPushTimestamp;
/**
 * 第二次push 的时间
 */
@property(nonatomic,assign)double secondPushTimestampl;


@property (nonatomic, strong) Reachability *reachability;


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HudNum = 0;
    self.firstPushTimestamp = 0;
    self.secondPushTimestampl = 0;
    APPDelegate.isLaunchPage = false;
    [self withBackView];
    //414143
    [self withRightItem];
    [self initErrorView];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor blackColor]   forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self registerNotificationCenter];
    Class class = [self class];
    
    if(class == NSClassFromString(@"TabBar1ViewController")||class == NSClassFromString(@"TabBar2ViewController.h")||class == NSClassFromString(@"")||class == NSClassFromString(@"TabBar3ViewController.h")||class == NSClassFromString(@"TabBar4ViewController.h")){
        self.backButton.hidden = true;
    }else{
        self.backButton.hidden = false;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self jumpViewController];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self removeNotification];
}
#pragma mark 注册通知
- (void)registerNotificationCenter{

    //弹出登录界面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popLoginViewController) name:PopLoginViewController object:nil];
    
    //注册网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    


}
#pragma mark 移除通知
- (void)removeNotification{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:PopLoginViewController object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    
}

#pragma 检测网络状态
-(void)networkStateChange{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    if([wifi currentReachabilityStatus]==NotReachable){
        [self.view makeToast:@"你已关闭网络连接!"];
    }
}

#pragma mark 弹出登录界面
- (void)popLoginViewController{
    
    [self hideCustomProgressView];
    [self showLoginViewController];
}
- (void)withBackView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame =CGRectMake(0, 0, 44, 44);
    [self.backButton setImage:[UIImage imageNamed:@"common_back.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
       self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0,-10, 0,20);
   
//    NSString *version = [UIDevice currentDevice].systemVersion;
//    if (version.doubleValue >= 11.0) {
//        // 针对 11.0 以上的iOS系统进行处理
//        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0,-2, 0,30);
//    }else {
//        // 针对 11.0 以下的iOS系统进行处理
//        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0,10, 0,-20);
//    }

    self.leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:self.leftItem, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}

#pragma mark 创建右边Item
- (void)withRightItem{
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [self.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.rightButtonItem = rightItem;
    
}


#pragma mark --- 初始化错误界面
-(void)initErrorView
{
    if (self.noNetworkView!=nil) {
        [self.noNetworkView removeFromSuperview];
    }
    self.noNetworkView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0,0,kMainScreenOfWidth ,kMainScreenOfHeight)];
    self.noNetworkView.hidden = true;
    [self.view addSubview:self.noNetworkView];
}

#pragma mark 右边按钮
- (void)rightItemAction{

}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    
    NSDate * date = [NSDate date];
    if(self.firstPushTimestamp==0){
        self.firstPushTimestamp = [date timeIntervalSinceReferenceDate];
    }else{
        self.secondPushTimestampl = [date timeIntervalSinceReferenceDate];
    }
    if(self.secondPushTimestampl > 0 ){
        double timestampl = self.secondPushTimestampl - self.firstPushTimestamp;
        if(timestampl < 3){
            return;
        }
    }
    if (self.navigationController.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:viewController animated:animated];
}


- (void)popRootViewControllerAnimated:(BOOL)animated{

    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)popViewControllerAnimated:(BOOL)animated{
    
    [self.navigationController popViewControllerAnimated:animated];
}
- (void)popToViewControllerAnimated:(UIViewController*)viewController animated:(BOOL)animated{
    
    [self.navigationController popToViewController:viewController animated:animated];
    
}


-(void)showHUD:(NSString *)str
{
    HudNum = HudNum + 1;
    if (HudNum>1) {
        return;
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (IsNSStringNotEmpty(str)) {
        HUD.labelText = str;
        HUD.mode = MBProgressHUDModeText;
    }else{
        HUD.mode = MBProgressHUDModeIndeterminate;
    }
    HUD.delegate = self;
}
-(void)hiddenHUD
{
    HudNum = HudNum - 1;
    if (HudNum>0) {
        return;
    }
    [HUD hide:YES];
    
}
#pragma mark - MB
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    self.firstPushTimestamp = 0;
    self.secondPushTimestampl = 0;
}


@end
