//
//  UITableViewCell+CommonHelper.m
//  TableDemo
//
//  Created by molon on 15/4/7.
//  Copyright (c) 2015年 guoqiang. All rights reserved.
//


#import "UITableViewCell+CommonHelper.h"

@implementation UITableViewCell (CommonHelper)

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
