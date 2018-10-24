//
//  OtherConfig.h
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#ifndef OtherConfig_h
#define OtherConfig_h


//----------------当前系统版本----------------------
#define MaxSystemVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define kMainScreenOfWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenOfHeight [UIScreen mainScreen].bounds.size.height

#define IPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)
//
#define IPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6+放大版
#define iPhone6PlusZoom ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

//#define APPDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define APPDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IsObjectValid(obj) (obj&&((NSNull *)obj!=[NSNull null]))

#define ZFontOf15 [UIFont systemFontOfSize:15]

#define ZFontOf11 [UIFont systemFontOfSize:11]


#define IsObjectValid(obj) (obj&&((NSNull *)obj!=[NSNull null]))
#define IsNSStringNotEmpty(obj) (obj&&((NSNull *)obj!=[NSNull null]) && [obj isKindOfClass:[NSString class]] && [obj length] > 0)
#define IsNSArrayNotEmpty(obj) (obj&&((NSNull *)obj!=[NSNull null]) && [obj isKindOfClass:[NSArray class]] && [obj count] > 0)
#define IsObjectTypeValid(obj,type) (obj&&((NSNull *)obj!=[NSNull null])&&[obj isKindOfClass:type])
#define IsValidNSDictionary(obj) (obj&&((NSNull *)obj!=[NSNull null]) && [obj isKindOfClass:[NSDictionary class]])

//主色调
#define ZMainColor [UIColor colorForMainColor]
//背景颜色
#define ZBackgroundColor [UIColor colorForBackgroundColor]

//字体颜色
#define ZFontColor(color) [UIColor FontColorOfHex:color]
//线条颜色
#define ZJTheLineColor  [UIColor colorWithHexRGB:@"CBCBCB"]
#define ZJTheBGColor    [UIColor colorWithHexRGB:@"F3F3F3"];


#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];


#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"

//判断设备是否为iphoneX
#define DCIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* OtherConfig_h */
