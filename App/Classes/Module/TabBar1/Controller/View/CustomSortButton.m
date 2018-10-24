//
//  CustomSortButton.m
//  DeQingYouXuanApp
//
//  Created by guoqiang on 17/2/24.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import "CustomSortButton.h"

@implementation CustomSortButton


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.imageView.gq_left = self.titleLabel.gq_right + 5;

}


@end
