//
//  SortSegmentedControl.h
//  DeQingYouXuanApp
//
//  Created by guoqiang on 17/2/24.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSortButton.h"

@class SortSegmentedControl;
@class CustomSortButton;
@protocol SortSegmentedControlDelegate <NSObject>

@optional
- (void)segmentedControl:(NSUInteger)index didSelectItemAtButtom:(CustomSortButton*)currentButton setIsUp:(BOOL)isUp;

- (void)didSelectItemAtIndex:(NSString*)title;



@end

@interface SortSegmentedControl : UIView

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property(nonatomic,strong)UIFont* titleFont;
@property(nonatomic)NSInteger currentIndex;

@property (nonatomic, weak) id <SortSegmentedControlDelegate> delegate;
@property (nonatomic, strong) CustomSortButton *currentSelectBtn;

@property(nonatomic,strong)NSString* pushType;



- (void)setControlTitles:(NSArray *)controlTitles;

- (void)didClickButtonForIndex:(NSInteger)index;

- (void)setDefaultStatus:(NSInteger)index;

- (void)setButtonStatus:(NSInteger)index atTitle:(NSString*)title;



@end
