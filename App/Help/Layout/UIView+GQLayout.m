//  Created by guoqiang on 2014/10/20.
//  Copyright © 2014年 guoqiang. All rights reserved.
//

#import "UIView+GQLayout.h"
#import <objc/runtime.h>


#pragma mark 获取Rect的中心点
CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint point;
    point.x = CGRectGetMidX(rect);
    point.y = CGRectGetMidY(rect);
    return point;
}

#pragma mark 将Rect按center整体移动到指定的位置
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newRect = CGRectZero;
    newRect.origin.x = center.x - CGRectGetMidX(rect);
    newRect.origin.y = center.y - CGRectGetMidY(rect);
    newRect.size = rect.size;
    return newRect;
}

// 关联对象的key
static char kHBActionHandlerTapBlockKey;
static char kHBActionHandlerTapGestureKey;
static char kHBActionHandlerLongPressBlockKey;
static char kHBActionHandlerLongPressGestureKey;

@implementation UIView (HHBExtension)

#pragma mark - Properties
#pragma mark 设置origin
- (CGPoint)gq_origin {
    return self.frame.origin;
}

- (void)setGq_origin:(CGPoint)hb_origin {
    CGRect newframe = self.frame;
    newframe.origin = hb_origin;
    self.frame = newframe;
}



#pragma mark 设置size
- (CGSize) gq_size {
    return self.frame.size;
}

- (void)setGq_size:(CGSize)aSize {
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

#pragma mark 获取其他位置
- (CGPoint)gq_bottomRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)gq_bottomLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)gq_topRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


#pragma mark 设置height
- (CGFloat)gq_height {
    return self.frame.size.height;
}

- (void)setGq_height:(CGFloat)newheight {
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

#pragma mark 设置width
- (CGFloat)gq_width {
    return self.frame.size.width;
}

- (void)setGq_width:(CGFloat)newwidth {
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

#pragma mark 设置top
- (CGFloat)gq_top {
    return self.frame.origin.y;
}

- (void)setGq_top:(CGFloat)newtop {
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

#pragma mark 设置left
- (CGFloat)gq_left {
    return self.frame.origin.x;
}

- (void)setGq_left:(CGFloat)newleft {
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

#pragma mark 设置bottom
- (CGFloat)gq_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setGq_bottom:(CGFloat)newbottom {
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

#pragma mark 设置right
- (CGFloat)gq_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setGq_right:(CGFloat)newright {
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

#pragma mark 设置centerX
- (CGFloat)gq_centerX {
    return self.center.x;
}

- (void)setGq_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

#pragma mark 设置centerY
- (CGFloat)gq_centerY {
    return self.center.y;
}

- (void)setGq_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark 设置偏移量
- (void)gq_moveBy:(CGPoint)delta {
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

- (void)gq_scaleBy:(CGFloat)scaleFactor {
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

- (void)gq_fitInSize:(CGSize)aSize {
    CGFloat scale;
    CGRect newframe = self.frame;
    if (newframe.size.height && (newframe.size.height > aSize.height)) {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    if (newframe.size.width && (newframe.size.width >= aSize.width)) {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    self.frame = newframe;
}

- (void)gq_setTapActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kHBActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_gq_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kHBActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kHBActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)_gq_handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kHBActionHandlerTapBlockKey);
        if (action) {
            action();
        }
    }
}

- (void)gq_setLongPressActionWithBlock:(void (^)(void))block {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kHBActionHandlerLongPressGestureKey);
    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_gq_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kHBActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kHBActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)_gq_handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^action)(void) = objc_getAssociatedObject(self, &kHBActionHandlerLongPressBlockKey);
        if (action) {
            action();
        }
    }
}


@end
