//
//  CategoryCollectionViewCell.m
//  App
//
//  Created by guoqiang on 2018/10/22.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "CategoryCollectionViewCell.h"
#import "CategoryButton.h"
#import "UIButton+ImageTitleSpacing.h"
@implementation CategoryCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setCellData:nil andPage:0];
    }
    return self;
}

- (void)setCellData:(NSArray*)array andPage:(NSInteger)page{
    
    
    CGFloat vW = 60;
    CGFloat vH = 80;
    
    NSInteger count = 10;
    CGFloat margin = (kMainScreenOfWidth-vW*5)/6.0;
    CGFloat marginY = 15;
    
    for(int i = 0;i<count;i++){
        int col = i / 5;
        int row = i % 5;
        CGFloat imageX = (vW + margin)*row + margin;
        CGFloat imageY = (vH + marginY)*col + marginY;
        CGRect frame = CGRectMake(imageX,imageY,vW, vH);

       // NSString* url = @"http://pic29.nipic.com/20130511/9252150_174018365301_2.jpg";

        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor grayColor];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
       // [btn sd_setImageWithURL:[NSURL URLWithString:url] forState:0];
       
       // [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:0];
        
        btn.frame = frame;
        [btn setImage:[UIImage imageNamed:@"选中打钩"] forState:UIControlStateNormal];
        [btn setTitle:@"自定义按钮" forState:UIControlStateNormal];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
        [self addSubview:btn];
        
        
        
    }
    

}

@end
