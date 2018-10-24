//
//  NSString+Extension.h
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  字符串转义
 *
 *  @param str 需要转义的字符串
 *
 *  @return 返回转义好的字符串
 */

+(NSString*)specialCharactersString:(NSString*)str;

/**
 *  获取字符串的Size
 *
 *  @param str      字符串值
 *  @param widht    是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
 *  @param fontSize 字符串字体大小
 *  @return 返回字符串的Size
 */
+(CGSize)getStringSize:(NSString*)str andWidht:(CGFloat)widht andFont:(CGFloat)fontSize;

/// 获取文字的高度
+ (CGSize)caculateTheHeightOfWords:(NSString *)words LineWidth:(CGFloat)LineWidth fontSize:(CGFloat)fontSize lineSpace:(CGFloat)lineSpace;

@end
