//
//  LLTabBar.h
//  LLRiseTabBarDemo
//
//  Created by Meilbn on 10/18/15.
//  Copyright © 2015 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTabBarItem.h"

@protocol LLTabBarDelegate <NSObject>

- (void)tabBarDidSelectedRiseButton;

- (void)tabBarDidSelectedRiseButton:(NSInteger)tag;



//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item

@end

@interface LLTabBar : UIView

@property (nonatomic, copy) NSArray<NSDictionary *> *tabBarItemAttributes;
@property (nonatomic, weak) id <LLTabBarDelegate> delegate;
/**
 *  显示红点
 *
 *  @param index
 */
- (void)addBadgeView:(NSInteger)index;
/**
 *  显示消息数量
 */
- (void)addMakeBadgeNumView:(NSString*)number;

/**
 *  隐藏红点
 */
- (void)hideTabBarBadgeView:(NSInteger)index;

@end
