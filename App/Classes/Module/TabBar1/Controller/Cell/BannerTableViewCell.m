//
//  BannerTableViewCell.m
//  App
//
//  Created by guoqiang on 2018/10/22.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "BannerTableViewCell.h"

@interface BannerTableViewCell()<SDCycleScrollViewDelegate>



@end

@implementation BannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    self.backgroundColor = [UIColor colorWithHexRGB:@"F6F7F8"];
    
    self.sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenOfWidth, 100) delegate:self placeholderImage:[UIImage imageNamed:@"banner默认.png"]];
    self.sdCycleScrollView.showPageControl = false;
    self.sdCycleScrollView.showPageImage = false;
    [self addSubview:self.sdCycleScrollView];
    
}

#pragma makr 点击图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
