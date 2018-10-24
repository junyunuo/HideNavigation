//
//  SegmentedControl.h
//  Copyright © 2015年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define scale  kMainScreenOfWidth/375.0f

@class SegmentedControl;
@protocol SegmentedControlDelegate <NSObject>

- (void)segmentedControl:(SegmentedControl *)control didSelectItemAtIndex:(NSUInteger)index;

@end

@interface SegmentedControl : UIView

@property(nonatomic,strong)NSDictionary* userInfo;


@property (nonatomic, strong) NSArray *controlTitles;
@property (nonatomic, weak) id <SegmentedControlDelegate> delegate;
@property (nonatomic,strong)NSString* pageStyle;
@property (nonatomic, strong) UIColor *focusedColor;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic,strong) UIFont* baseFont;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic,assign) CGFloat indicatorWidth;

@property(nonatomic)NSInteger currentIndex;
- (void)hideBadge:(BOOL)shouldShow atIndex:(NSInteger)index;
- (void)didClickButtonForIndex:(NSInteger)index;

@end
