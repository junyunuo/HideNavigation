//
//  YQPayKeyWordVC.h
//  Youqun
//
//  Created by 王崇磊 on 16/6/1.
//  Copyright © 2016年 W_C__L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "YQInputPayKeyWordView.h"
#import "YQSelectPayStyleView.h"
#import "UIColor+PPCategory.h"

@protocol YQPayKeyWordVCDelegate <NSObject>

- (void)passWordCompleteInputDelegate:(NSString*)password;

@end

@interface YQPayKeyWordVC : UIViewController

- (void)showInViewController:(UIViewController *)vc;
@property(nonatomic,weak)id <YQPayKeyWordVCDelegate> delegate;
@property (strong, nonatomic) YQInputPayKeyWordView *keyWordView;
@property (strong, nonatomic) YQSelectPayStyleView *selectPayStyleView;
@end
