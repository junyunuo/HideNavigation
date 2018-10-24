//
//  NSObject+Location.m
//  MahjongServiceApp
//
//  Created by guoqiang on 16/9/24.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "NSObject+Location.h"

@implementation NSObject (Location)

const int lo;
- (void)setLocationManager:(CLLocationManager *)locationManager{
    
    objc_setAssociatedObject(self, &lo,locationManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLLocationManager*)locationManager{
    
    return objc_getAssociatedObject(self,&lo);
}

const int al;
- (void)setAlertView:(UIAlertView *)alertView{

    objc_setAssociatedObject(self, &al,alertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIAlertView*)alertView{
    
    return objc_getAssociatedObject(self,&al);
}


#pragma mark 初始化定位服务
-(void)initLocation{
    
    if (self.locationManager==nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager startUpdatingLocation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManager delegate方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // [manager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D location2d = (CLLocationCoordinate2D){
        .latitude  = location.coordinate.latitude,
        .longitude =location.coordinate.longitude
    };
    
    @try {
        CLGeocoder   *Geocoder=[[CLGeocoder alloc]init];
        CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
            if (error) {
                NSLog(@"获取位置信息失败");
                if([NSString isBlankString:APPDelegate.cityName]){
                    APPDelegate.cityName = @"杭州市";
                    APPDelegate.latitude = @"30.302928209091014";
                    APPDelegate.longitude = @"120.09439954592361";
                }
            }else{
                
                CLPlacemark *placemark=[place firstObject];
                NSDictionary* dict = placemark.addressDictionary;
                APPDelegate.cityName = EncodeStringFromDic(dict,@"City");
                APPDelegate.city_id = getCityIdByName(APPDelegate.cityName);
                
                if([NSString isBlankString:APPDelegate.city_id]){
                    APPDelegate.city_id = @"175";
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:LocationSuccessAction object:nil];
                
                NSLog(@"%@",APPDelegate.cityName);
                NSLog(@"%@",APPDelegate.city_id);

            }
        };
        
        [Geocoder reverseGeocodeLocation:location completionHandler:handler];
        //将WGS-84转为GCJ-02(火星坐标)
        location2d = [TQLocationConverter transformFromBaiduToGCJ:location2d];
        
        //将GCJ-02(火星坐标)转为百度坐标
        location2d = [TQLocationConverter transformFromGCJToBaidu:location2d];
        
        APPDelegate.latitude = [NSString stringWithFormat:@"%f",location2d.latitude];
        
        APPDelegate.longitude = [NSString stringWithFormat:@"%f",location2d.longitude];
        
        NSLog(@"%@",APPDelegate.latitude);
        NSLog(@"%@",APPDelegate.longitude);
        
        //[self.locationManager stopUpdatingLocation];
    }
    @catch (NSException *exception) {
    
    }
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSString *errorString = @"";
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"请在设置-隐私里面打开你的定位服务，然后重新启动app";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            //errorString = @"Location data unavailable";
            //Do something else...
            errorString = @"";
            break;
        default:
           // errorString = @"An unknown error has occurred";
            errorString = @"";
            break;
    }
    if([NSString isBlankString:errorString]){
        return;
    }
    self.alertView = [[UIAlertView alloc] initWithTitle:errorString message:nil     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.alertView show];
}
@end
