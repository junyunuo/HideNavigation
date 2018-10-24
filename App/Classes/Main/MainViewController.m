//
//  MainViewController.m
//  MahjongServiceApp
//
//  Created by 郭强 on 16/8/24.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "MapLocation.h"
#import "TQLocationConverter.h"
#import "UITabBar+Badge.h"
#import "NotifyMessageDataBase.h"
#import "LLTabBar.h"
#import "TabBar1ViewController.h"
#import "TabBar2ViewController.h"
#import "TabBar3ViewController.h"
#import "DCTabBadgeView.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;

@property(nonatomic,strong)UITabBarItem* currentTabBarItem;
@property(nonatomic,strong)UITabBar* currentTabBar;
@property(nonatomic,strong)LLTabBar *lltabBar;


@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;



@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [self addChildViewController];
}
    
#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    return _tabBarItems;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    APPDelegate.isLaunchPage = false;
    APPDelegate.isUpdateApp = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewController{

    NSArray *childArray = @[
                            @{MallClassKey  : @"TabBar1ViewController",
                              MallTitleKey  : @"",
                              MallImgKey    : @"tabr_01_up",
                              MallSelImgKey : @"tabr_01_down"},
                            
                            @{MallClassKey  : @"TabBar2ViewController",
                              MallTitleKey  : @"",
                              MallImgKey    : @"tabr_02_up",
                              MallSelImgKey : @"tabr_02_down"},
                            
                            @{MallClassKey  : @"TabBar3ViewController",
                              MallTitleKey  : @"",
                              MallImgKey    : @"tabr_03_up",
                              MallSelImgKey : @"tabr_03_down"},
                            
                            @{MallClassKey  : @"TabBar4ViewController",
                              MallTitleKey  : @"",
                              MallImgKey    : @"tabr_03_up",
                              MallSelImgKey : @"tabr_03_down"},
                            ];
    
    
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.image = [UIImage imageNamed:dict[MallImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);//（当只有图片的时候）需要自动调整
        [self addChildViewController:nav];
        // 添加tabBarItem至数组
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
}

#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if(viewController == [tabBarController.viewControllers objectAtIndex:DCTabBarControllerPerson]){
//
//        if (![[DCObjManager dc_readUserDataForKey:@"isLogin"] isEqualToString:@"1"]) {
//
//            DCLoginViewController *dcLoginVc = [DCLoginViewController new];
//            [self presentViewController:dcLoginVc animated:YES completion:nil];
//            return NO;
//        }
//    }
    self.delayIndex = self.selectedIndex;
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
    if ([self.childViewControllers.firstObject isEqual:viewController]) { //根据tabBar的内存地址找到美信发通知jump
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jump" object:nil];
    }
    
}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}
    
#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
    {
        for (UIView *imageView in tabBarButton.subviews) {
            if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                //需要实现的帧动画,这里根据自己需求改动
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                animation.keyPath = @"transform.scale";
                animation.values = @[@1.0,@1.1,@0.9,@1.0];
                animation.duration = 0.3;
                animation.calculationMode = kCAAnimationCubic;
                //添加动画
                [imageView.layer addAnimation:animation forKey:nil];
            }
        }
        
    }
    
    
#pragma mark - 更新badgeView
- (void)updateBadgeValue
{
//        _beautyMsgVc.tabBarItem.badgeValue = [DCObjManager dc_readUserDataForKey:@"isLogin"];
}
    
    
#pragma mark - 添加所有badgeView
- (void)addBadgeViewOnTabBarButtons {
    
//    // 设置初始的badegValue
//    _beautyMsgVc.tabBarItem.badgeValue = [DCObjManager dc_readUserDataForKey:@"isLogin"];
//
//    int i = 0;
//    for (UITabBarItem *item in self.tabBarItems) {
//
//        if (i == 0) {  // 只在美信上添加
//            [self addBadgeViewWithBadgeValue:item.badgeValue atIndex:i];
//            // 监听item的变化情况
//            [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
//            _item = item;
//        }
//        i++;
//    }
}
    
- (void)addBadgeViewWithBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index {
    
    DCTabBadgeView *badgeView = [DCTabBadgeView buttonWithType:UIButtonTypeCustom];
    
    CGFloat tabBarButtonWidth = self.tabBar.gq_width / self.tabBarItems.count;
    
    badgeView.gq_centerX = index * tabBarButtonWidth + 40;
    
    badgeView.tag = index + 1;
    
    badgeView.badgeValue = badgeValue;
    
    [self.tabBar addSubview:badgeView];
}
    
#pragma mark - 只要监听的item的属性一有新值，就会调用该方法重新给属性赋值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    for (UIView *subView in self.tabBar.subviews) {
        if ([subView isKindOfClass:[DCTabBadgeView class]]) {
            if (subView.tag == 1) {
                DCTabBadgeView *badgeView = (DCTabBadgeView *)subView;
               // badgeView.badgeValue = _beautyMsgVc.tabBarItem.badgeValue;
            }
        }
    }
    
}
    
    
#pragma mark - 移除通知
- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"badgeValue"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
    
#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
    
- (BOOL)shouldAutorotate {
    return NO;
}
    
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)tabBarDidSelectedRiseButton{
    
    
}

- (void)tabBarDidSelectedRiseButton:(NSInteger)tag{
    
    
}

@end
