//
//  ListTableViewCell.m
//  App
//
//  Created by guoqiang on 2018/10/17.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "ListTableViewCell.h"
#import "AXRatingView.h"

@interface ListTableViewCell()

@property(nonatomic,strong)UIImageView* shopImageView;
@property(nonatomic,strong)UILabel* shopTitleLabel;
@property(nonatomic,strong)AXRatingView* aXRatingView;
@property(nonatomic,strong)UILabel* numberLabel;
@property(nonatomic,strong)UILabel* infoLabel;
@property(nonatomic,strong)UILabel* distanceLabel;



@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    self.shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 70, 70)];
    [self.shopImageView setImage:[UIImage imageNamed:@"banner默认"]];
    [self addSubview:self.shopImageView];
    
    self.shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shopImageView.gq_right + 10, self.shopImageView.gq_top, 100, 20)];
    [self addSubview:self.shopTitleLabel];
    [self.shopTitleLabel setText:@"八宝粥"];
    
    self.aXRatingView = [[AXRatingView alloc] initWithFrame:CGRectMake(self.shopTitleLabel.gq_left,self.shopTitleLabel.gq_bottom + 10, 100, 10)];
    self.aXRatingView.userInteractionEnabled = false;
    [self.aXRatingView setMarkFont:[UIFont systemFontOfSize:12]];
    [self.aXRatingView setStepInterval:1.0];
    [self.aXRatingView setValue:5];
    [self.aXRatingView sizeToFit];
    [self addSubview:self.aXRatingView];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.aXRatingView.gq_right + 10, self.shopTitleLabel.gq_bottom + 10, 100, 15)];
    self.numberLabel.text = @"月售666";
    self.numberLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.numberLabel];
    
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.aXRatingView.gq_left, self.aXRatingView.gq_bottom + 5, 160, 20)];
    self.infoLabel.text = @"起送￥20 | 配送￥4 | 人均￥18";
    self.infoLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.infoLabel];
    
    
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenOfWidth - 100, self.infoLabel.gq_top, 85, 20)];
    [self.distanceLabel setTextAlignment:NSTextAlignmentRight];
    self.distanceLabel.text = @"28分钟 1.0Km";
    self.distanceLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.distanceLabel];
    
}

#pragma mark 赋值
- (void)setCellData:(NSDictionary*)dict{
    
    
}


@end
