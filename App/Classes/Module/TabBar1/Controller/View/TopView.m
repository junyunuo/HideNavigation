//
//  TopView.m
//  App
//
//  Created by guoqiang on 2018/10/18.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "TopView.h"

@interface TopView()
@property(nonatomic,strong)UIButton* locationBtn;
@property(nonatomic,strong)UIButton* messageBtn;
@property(nonatomic,strong)UIButton* signBtn;
@property(nonatomic,strong)UISearchBar* searchBar;
@end

@implementation TopView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        [self initWithSubView:frame];
    }
    return self;
}

- (void)initWithSubView:(CGRect)frame{
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];

    self.locationBtn = [[UIButton alloc] init];
    [self.locationBtn setTitle:@"优盘时代" forState:0];
    [self.locationBtn setTitleColor:[UIColor blackColor] forState:0];
    [self addSubview:self.locationBtn];

    self.signBtn = [[UIButton alloc] init];
    [self.signBtn setTitle:@"sign" forState:0];
    [self.signBtn setTitleColor:[UIColor blackColor] forState:0];
    [self addSubview:self.signBtn];
    
    self.messageBtn = [[UIButton alloc] init];
    [self.messageBtn setTitle:@"mes" forState:0];
    [self.messageBtn setTitleColor:[UIColor blackColor] forState:0];
    [self addSubview:self.messageBtn];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"输入商家,商品名称";
    UITextField* searchField = [self.searchBar valueForKey:@"searchField"];
    if(searchField){
        [searchField setBackgroundColor:[UIColor colorWithHexRGB:@"EAEAEA"]];
        searchField.layer.cornerRadius=18;//设置圆角具体根据实际情况来设置
        searchField.layer.masksToBounds=YES;
    }
    for(int i =  0 ;i < _searchBar.subviews.count;i++){
        UIView * backView = _searchBar.subviews[i];
        if ([backView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] == YES) {
            [backView removeFromSuperview];
            [_searchBar setBackgroundColor:[UIColor clearColor]];
            break;
        }else{
            NSArray * arr = _searchBar.subviews[i].subviews;
            for(int j = 0;j<arr.count;j++   ){
                UIView * barView = arr[i];
                if ([barView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] == YES) {
                    [barView removeFromSuperview];
                    [_searchBar setBackgroundColor:[UIColor clearColor]];
                    break;
                }
            }
        }
    }
    [self addSubview:self.searchBar];

    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40);
        make.left.offset(15);
        make.width.offset(100);
        make.height.offset(20);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationBtn.mas_bottom).offset(10);
        make.left.offset(15);
        make.width.offset(kMainScreenOfWidth - 30);
        make.height.offset(44);
    }];
    
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationBtn.mas_top);
        make.right.offset(-10);
        make.height.width.offset(44);
        make.centerY.equalTo(self.locationBtn.mas_centerY);
    }];
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locationBtn.mas_centerY);
        make.right.equalTo(self.signBtn.mas_left).offset(-10);
        make.height.width.offset(44);
    }];
}

@end
