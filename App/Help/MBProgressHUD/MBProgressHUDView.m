//
//  MBProgressHUDView.m
//  Weida
//
//  Created by MacBook on 5/7/14.
//  Copyright (c) 2014 yn. All rights reserved.
//

#import "MBProgressHUDView.h"
#import "LoadingView.h"
#import "CustomProgressHUDView.h"

@interface MBProgressHUDView()
@property (atomic, assign) BOOL canceled;

@property(nonatomic,strong)CustomProgressHUDView* customProgressHUDView;


@end

@implementation MBProgressHUDView


#pragma mark 自定义加载动画
+ (void)initCustomProgressView{

    CustomProgressHUDView* customView = [[CustomProgressHUDView alloc] init];
    [customView showView];
}

#pragma mark 自定义加载动画
+(void)initCustomProgressView:(UIView*)view labelText:(NSString *)text{

    if([NSString isBlankString:text]){
        text = @"正在加载中....";
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
   
    //hud.customView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 143, 80)];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.labelColor = [UIColor colorWithHexRGB:@"8c8c8c"];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    

}

#pragma mark 自动以logon
+ (void)initPageLoadingViewForView:(UIView *)view {
    
     
    

    
}



+(void)initWithView:(UIView *)view labelText:(NSString *)text
{
   
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    
//    // Set the bar determinate mode to show task progress.
//    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
//    hud.label.text = text;
//    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        float progress = 0.0f;
//        while (progress < 1.0f) {
//            progress += 0.01f;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Instead we could have also passed a reference to the HUD
//                // to the HUD to myProgressTask as a method parameter.
//                [MBProgressHUD HUDForView:view].progress = progress;
//            });
//            usleep(250000);
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES];
//        });
//    });

}

+(void)initRefreshWithView:(UIView *)view labelText:(NSString *)text
{
   
}

+(void)hideHUDForView:(UIView *)view
{
    
    [MBProgressHUD hideHUDForView:view animated:YES];
   
}

+(void)hideHUDForView{

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    NSArray* subArray =  [window subviews];
    for(UIView *v in subArray){
        if([v isKindOfClass:[CustomProgressHUDView class]]){
            [v removeFromSuperview];
        }
    }
    
}


@end
