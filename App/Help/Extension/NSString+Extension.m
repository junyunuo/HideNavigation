//
//  NSString+Extension.m
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(NSString*)specialCharactersString:(NSString*)str{
    
    if([str rangeOfString:@"/"].location !=NSNotFound)
    {
        str= [str stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    }
    if([str rangeOfString:@"'"].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    if([str rangeOfString:@"["].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    }
    if([str rangeOfString:@"]"].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    }
    if([str rangeOfString:@"%"].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    }
    if([str rangeOfString:@"&"].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    }
    if([str rangeOfString:@"_"].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@"_" withString:@"/_]"];
    }
    if([str rangeOfString:@"("].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    }
    if([str rangeOfString:@")"].location !=NSNotFound){
        str= [str stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    }
    
    return str;
}

#pragma mark 获取字符的Size
+(CGSize)getStringSize:(NSString*)str andWidht:(CGFloat)widht andFont:(CGFloat)fontSize{
    
    //计算字体的高度
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize sizeRange = CGSizeMake(widht,CGFLOAT_MAX);
    
    str= [[str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r"]] componentsJoinedByString:@""];
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGSize size=[str boundingRectWithSize:sizeRange options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size;
}

#pragma mark --- 根据文字相关属性计算文字高度
+ (CGSize)caculateTheHeightOfWords:(NSString *)words LineWidth:(CGFloat)LineWidth fontSize:(CGFloat)fontSize lineSpace:(CGFloat)lineSpace{
    // 设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    // 文字属性
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle};
    
    // 根据所依据的属性计算size
    CGSize size = [words boundingRectWithSize:CGSizeMake(LineWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size;
}

@end
