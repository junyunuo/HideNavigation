//
//  StrUtil.h
//  OrderFood
//
//  Created by Berwin on 13-4-10.
//  Copyright (c) 2013年 Berwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageUtil : NSObject


+ (UIImage *)fixrotation:(UIImage *)image;
+(UIImage*) defaultIcon;

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
@end

