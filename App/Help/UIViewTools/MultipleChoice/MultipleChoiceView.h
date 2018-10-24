//
//  MultipleChoiceView.h
//  TaxiAppPassenger
//
//  Created by 花落永恒 on 16/12/17.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SetArea.h"
#import "JCTagListView.h"

@interface MultipleChoiceView : UIView

/**
 *  父视图 也是背景视图
 */
@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) void (^confirmBlock)(NSArray *,NSArray *);
@property (strong, nonatomic) NSMutableArray *taglistArray;
@property (strong, nonatomic) JCTagListView *tagListView;

- (void)showTaglistView;
- (void)closeTaglistView;

@end
