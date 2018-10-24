//
//  NSObject+Location.h
//  MahjongServiceApp
//
//  Created by guoqiang on 16/9/24.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapLocation.h"
#import "TQLocationConverter.h"

@interface NSObject (Location)<CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic,strong)UIAlertView* alertView;

-(void)initLocation;


@end
