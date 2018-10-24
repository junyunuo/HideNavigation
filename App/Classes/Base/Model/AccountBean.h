//
//  MyCenterViewController.h
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AccountBean : NSObject <NSCoding>


@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *portrait;
@property (nonatomic,strong) NSString *refresh_token;
@property (nonatomic,  copy) NSString *sex;
@property (nonatomic,  copy) NSString *token;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* mobile;
@property (nonatomic,strong) NSString* rongytoken;
@property (nonatomic,strong) NSString* nickName;

@end
