
//  Created by guoqiang on 2014/10/20.
//  Copyright © 2014年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 获取center位置

 @param rect 视图的frame
 @return 视图的center
 */
CGPoint CGRectGetCenter(CGRect rect);


/**
 将视图移动到指定的center位置

 @param rect 视图frame
 @param center center位置
 @return 新的frame
 */
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (GQLayout)

@property (nonatomic, assign) CGPoint gq_origin;
@property (nonatomic, assign) CGSize gq_size;

@property (nonatomic, assign, readonly) CGPoint gq_bottomLeft;
@property (nonatomic, assign, readonly) CGPoint gq_bottomRight;
@property (nonatomic, assign, readonly) CGPoint gq_topRight;

@property (nonatomic, assign) CGFloat gq_height;
@property (nonatomic, assign) CGFloat gq_width;

@property (nonatomic, assign) CGFloat gq_top;
@property (nonatomic, assign) CGFloat gq_bottom;

@property (nonatomic, assign) CGFloat gq_left;
@property (nonatomic, assign) CGFloat gq_right;

@property (nonatomic, assign) CGFloat gq_centerX;
@property (nonatomic, assign) CGFloat gq_centerY;

- (void)gq_moveBy:(CGPoint) delta;
- (void)gq_scaleBy:(CGFloat) scaleFactor;
- (void)gq_fitInSize:(CGSize) aSize;

/**
 点击手势
 @param block 点击后的回调.
 */
- (void)gq_setTapActionWithBlock:(void (^)(void))block;

/**
 长按手势
 @param block 长按手势后的回调.
 */
- (void)gq_setLongPressActionWithBlock:(void (^)(void))block;

@end
