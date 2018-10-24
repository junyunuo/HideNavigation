//
//  ZJHCustomDatePickerView.m
//  DatePicker
//
//  Created by 花落永恒 on 16/12/1.
//  Copyright © 2016年 花落永恒. All rights reserved.
//

#import "ZJHCustomDatePickerView.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define parentViewHeight 300
#define toolbarHeight 44
#define Alpha 0.8

@interface ZJHCustomDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *datePicker;
@property (strong, nonatomic) NSMutableArray *firstData,*secondData,*thirdData;//数据
@property (strong, nonatomic) NSMutableArray *hourArr,*minuteArr;//时间数组
@property (strong, nonatomic) NSString *firstResult,*secondResult,*thirdResult;//选择结果
@property (assign, nonatomic) NSInteger hour,minute;//当前时间
@property (nonatomic,retain) UIToolbar *actionToolbar;

//当前选择的为空则为数组的[0]
@property (strong, nonatomic) NSString *firstSelect;
@property (strong, nonatomic) NSString *secondSelect;
@property (strong, nonatomic) NSString *thirdSelect;

@end

@implementation ZJHCustomDatePickerView

#pragma mark 选择器
- (UIPickerView *)datePicker{
    if(!_datePicker){
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, parentViewHeight - toolbarHeight)];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
        
    }
    return _datePicker;
}

#pragma mark loadData
- (void)currentDataArray{
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
    self.hour = [dateComponent hour];
    self.minute = [dateComponent minute];
    self.hourArr = [NSMutableArray array];
    self.minuteArr = [NSMutableArray array];
    //    self.hour = 23;
    //    self.minute = 55;
    if (self.minute+20<=50) {
        for (NSInteger i=self.hour; i<24; i++) {
            [self.hourArr addObject:[NSString stringWithFormat:@"%ld点",(long)i]];
        }
        for (NSInteger i=(self.minute+25)/10; i<6; i++) {
            [self.minuteArr addObject:[NSString stringWithFormat:@"%ld0分",(long)i]];
        }
        self.secondData = self.hourArr;
        self.thirdData = self.minuteArr;
    }else{
        for (NSInteger i=self.hour+1; i<24; i++) {
            [self.hourArr addObject:[NSString stringWithFormat:@"%ld点",(long)i]];
        }
        for (NSInteger i=(self.minute+25-60)/10; i<6; i++) {
            [self.minuteArr addObject:[NSString stringWithFormat:@"%ld0分",(long)i]];
        }
        if (self.hourArr.count == 0) {
            [self pickerView:self.datePicker didSelectRow:1 inComponent:0];
        }
        self.secondData = self.hourArr;
        
        self.thirdData = self.minuteArr;
    }
}
#pragma mark PickerViewDelegate
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return [self.firstData count];
    }else if (component==1){
        return [self.secondData count];
    }else{
        return [self.thirdData count];
    }
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [self.firstData objectAtIndex:row];
    }else if (component==1){
        return [self.secondData objectAtIndex:row];
    }else{
        return [self.thirdData objectAtIndex:row];
    }
}
/**
 *  auth daizongzong
 *
 *  @param pickerViewt
 */
