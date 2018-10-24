//
//  LLTabBar.m
//  LLRiseTabBarDemo
//
//  Created by Meilbn on 10/18/15.
//  Copyright © 2015 meilbn. All rights reserved.
//

#import "LLTabBar.h"

@interface LLTabBar ()

@property (strong, nonatomic) NSMutableArray *tabBarItems;
@property(nonatomic,strong)NSMutableArray * tabBarItemArray;

@property(nonatomic,strong)NSMutableArray* badgeArrays;


//出车
@property(nonatomic,strong)UILabel* carBadgeLabel;
//消息
@property(nonatomic,strong)UILabel* messageBadgeLabel;
//预约
@property(nonatomic,strong)UILabel* bookBadgeLabel;
//来往
@property(nonatomic,strong)UILabel* laiwangBadgeLabel;


@end

@implementation LLTabBar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self config];
	}
	
	return self;
}

#pragma mark - Private Method

- (void)config {
    
    self.tabBarItemArray = [[NSMutableArray alloc] init];
    self.badgeArrays  = [[NSMutableArray alloc] init];
	self.backgroundColor = [UIColor whiteColor];
    
	UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kMainScreenOfWidth,1)];
	topLine.image = [UIImage imageNamed:@"Line.png"];
	[self addSubview:topLine];
}
- (void)setSelectedIndex:(NSInteger)index {
	for (LLTabBarItem *item in self.tabBarItems) {
		if (item.tag == index) {
			item.selected = YES;
		} else {
			item.selected = NO;
		}
	}
	UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
	UITabBarController *tabBarController = (UITabBarController *)keyWindow.rootViewController;
	if (tabBarController) {
		tabBarController.selectedIndex = index;
	}
    
    if([self.delegate respondsToSelector:@selector(tabBarDidSelectedRiseButton:)]){
        [self.delegate tabBarDidSelectedRiseButton:index];
    }
    
}

#pragma mark - Touch Event

- (void)itemSelected:(LLTabBarItem *)sender {
	if (sender.tabBarItemType != LLTabBarItemRise) {
		[self setSelectedIndex:sender.tag];
    } else {
		if (self.delegate) {
			if ([self.delegate respondsToSelector:@selector(tabBarDidSelectedRiseButton)]) {
				[self.delegate tabBarDidSelectedRiseButton];
			}
		}
	}
}

#pragma mark - Setter

- (void)setTabBarItemAttributes:(NSArray<NSDictionary *> *)tabBarItemAttributes {
	_tabBarItemAttributes = tabBarItemAttributes.copy;
    
    NSAssert(_tabBarItemAttributes.count > 2, @"TabBar item count must greet than two.");
    
//    CGFloat normalItemWidth = (kMainScreenOfWidth * 4 / 5) / (_tabBarItemAttributes.count - 1);
//    CGFloat tabBarHeight = CGRectGetHeight(self.frame);
//    CGFloat publishItemWidth = (kMainScreenOfWidth / 4);
    
    CGFloat normalItemWidth = (kMainScreenOfWidth * 3 / 4) / (_tabBarItemAttributes.count - 1);
    CGFloat tabBarHeight = CGRectGetHeight(self.frame);
    CGFloat publishItemWidth = (kMainScreenOfWidth / 4);
    
	NSInteger itemTag = 0;
    BOOL passedRiseItem = NO;
    
    _tabBarItems = [NSMutableArray arrayWithCapacity:_tabBarItemAttributes.count];
    
	for (id item in _tabBarItemAttributes) {
		if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = (NSDictionary *)item;
            
            LLTabBarItemType type = [itemDict[kLLTabBarItemAttributeType] integerValue];
            
            CGRect frame = CGRectMake(itemTag * normalItemWidth + (passedRiseItem ? publishItemWidth : 0),1, type == LLTabBarItemRise ? publishItemWidth : normalItemWidth, tabBarHeight);
            
            LLTabBarItem *tabBarItem = [self tabBarItemWithFrame:frame
                                                         title:itemDict[kLLTabBarItemAttributeTitle]
                                               normalImageName:itemDict[kLLTabBarItemAttributeNormalImageName]
                                             selectedImageName:itemDict[kLLTabBarItemAttributeSelectedImageName] tabBarItemType:type];
            [self.tabBarItemArray addObject:tabBarItem];
			if (itemTag == 0) {
				tabBarItem.selected = YES;
			}
            
			[tabBarItem addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            if (tabBarItem.tabBarItemType != LLTabBarItemRise) {
                tabBarItem.tag = itemTag;
                itemTag++;
            } else {
                passedRiseItem = YES;
            }
            
            [_tabBarItems addObject:tabBarItem];
			[self addSubview:tabBarItem];
		}
	}

}

- (LLTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    LLTabBarItem *item = [[LLTabBarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:8];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}


#pragma mark 隐藏红点
- (void)hideTabBarBadgeView:(NSInteger)index{
    
    LLTabBarItem *tabBarItem = self.tabBarItemArray[index];
    tabBarItem.badgeLabel.hidden = true;
}


#pragma mark 显示消息红点
- (void)addBadgeView:(NSInteger)index{

    LLTabBarItem *tabBarItem = self.tabBarItemArray[index];
    tabBarItem.badgeLabel.hidden = false;
}

#pragma mark 添加 预约消息数量
- (void)addMakeBadgeNumView:(NSString*)number{
    
    if(self.tabBarItems.count ==0){
        return;
    }
    LLTabBarItem *tabBarItem = self.tabBarItems[2];
    tabBarItem.badgeLabel.hidden = false;
    tabBarItem.badgeLabel.textColor = [UIColor whiteColor];
    tabBarItem.badgeLabel.text = number;
    tabBarItem.badgeLabel.center = tabBarItem.imageView.center;
    tabBarItem.badgeLabel.layer.masksToBounds = true;
    [tabBarItem.badgeLabel sizeToFit];
    tabBarItem.badgeLabel.gq_width = tabBarItem.badgeLabel.gq_height;
    tabBarItem.badgeLabel.layer.cornerRadius = tabBarItem.badgeLabel.gq_width/2;
    tabBarItem.badgeLabel.frame = CGRectMake(tabBarItem.imageView.gq_right - (tabBarItem.badgeLabel.gq_width/2) - 6, -15, tabBarItem.badgeLabel.gq_width, tabBarItem.badgeLabel.gq_height);
}

@end
