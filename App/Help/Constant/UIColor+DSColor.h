//
//  UIColor+DSColor.h


#import <UIKit/UIKit.h>

@interface UIColor (DSColor)
+ (UIColor *)colorWithHexRGB:(NSString *)inColorString;
+ (UIColor *)backGroundColor;
+ (UIColor *)mainColor;

//生成颜色图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color;

//主色调
+ (UIColor *)colorForMainColor;
//屎黄色
+ (UIColor *)colorForYellowColor;
//红色
+ (UIColor *)colorForRedColor;
//背景颜色
+ (UIColor *)colorForBackgroundColor;
+ (UIColor *)lineColor;
//字体颜色
+ (UIColor *)FontLightBlackColor;
//字体颜色
+ (UIColor *)FontLightGrayColor;

//边框颜色
+ (UIColor *)borderColor;

//自定义灰色颜色
+ (UIColor *)textLightColor;

@end