-(void)pickerView:(UIPickerView *)pickerViewt didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.firstResult =[self.firstData objectAtIndex:row];
        self.secondData=[NSMutableArray new];
        self.thirdData=[NSMutableArray new];
        if(row==0){
            if (self.hourArr.count==0) {
                [self.secondData addObject:@"现在"];
            }else{
                self.secondData=self.hourArr;
            }
            NSInteger eee;
            NSInteger fff;
            
            eee=[[self.secondResult substringToIndex:self.secondResult.length-1] integerValue];
            fff=[[[self.secondData objectAtIndex:0] substringToIndex:((NSString *)[self.secondData objectAtIndex:0]).length-1] integerValue];
            if (eee<fff) {
            }else{
                if ([_secondResult isEqualToString:[self.secondData objectAtIndex:0]]) {
                    self.thirdData=self.minuteArr;
                }else{
                    if (self.hour==[[self.secondResult substringToIndex:self.secondResult.length-1] integerValue]) {
                        self.thirdData=self.minuteArr;
                    }else{
                        if (self.minute+20>50) {
                            self.thirdData=self.minuteArr;
                        }else{
                            for (int i=0; i<6; i++) {
                                [self.thirdData addObject:[NSString stringWithFormat:@"%d0分",i]];
                            }
                        }
                    }
                }
            }
            
        }else{
            for (int i=0; i<24; i++) {
                [self.secondData addObject:[NSString stringWithFormat:@"%d点",i]];
            }
            if (row==1&&self.hour==23&&self.minute+20>50){
                self.thirdData=self.minuteArr;
            }else{
                for (int i=0; i<6; i++) {
                    [self.thirdData addObject:[NSString stringWithFormat:@"%d0分",i]];
                }
            }
        }
        NSInteger aaa;
        NSInteger bbb;
        [self.datePicker reloadComponent:1];
        if ([self.secondResult isEqualToString:@"现在"]) {
            [self.datePicker selectRow:0 inComponent:1 animated:NO];
        }else{
            if ([self.secondResult isEqualToString:@"现在"]) {
                aaa=self.hour;
            }else{
                aaa=[[self.secondResult substringToIndex:self.secondResult.length-1] integerValue];
            }
            if ([[self.secondData objectAtIndex:0]isEqualToString:@"现在"]) {
                bbb=self.hour;
            }else{
                bbb=[[[self.secondData objectAtIndex:0] substringToIndex:((NSString *)[self.secondData objectAtIndex:0]).length-1] integerValue];
            }
            if (aaa<bbb) {
                [self.datePicker selectRow:0 inComponent:1 animated:NO];
            }else{
                for (int i=0; i<[self.secondData count]; i++) {
                    if ([self.secondResult isEqualToString:[self.secondData objectAtIndex:i]]) {
                        [self.datePicker selectRow:i inComponent:1 animated:NO];
                    }
                }
            }
        }
        
        NSInteger ccc;
        NSInteger ddd;
        [self.datePicker reloadComponent:2];
        if (self.thirdResult.length==0) {
            [self.datePicker selectRow:0 inComponent:2 animated:NO];
        }else{
            ccc=[[self.thirdResult substringToIndex:self.thirdResult.length-2] integerValue];
            if (self.thirdData.count==0) {
                [self.datePicker selectRow:0 inComponent:2 animated:NO];
            }else{
                ddd=[[[self.thirdData objectAtIndex:0] substringToIndex:((NSString *)[self.thirdData objectAtIndex:0]).length-2] integerValue];
                if (ccc<ddd) {
                    [self.datePicker selectRow:0 inComponent:2 animated:NO];
                }else{
                    for (int i=0; i<[self.thirdData count]; i++) {
                        if ([self.thirdResult isEqualToString:[self.thirdData objectAtIndex:i]]) {
                            [self.datePicker selectRow:i inComponent:2 animated:NO];
                        }
                    }
                }
            }
        }
        if ([self.secondData count]==0) {
            self.secondResult=@"";
        }else{
            self.secondResult=self.secondResult;
        }
        if ([self.thirdData count]==0) {
            self.thirdResult=@"";
        }else{
            self.thirdResult=self.thirdResult;
        }
        self.firstSelect = [NSString stringWithFormat:@"%ld",(long)row];
    }
    if (component==1) {
        self.secondResult=[self.secondData objectAtIndex:row];
        self.thirdData=[NSMutableArray new];
        if ([[self.secondData objectAtIndex:0] isEqualToString:@"现在"]) {
            
        }else{
            if ([self.firstResult isEqualToString:@"明天"]&&row==0&&self.hour==23&&self.minute+20>50) {
                self.thirdData=self.minuteArr;
            }else{
                for (int i=0; i<6; i++) {
                    [self.thirdData addObject:[NSString stringWithFormat:@"%d0分",i]];
                }
            }
        }
        
        NSInteger hhh;
        NSInteger ggg;
        [self.datePicker reloadComponent:2];
        NSLog(@"%@",self.thirdResult);
        if (self.thirdResult.length==0) {
            [self.datePicker selectRow:0 inComponent:2 animated:NO];
        }else{
            hhh=[[self.thirdResult substringToIndex:self.thirdResult.length-2] integerValue];
            if (self.thirdData.count==0) {
                [self.datePicker selectRow:0 inComponent:2 animated:YES];
            }else{
                ggg=[[[self.thirdData objectAtIndex:0] substringToIndex:((NSString *)[self.thirdData objectAtIndex:0]).length-2] integerValue];
                if (hhh<ggg) {
                    [self.datePicker selectRow:0 inComponent:2 animated:NO];
                }else{
                    for (int i=0; i<[self.thirdData count]; i++) {
                        if ([self.thirdResult isEqualToString:[self.thirdData objectAtIndex:i]]) {
                            [self.datePicker selectRow:i inComponent:2 animated:NO];
                        }
                    }
                }
            }
        }
        
        if ([self.thirdData count]==0) {
            self.thirdResult=@"";
        }else{
            self.thirdResult=self.thirdResult;;
        }
        self.secondSelect = [NSString stringWithFormat:@"%ld",row];
    }
    if (component==2) {
        if ([self.thirdData count]==0) {
            self.thirdResult=@"";
        }else{
            self.thirdResult =[self.thirdData objectAtIndex:row];
        }
        self.thirdSelect = [NSString stringWithFormat:@"%ld",row];
    }
    NSLog(@"%ld%ld",component,row);
    
}
//设置滚轮的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 100;
    }else if(component==1){
        return 100;
    }else{
        return 100;
    }
}

