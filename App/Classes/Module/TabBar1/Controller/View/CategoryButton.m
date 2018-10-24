//
//  CategoryButton.m
//  App
//
//  Created by guoqiang on 2018/10/22.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "CategoryButton.h"

@implementation CategoryButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.imageView.frame = CGRectMake(30, 10, self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    self.imageView.gq_top = 10;
    self.imageView.gq_centerX = self.gq_centerX;
    
    
    self.titleLabel.gq_top = self.imageView.gq_bottom + 10;
    self.titleLabel.gq_centerX = self.gq_centerX;
    
    //self.titleLabel.frame = CGRectMake(10, 55, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    [self.titleLabel sizeToFit];
    
}


@end
