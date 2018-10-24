//
//  UIView+UIViewController.m
//  arc_peiwowan
//
//  Created by MacBook on 11/14/14.
//  Copyright (c) 2014 MacBook. All rights reserved.
//

#import "UIView+UIViewController.h"


@implementation UIView (BaseViewController)


-(BaseViewController *)getViewController
{
    UIResponder *next = [self nextResponder];
    
    do{
    
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (BaseViewController *)next;
        }
        next = [next nextResponder];
    
    } while (next != nil);
    
    return nil;
}

@end
