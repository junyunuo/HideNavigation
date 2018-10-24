//
//  SortSegmentedControl.m
//  DeQingYouXuanApp
//
//  Created by guoqiang on 17/2/24.
//  Copyright © 2017年 guoqiang. All rights reserved.
//

#import "SortSegmentedControl.h"

@interface SortSegmentedControl()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@property(nonatomic,strong)UIImage* defaultImage;
@property(nonatomic,strong)UIImage* upImage;

@property(nonatomic,assign)BOOL isUp;


@end

@implementation SortSegmentedControl



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}


- (void)setControlTitles:(NSArray *)controlTitles{

    self.backgroundColor = [UIColor whiteColor];
    
    self.defaultImage = [UIImage imageNamed:@"箭头下.png"];
    self.upImage = [UIImage imageNamed:@"箭头上.png"];

    self.buttons = [NSMutableArray array];
    NSInteger count =controlTitles.count;
    if (count == 0) {
        return;
    }
    CGFloat width = 85;
    CGFloat height = self.gq_height;
    CGFloat centerW = (self.gq_width - width*count) / (count - 1);
    
    for (int i = 0; i < count; ++i) {
        CGRect frame = CGRectMake(width * i, 0, width, height);
        if(i > 0){
            frame = CGRectMake(width * i + centerW*i, 0, width, height);
        }
        CustomSortButton *button = [[CustomSortButton alloc] initWithFrame:frame];
        button.titleLabel.font = self.titleFont;

        [button setTitle:controlTitles[i] forState:UIControlStateNormal];
        
        [button setImage:self.defaultImage forState:0];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(didClickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
    UIImageView* lineView = [[UIImageView alloc] init];
    lineView.frame = CGRectMake(0, self.gq_height - 1, kMainScreenOfWidth,1);
    lineView.image = [UIImage imageNamed:@"Line.png"];
    [self addSubview:lineView];
}

- (void)didClickButtonForIndex:(NSInteger)index{
    
    CustomSortButton* btn =(CustomSortButton*)[self.buttons objectAtIndex:index];
    [btn setImage:self.defaultImage forState:0];
    btn.selected = true;
    self.currentSelectBtn = btn;
    
}


- (void)setButtonStatus:(NSInteger)index atTitle:(NSString*)title{

    CustomSortButton* btn =(CustomSortButton*)[self.buttons objectAtIndex:index];
    [btn setImage:self.defaultImage forState:0];
    [btn setTitle:title forState:0];
    btn.selected = false;
    self.currentSelectBtn = nil;
}

- (void)setDefaultStatus:(NSInteger)index{

    CustomSortButton* btn =(CustomSortButton*)[self.buttons objectAtIndex:index];
    [btn setImage:self.defaultImage forState:0];
    
    btn.selected = false;
    self.currentSelectBtn = nil;
}

#pragma mark Button 方法
- (void)didClickOnButton:(CustomSortButton *)sender{
    
    if (sender != self.currentSelectBtn){
        
        [self.currentSelectBtn setImage:self.defaultImage forState:0];
        self.currentSelectBtn.selected = NO;
        sender.selected = YES;
        self.currentSelectBtn = sender;
        self.currentIndex = [self.buttons indexOfObject:sender];
        if(sender.currentImage == self.defaultImage){
            [sender setImage:self.upImage forState:0];
            self.isUp = true;
        }
    }else{
        sender.selected = false;
        [sender setImage:self.defaultImage forState:0];
        self.currentSelectBtn = nil;
        self.currentIndex = [self.buttons indexOfObject:sender];
        self.isUp = false;
    }
    if([self.delegate respondsToSelector:@selector(segmentedControl:didSelectItemAtButtom:setIsUp:)]){
        [self.delegate segmentedControl:self.currentIndex didSelectItemAtButtom:sender setIsUp:self.isUp];
    }
}


@end
