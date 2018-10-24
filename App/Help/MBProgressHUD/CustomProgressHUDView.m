//
//  CustomProgressHUDView.m
//  TaxiApp
//
//  Created by guoqiang on 17/1/12.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import "CustomProgressHUDView.h"

@implementation CustomProgressHUDView


- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kMainScreenOfWidth,kMainScreenOfHeight);
        [self showView];
    }
    return self;
}

#pragma mark 创建父视图 也就是背景视图
- (void)createParentView{
    
    self.parentView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:self.parentView];

    self.parentView.layer.shouldRasterize = YES;
    self.parentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到窗口
    [window addSubview:self];

    self.parentView.layer.opacity = 0.5f;
    self.parentView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
    self.parentView.layer.opacity = 1.0f;
    self.parentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
}

- (void)showView{
    
    if(!_parentView){
        [self createParentView];
        [self commonAnimation];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:10.0f];
    }
}
#pragma mark 自定义动画
- (void)customAnimation{

    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(50, 50, 32, 32);
    imageView.image = [UIImage imageNamed:@"icon_loading.png"];
    imageView.center = self.parentView.center;
    [self.parentView addSubview:imageView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1000;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark 普通动画
- (void)commonAnimation{

    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.backgroundColor=[UIColor clearColor];
    activityView.frame=CGRectMake(0,0, 20, 20);
    activityView.center = self.parentView.center;
    [activityView startAnimating];
    [self.parentView addSubview:activityView];
}

- (void)delayMethod{

    [self closeView];
}

#pragma mark 关闭
- (void)closeView{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    [self.parentView removeFromSuperview];
    [self removeFromSuperview];
}

@end
