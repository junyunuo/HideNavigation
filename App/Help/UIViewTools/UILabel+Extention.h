//
//  UILabel+Extention.h
//  RedPacketDemo2
//
//  Created by 胡海波 on 15/9/16.
//  Copyright (c) 2015年 胡海波. All rights reserved.
//

#import <UIKit/UIKit.h>
//海耶斯
@interface UILabel (Extention)

///自定义label的扩展
+ (instancetype)lableWithParagraph:(NSString *)para numberOfLines:(NSInteger)lines font:(UIFont *)font textColor:(UIColor *)color lineSpacing:(CGFloat)lineSpace;

+ (instancetype)lableWithParagraph:(NSString *)para numberOfLines:(NSInteger)lines font:(UIFont *)font textColor:(UIColor *)color lineSpacing:(CGFloat)lineSpace textAlignment:(NSTextAlignment)textAlignment;

/// 设置label行间距
+ (void)setLineSpaceForLabel:(UILabel *)label lineSpace:(CGFloat)lineSpace;

@end