#pragma mark showView
- (void)showDatePickerView{
    [self createViewParentView];
    [self createSubView];
}
#define mark closeView
- (void)closeDatePickerView{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.parentView.frame = CGRectMake(0, ScreenHeight + parentViewHeight, ScreenWidth, parentViewHeight);
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

- (void)createSubView{
    //选择器设置

    self.datePicker.showsSelectionIndicator=YES;
    
    self.firstData = [[NSMutableArray alloc]initWithObjects:@"今天",@"明天",@"后天", nil];
    self.secondData = [NSMutableArray array];
    self.thirdData = [NSMutableArray array];
    [self currentDataArray];
    self.actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, toolbarHeight)];
    [self.actionToolbar sizeToFit];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeDatePickerView)];
    [cancelButton setTintColor:[UIColor mainColor]];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneClicked:)];
    [doneBtn setTintColor:[UIColor mainColor]];
    
    [self.actionToolbar setItems:[NSArray arrayWithObjects:cancelButton,flexSpace,doneBtn, nil] animated:YES];
    //初始化数据
    [self.parentView addSubview:self.datePicker];
    [self.parentView addSubview:self.actionToolbar];
}
- (void)pickerDoneClicked:(UIButton *)button{
    NSLog(@"获取信息%@==%@==%@",self.firstResult,self.secondResult,self.thirdResult);
    if ([NSString isBlankString:self.firstResult] && self.firstData.count != 0) {
        self.firstResult = self.firstData[0];
        self.firstSelect = @"0";
    }
    if ([NSString isBlankString:self.secondResult] && self.secondData.count != 0) {
        self.secondResult = self.secondData[0];
        self.secondSelect = @"0";
    }
    if ([NSString isBlankString:self.thirdResult] && self.thirdData.count != 0) {
        self.thirdResult = self.thirdData[0];
        self.thirdSelect = @"0";
    }
    if (self.confirmBlock) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",self.firstResult,self.secondResult,self.thirdResult];
        
        NSString *minutes = [self.secondResult stringByReplacingOccurrencesOfString:@"点" withString:@""];
        NSString *second = [self.thirdResult stringByReplacingOccurrencesOfString:@"分" withString:@""];
        
        NSString *timeStr = [NSDate TimeformatFromDateWithDay:[self.firstSelect integerValue] AndMinutes:[minutes integerValue] AndSecond:[second integerValue]];
        self.confirmBlock(str,timeStr);
    }
    
    [self closeDatePickerView];
}
#pragma mark 创建父视图
- (void)createViewParentView{
    
    self.parentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight + parentViewHeight, ScreenWidth, parentViewHeight)];
    self.parentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.parentView];
    
    self.parentView.layer.shouldRasterize = YES;
    self.parentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.parentView.userInteractionEnabled = YES;

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
    UIWindow* window = [self getLastWindow];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         CGFloat height = ScreenHeight + parentViewHeight;
                         self.parentView.frame = CGRectMake(0, ScreenHeight - parentViewHeight, ScreenWidth, parentViewHeight);
                     }
                     completion:NULL
     ];
}
#pragma mark get Window
- (UIWindow*)getLastWindow{
    
    NSArray* windows = [UIApplication sharedApplication].windows;
    for(UIWindow* window in [windows reverseObjectEnumerator]){
        if([window isKindOfClass:[UIWindow class]]&&CGRectEqualToRect(window.bounds, [[UIScreen mainScreen] bounds])){
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}
//init
- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight);
        UIView *view = [[UIView alloc] initWithFrame:self.frame];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDatePickerView)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
    }
    return self;
}
@end
