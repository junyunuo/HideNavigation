//
//  MapLocation.h
//  YY_yijia
//
//  Created by yiyou on 15/4/10.
//  Copyright (c) 2015年 com.yiyou. All rights reserved.
//

//
//  mapLocation.h
//  MyLocation2
//
//  Created by choni on 14-5-13.
//  Copyright (c) 2014年 choni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject<MKAnnotation>
// 地图标点类必须实现 MKAnnotation 协议
// 地理坐标
@property (nonatomic ,readwrite) CLLocationCoordinate2D coordinate ;

//标注的标题
@property (nonatomic,copy,readonly)NSString * title;
//标注的子标题
@property (nonatomic,copy,readonly)NSString * subtitle;

//街道属性信息
@property (nonatomic , copy) NSString * streetAddress;


-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramTitle;

@end
