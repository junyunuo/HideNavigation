//
//  NSObject+ProgressHUDView.m
//  TaxiApp
//
//  Created by guoqiang on 17/1/13.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import "NSObject+ProgressHUDView.h"

@implementation NSObject (ProgressHUDView)

const int v;

- (void)setCustomProgressHUDView:(CustomProgressHUDView *)customProgressHUDView{
    
    objc_setAssociatedObject(self, &v, customProgressHUDView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CustomProgressHUDView*)customProgressHUDView{

    return objc_getAssociatedObject(self,&v);
}



#pragma mark 自定义加载动画
- (void)showCustomProgressView{
    
    self.customProgressHUDView = [[CustomProgressHUDView alloc] init];
}
#pragma mark 隐藏
- (void)hideCustomProgressView{
    [self.customProgressHUDView closeView];
}




@end
