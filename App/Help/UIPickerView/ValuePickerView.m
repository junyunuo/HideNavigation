//
//  ValuePickerView.m
//  CustomPickerViewDemol
//
//  Created by QianZhang on 16/9/5.
//  Copyright © 2016年 . All rights reserved.
//

#import "ValuePickerView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define HEIGHT_OF_POPBOX (([UIScreen mainScreen].bounds.size.width == 414)?290:280)
#define HEIGHT_PICKER HEIGHT_OF_POPBOX - 160 + self.dataSource.count * 20

#define COLOR_BACKGROUD_GRAY [UIColor colorForMainColor]



@interface ValuePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic ,strong) UIView * bottomView;       //底层视图
@property (nonatomic ,strong) UIPickerView * statePicker;//运营状态轱辘
@property (nonatomic ,strong) UIView * controllerToolBar;//控制工具栏
@property (nonatomic ,strong) UIButton * finishBtn;      //取消按钮
@property (nonatomic ,strong) UIButton * cancelBtn;      //取消按钮
@property (nonatomic ,strong) UILabel * titleLabel;      //标题
@property (nonatomic ,strong) NSString * stateStr;       //选中的运营状态
@property (nonatomic ,strong) NSString * stateStr1;       //选中的运营状态1
@property (nonatomic, assign) NSInteger pickerHeight;    //弹层的高度

@property (nonatomic, strong) NSMutableArray *secondArr;

@end

@implementation ValuePickerView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.userInteractionEnabled = YES;
        [self addSubview:self.maskView];
        self.pickerHeight = HEIGHT_OF_POPBOX - 160;
        //初始化子视图
        self.secondArr = [NSMutableArray array];
        [self initSubViews];
    }
    return self;
}

/**初始化子视图*/
- (void)initSubViews
{
    //初始化轱辘的位置
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    
    //选择器
    self.statePicker = [[UIPickerView alloc] init];
    self.statePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.statePicker.backgroundColor = [UIColor whiteColor];
    self.statePicker.showsSelectionIndicator = YES;
    self.statePicker.dataSource = self;
    self.statePicker.delegate = self;
    [self.bottomView addSubview:self.statePicker];
    
    //控制栏
    self.controllerToolBar = [[UIView alloc] init];
    self.controllerToolBar.backgroundColor = [UIColor mainColor];
    [self.bottomView addSubview:_controllerToolBar];
    
    //完成按钮
    self.finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.finishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.controllerToolBar addSubview:self.finishBtn];
    
    //取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.cancelBtn addTarget:self action:@selector(canceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.controllerToolBar addSubview:_cancelBtn];
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.pickerTitle;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.controllerToolBar addSubview:self.titleLabel];
}

- (void)layoutSelfSubviews
{
    //底层视图
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.pickerHeight);
    
    //选择器
    self.statePicker.frame = CGRectMake(30, 40, SCREEN_WIDTH - 60, self.pickerHeight - 40);
    
    //控制栏
    self.controllerToolBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    
    //完成按钮
    self.finishBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 5, 70, 30);
    
    //取消按钮
    self.cancelBtn.frame = CGRectMake(0, 5, 70, 30);
    
    //标题
    self.titleLabel.frame = CGRectMake(70, 5, SCREEN_WIDTH - 140, 30);
}

#pragma mark - set相关

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    if (dataSource.count > 1) {
        self.secondArr = dataSource[1];
    }
    //设置弹层高度
    if (HEIGHT_PICKER > HEIGHT_OF_POPBOX - 24) {
        self.pickerHeight = HEIGHT_OF_POPBOX - 24;
    } else {
        self.pickerHeight = HEIGHT_PICKER;
    }
    
    //设置返回默认值
    self.stateStr = @"0";
//    [NSString stringWithFormat:@"%@/%@",_dataSource[0],@(1)];
    
    //刷新布局
    [self layoutSelfSubviews];
    [self.statePicker setNeedsLayout];
    
    //刷新轱辘数据
    [self.statePicker reloadAllComponents];
    [self.statePicker selectRow:0 inComponent:0 animated:NO];
}

