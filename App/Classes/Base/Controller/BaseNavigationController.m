//
//  BaseNavigationController.m
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "BaseNavigationController.h"
#import "GQGesVCTransition.h"
#import "UIBarButtonItem+DCBarButtonItem.h"
#import "MainViewController.h"
#import "TabBar1ViewController.h"
@interface BaseNavigationController ()<UINavigationControllerDelegate>
@end

@implementation BaseNavigationController
    
#pragma mark - load初始化一次
+ (void)load{
        [self setUpBase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
  
    [GQGesVCTransition validateGesBackWithType:GQGesVCTransitionTypePanWithPercentRight withRequestFailToLoopScrollView:YES]; //手势返回
}
    
#pragma mark - 初始化
+ (void)setUpBase{
        UINavigationBar *bar = [UINavigationBar appearance];
        bar.barTintColor = [UIColor whiteColor];
        [bar setTintColor:[UIColor darkGrayColor]];
        bar.translucent = YES;
        [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置导航栏字体颜色
        UIColor * naiColor = [UIColor blackColor];
        attributes[NSForegroundColorAttributeName] = naiColor;
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18];
        bar.titleTextAttributes = attributes;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >= 1) {
 
        viewController.hidesBottomBarWhenPushed = YES;
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    //跳转
    [super pushViewController:viewController animated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"tableView willShow viewcontrollers %lu", [self viewControllers].count);
    
    BOOL hiddenAnimate = NO;
    NSInteger count = ((MainViewController *)viewController.tabBarController).delayIndex;
    NSLog(@"tableView willShow delayIndex %ld",(long)count);
    if (count == 0) {
        hiddenAnimate = YES;
    }
    BOOL isShowHomePage = [viewController isKindOfClass:[TabBar1ViewController class]];
    [self setNavigationBarHidden:isShowHomePage animated:hiddenAnimate];

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController.tabBarController.selectedIndex == 2 && [self.viewControllers count] > 1) {
        ((MainViewController *)viewController.tabBarController).delayIndex = viewController.tabBarController.selectedIndex;
    }
   // NSLog(@"tableView didShow viewcontrollers %lu", [self viewControllers].count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
