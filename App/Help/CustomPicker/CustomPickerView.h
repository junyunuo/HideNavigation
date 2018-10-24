//
//  CustomPickerView.h
//  OneHome
//
//  Created by 郭强 on 16/6/24.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomPickerViewDelegate <NSObject>

- (NSInteger)numberOfRowsInComponent;
- (NSString*)pickerViewFortitleForRow:(NSInteger)index;
- (void)didSelectRow:(NSInteger)index;



@end

@interface CustomPickerView : UIView
/**
 *  父视图 也是背景视图
 */
@property(nonatomic,strong)UIView* parentView;

@property(nonatomic,strong)UIPickerView* pickerView;
@property(nonatomic,strong)UIView* pickerViewBackGround;
@property(nonatomic,strong)UIView* titleView;
@property(nonatomic,strong)UIView* panelView;
@property(nonatomic,strong)UILabel* typeLabel;
@property(nonatomic,weak)id <CustomPickerViewDelegate> delegate;

@property(nonatomic,strong)NSString* symbol;


- (void)reloadData:(NSInteger)index;
- (void)showView;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;



@end
