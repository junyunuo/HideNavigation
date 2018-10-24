//
//  UIViewController+Helper.m
//  DressStyle
//
//  Created by MacBook on 3/10/14.
//  Copyright (c) 2014 yn. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)

-(CGFloat)getInitY
{
    CGFloat top = 0;
    
    UINavigationBar* navigationBar = self.navigationController.navigationBar;
    CGRect navigationFrame = navigationBar.frame;
    
    if(![[UIApplication sharedApplication] isStatusBarHidden])
    {
        top = top + 20;
    }
    
    if(!self.navigationController.navigationBarHidden)
    {
        top = navigationFrame.origin.y + navigationFrame.size.height;
    }
    
    return top;

}
@end
