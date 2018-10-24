//
//  BannerTableViewCell.h
//  App
//
//  Created by guoqiang on 2018/10/22.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerTableViewCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray* pictureList;
@property(nonatomic,assign)NSInteger totalPages;    // 总页数
@property(nonatomic,assign)NSInteger currentPage;     // 当前页码数
//@property(nonatomic,strong)NSTimer* countDownTimer;
@property(nonatomic,strong)SDCycleScrollView* sdCycleScrollView;
@end

NS_ASSUME_NONNULL_END
