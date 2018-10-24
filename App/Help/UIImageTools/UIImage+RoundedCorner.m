// UIImage+RoundedCorner.m
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"

@implementation UIImage (RoundedCorner)

// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));

    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                       context:context
                     ovalWidth:cornerSize
                    ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);

    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

#pragma mark -
#pragma mark Private helper methods

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

/**
 *  绘制圆角图片
 *
 *  @param cornerRadius 圆角半径
 *  @param image        需要绘制的图片
 *
 *  @return 所需的UIImage对象
 */
+ (UIImage *)imageWithRoundCorners:(CGFloat)cornerRadius image:(UIImage *)image{
    
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // 开始绘制
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    
    // 通过贝塞尔路径根据相关参数裁剪图片
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    
    // 绘制需要的图片
    [image drawInRect:frame];
    
    // 获取最终绘制的image对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭image上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithRoundCorners:(CGFloat)cornerRadius image:(UIImage *)image size:(CGSize)size{
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    // 开始绘制
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    
    // 通过贝塞尔路径根据相关参数裁剪图片
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    
    // 绘制需要的图片
    [image drawInRect:frame];
    
    // 获取最终绘制的image对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭image上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
