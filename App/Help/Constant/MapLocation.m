//
//  MapLocation.m
//  YY_yijia
//
//  Created by yiyou on 15/4/10.
//  Copyright (c) 2015年 com.yiyou. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation


#pragma mark 标点上的主标题
- (NSString *)title{
    //return @"房源位置";
    return _streetAddress;
}

#pragma  mark 标点上的副标题
- (NSString *)subtitle{
    
    return @" ";
}

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                subTitle:(NSString *)paramSubitle
{
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        
//        _title = paramTitle;
//        _subtitle = paramSubitle;
    }
    return self;
}

@end
