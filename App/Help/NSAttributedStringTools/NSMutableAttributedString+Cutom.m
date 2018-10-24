//
//  NSMutableAttributedString+Cutom.m
//  TaxiAppPassenger
//
//  Created by 花落永恒 on 16/12/12.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import "NSMutableAttributedString+Cutom.h"

@implementation NSMutableAttributedString (Cutom)

- (void)addTypeStr:(NSString *)str value:(NSString *)value Font:(UIFont *)font{
    
    if ([NSString isBlankString:str] || [NSString isBlankString:value]) {
        return;
    }
    
    NSRange range = [str rangeOfString:value];
    
    [self addAttribute:NSFontAttributeName value:font range:range];
    [self addAttribute:NSForegroundColorAttributeName value:[UIColor colorForMainColor] range:range];
}

- (void)addTypeStr:(NSString *)str value:(NSString *)value Color:(UIColor *)color{
    
    if ([NSString isBlankString:str] || [NSString isBlankString:value]) {
        return;
    }
    NSRange range = [str rangeOfString:value];
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

+ (NSMutableAttributedString *)addTypeStr:(NSString *)str value:(NSString *)value Font:(UIFont *)font{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    if ([NSString isBlankString:str] || [NSString isBlankString:value]) {
        return attStr;
    }
    NSRange range = [str rangeOfString:value];
    [attStr addAttribute:NSFontAttributeName value:font range:range];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    return attStr;
}


@end

