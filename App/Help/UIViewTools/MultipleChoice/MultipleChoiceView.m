//
//  MultipleChoiceView.m
//  TaxiAppPassenger
//
//  Created by 花落永恒 on 16/12/17.
//  Copyright © 2016年 guoqiang. All rights reserved.
//

#import "MultipleChoiceView.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define parentViewHeight 300
#define toolbarHeight 44
#define Alpha 0.8

@interface MultipleChoiceView ()

@property (nonatomic,retain) UIToolbar *actionToolbar;

@end

@implementation MultipleChoiceView

- (JCTagListView *)tagListView{
    
    if(!_tagListView){
        _tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, parentViewHeight - toolbarHeight)];
        _tagListView.canSelectTags = YES;
        _tagListView.tagSelectedBackgroundColor = [UIColor colorForMainColor];
    }
    return _tagListView;
}
#pragma mark showView
- (void)showTaglistView{
    [self createViewParentView];
    [self createSubView];
}
#define mark closeView
- (void)closeTaglistView{
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
    
    self.tagListView.tags = self.taglistArray;
    self.actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, toolbarHeight)];
    [self.actionToolbar sizeToFit];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeTaglistView)];
    [cancelButton setTintColor:[UIColor colorForMainColor]];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneClicked:)];
    [doneBtn setTintColor:[UIColor colorForMainColor]];
    
    [self.actionToolbar setItems:[NSArray arrayWithObjects:cancelButton,flexSpace,doneBtn, nil] animated:YES];
    //初始化数据
    [self.parentView addSubview:self.tagListView];
    [self.parentView addSubview:self.actionToolbar];
}
- (void)pickerDoneClicked:(UIButton *)button{
    if (self.confirmBlock) {
        self.confirmBlock(self.tagListView.selectedTags,self.tagListView.selecIndexArray);
    }
    [self closeTaglistView];
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTaglistView)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        self.taglistArray = [NSMutableArray array];
    }
    return self;
}


@end