- (void)setDefaultStr:(NSString *)defaultStr
{
    _defaultStr = defaultStr;
    
    self.stateStr = defaultStr;
    NSArray * selectArr = [defaultStr componentsSeparatedByString:@"/"];
    [self.statePicker selectRow:[selectArr[1] integerValue] - 1 inComponent:0 animated:NO];
}

- (void)setPickerTitle:(NSString *)pickerTitle
{
    _pickerTitle = pickerTitle;
    self.titleLabel.text = pickerTitle;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type) {
        if ([self.type integerValue] == 1) {
            return self.dataSource.count;
        }
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.type) {
        if ([self.type integerValue] == 1) {
//            if (component == 1) {
//                return self.secondArr.count;
//            }
            return [self.dataSource[component] count];
        }
    }
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.type) {
        if ([self.type integerValue] == 1) {
            return self.dataSource[component][row];
//            if (component == 0) {
////                [self getAge:row];
//                return self.dataSource[component][row];
//            }else{
//                return self.secondArr[row];
//            }
        }
    }
    return self.dataSource[row];
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.stateStr = [NSString stringWithFormat:@"%ld",(long)row];
    }else{
        self.stateStr1 = [NSString stringWithFormat:@"%ld",(long)row];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    [self changeSpearatorLineColor:pickerView];
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = NO;
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
       // [pickerLabel setFont:ZFontOf17];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
    
    
}
#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor:(UIPickerView *)picker
{
    for(UIView *speartorView in picker.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor colorWithHexRGB:@"EEEEEE"];//隐藏分割线
        }
    }
}

#pragma mark - 按钮相关

/**点击完成按钮*/
- (void)finishBtnClicked:(UIButton *)button
{
    if (self.type) {
        NSLog(@"%@%@",self.stateStr,self.stateStr1);
        
        if ([self.stateStr1 integerValue] == 0 || [self.stateStr integerValue] == 0) {
            self.valueBothDidSelect(self.stateStr,self.stateStr1);
        }else{
            if ([self.stateStr integerValue] <= [self.stateStr1 integerValue]) {
                self.valueBothDidSelect(self.stateStr,self.stateStr1);
            }else{
                [self.superview makeToast:@"请选择正确的年龄区间"];
                return;
            }
        }
    }else{
        self.valueDidSelect(self.stateStr);
    }
    
    [self removeSelfFromSupView];
}

/**点击取消按钮*/
- (void)canceBtnClicked:(UIButton *)button
{
    [self removeSelfFromSupView];
}

/**点击背景释放界面*/
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeSelfFromSupView];
}

#pragma mark - 显示弹层相关

/**弹出视图*/
- (void)show
{
//    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    [[self getLastWindow] addSubview:self];
    //动画出现
    CGRect frame = self.bottomView.frame;
    if (frame.origin.y == SCREEN_HEIGHT) {
        frame.origin.y -= self.pickerHeight;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.frame = frame;
        }];
    }
}

- (UIWindow*)getLastWindow{
    NSArray* windows = [UIApplication sharedApplication].windows;
    for(UIWindow* window in [windows reverseObjectEnumerator]){
        if([window isKindOfClass:[UIWindow class]]&&CGRectEqualToRect(window.bounds, [[UIScreen mainScreen] bounds])){
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

/**移除视图*/
- (void)removeSelfFromSupView
{
    CGRect selfFrame = self.bottomView.frame;
    if (selfFrame.origin.y == SCREEN_HEIGHT - self.pickerHeight) {
        selfFrame.origin.y += self.pickerHeight;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.frame = selfFrame;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
//增加计算年龄
//- (void)getAge:(NSInteger)row{
//    NSMutableArray *arr1 = [NSMutableArray array];
//    
//    NSArray *arr = self.dataSource[0];
//    for (NSInteger i = [arr[row] integerValue] + 1; i < 61; i++) {
//        [arr1 addObject:[NSString stringWithFormat:@"%ld",i]];
//    }
//    self.secondArr = arr1;
//    [self.statePicker reloadComponent:1];
//}


@end
