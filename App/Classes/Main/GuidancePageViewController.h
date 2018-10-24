
//  GuidancePageViewController.h
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.

#import <UIKit/UIKit.h>

@interface GuidancePageViewController : UIViewController<UIScrollViewDelegate>
    
/**
 新特性属性设置
 *imageArray   图片数组
 *showSkip  是否展示跳过
 *selColor    选择小圆点的颜色
 *showPageCount 是否展示小圆点
 
 @param BaseSettingBlock 基础设置
 */
- (void)setUpFeatureAttribute:(void(^)(NSArray **imageArray,UIColor **selColor,BOOL *showSkip,BOOL *showPageCount))BaseSettingBlock;

@end
