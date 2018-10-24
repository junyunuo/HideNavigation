//
//  CustomPickerView.m
//  OneHome
//
//  Created by 郭强 on 16/6/24.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation CustomPickerView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kMainScreenOfWidth,kMainScreenOfHeight);
    }
    return self;
}
- (void)showView{
    
    [self createViewParentView];

    _pickerViewBackGround = [[UIView alloc] init];
    _pickerViewBackGround.backgroundColor = [UIColor whiteColor];
    _pickerViewBackGround.frame = CGRectMake(0,self.parentView.gq_height -200,self.parentView.gq_width ,200);
    [self.parentView addSubview:self.pickerViewBackGround];
    
    _titleView  = [[UIView alloc] initWithFrame:CGRectMake(0,0, kMainScreenOfWidth, 44)];
    _titleView.backgroundColor = [UIColor colorWithHexRGB:@"eeeeee"];
    [self.pickerViewBackGround addSubview:_titleView];
    
    
    self.typeLabel=[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenOfWidth - 300,0,150,44)];
    self.typeLabel.textColor = [UIColor colorWithHexRGB:@"333333"];
    self.typeLabel.text=@"选择银行";
    self.typeLabel.center = self.titleView.center;
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.font = [UIFont systemFontOfSize:17];
    
    [self.titleView addSubview:self.typeLabel];

    //取消
    UIButton* cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake(0,0,70, 44);
    [cancelButton setTitle:@"取消" forState:0];
    [cancelButton setTitleColor:[UIColor colorWithHexRGB:@"333333"] forState:0];
   // cancelButton.backgroundColor = [UIColor colorWithHexRGB:@"ff6766"];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:cancelButton];
    
    
    //确定
    UIButton* confirmButton = [[UIButton alloc] init];
    confirmButton.frame = CGRectMake(kMainScreenOfWidth - 70,0,70, 44);
    [confirmButton setTitle:@"确定" forState:0];
    [confirmButton setTitleColor:[UIColor colorWithHexRGB:@"333333"] forState:0];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:confirmButton];
    
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.frame = CGRectMake(0,44,self.parentView.gq_width,200);
    _pickerView.backgroundColor=[UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.pickerViewBackGround addSubview:self.pickerView];
    
}
- (void)closeView{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    [self removeFromSuperview];
}


- (void)createViewParentView{

    
    self.parentView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:self.parentView];
    
    self.parentView.layer.shouldRasterize = YES;
    self.parentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
            break;
        default:
            break;
    }
    
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
    
    
    self.parentView.layer.opacity = 0.5f;
    self.parentView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         
                         self.parentView.layer.opacity = 1.0f;
                         self.parentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         
                     }
                     completion:NULL
     ];
}


#pragma mark 取消按钮
- (void)cancelButtonAction{
    [self closeView];
}

#pragma mark 确定
- (void)confirmButtonAction{
    [self closeView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if([self.delegate respondsToSelector:@selector(numberOfRowsInComponent)]){
        return [self.delegate numberOfRowsInComponent];
    }
    return 10;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if([self.delegate respondsToSelector:@selector(pickerViewFortitleForRow:)]){
        return [self.delegate pickerViewFortitleForRow:row];
    }
    return @"分类选择";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if([self.delegate respondsToSelector:@selector(didSelectRow:)]){
        [self.delegate didSelectRow:row];
    }
}

- (void)reloadData:(NSInteger)index{

    [self.pickerView selectRow:index inComponent:0 animated:false];
    [self.pickerView reloadAllComponents];

}




@end
