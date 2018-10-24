//
//  NSMutableAttributedString+Cutom.h
//  TaxiAppPassenger
//
//  Created by 花落永恒 on 16/12/12.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Cutom)

//str 中的 value 字段范围 改变属性
- (void)addTypeStr:(NSString *)str value:(NSString *)value Font:(UIFont *)font;
//改变颜色
- (void)addTypeStr:(NSString *)str value:(NSString *)value Color:(UIColor *)color;
+ (NSMutableAttributedString *)addTypeStr:(NSString *)str value:(NSString *)value Font:(UIFont *)font;

@end
