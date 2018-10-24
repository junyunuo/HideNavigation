//
//  CustomRatingView.m
//  App
//
//  Created by guoqiang on 2018/10/23.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "CustomRatingView.h"
#import "AXRatingView.h"
@implementation CustomRatingView



- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initWithSubView:frame];
    }
    return self;
}

- (void)initWithSubView:(CGRect)frame{
    
    self.frame = frame;
    AXRatingView *stepRatingView = [[AXRatingView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [stepRatingView sizeToFit];
    [stepRatingView setStepInterval:1.0];
    [self addSubview:stepRatingView];
}

@end
