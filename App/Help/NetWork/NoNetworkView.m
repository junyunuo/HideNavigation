//
//  NoDataView.m


#import "NoNetworkView.h"
#import "UIViewController+Helper.h"
#import "UIColor+DSColor.h"
#import "LoadingView.h"

@interface NoNetworkView()

@property(nonatomic,strong)UIActivityIndicatorView* activityView;


@end

@implementation NoNetworkView

-(id)initWithFrame:(CGRect)frame complete:(NoNetWorkBlock)comblock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _noNetWorkBlock = comblock;
        self.userInteractionEnabled = YES;

        self.backgroundColor=[UIColor colorWithHexRGB:@"f7f7f7"];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithHexRGB:@"f7f7f7"];
        self.userInteractionEnabled = YES;
        
      
        
    }
    return self;

}


- (void)initLoadingView{

    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }

    LoadingView* loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 100, 143, 80)];
   // loadingView.centerX = self.gq_centerX;
    loadingView.gq_centerX =self.gq_centerX;
    loadingView.gq_top = kMainScreenOfHeight/2 - 80/2 - 64 - 20;
    
    [self addSubview:loadingView];
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120, loadingView.gq_bottom+10, 240, 20)];
    [label setFont:[UIFont systemFontOfSize:15]];
    label.textColor=[UIColor colorWithHexRGB:@"8c8c8c"];
    label.text=@"加载中...";
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
    
}


//没有网络
-(void)noNetwork
{
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-135/2, self.frame.size.height/2-124/2-44, 135, 124)];
    imageView.image = [UIImage imageNamed:@"netWorkFail.png"];
    [self addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width/2-80/2, imageView.frame.origin.y+imageView.frame.size.height+10, 80, 34) ;
    [button setBackgroundImage:[UIImage imageNamed:@"reloadNet.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}


//请求数据失败
-(void)getDataFail
{
    
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-180/2, self.frame.size.height/2-40/2-44, 180, 40)];
    failLabel.text = @"加载数据失败!";
    failLabel.font = [UIFont systemFontOfSize:17.0];
    failLabel.textColor = [UIColor grayColor];
    failLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:failLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width/2-80/2, failLabel.frame.origin.y+failLabel.frame.size.height+10, 80, 34) ;
    [button setBackgroundImage:[UIImage imageNamed:@"reloadNet.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}


//请求数据失败
-(void)getDataFail:(NSString *)failStr
{
    
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-180/2, self.frame.size.height/2-40/2-44, 180, 40)];
    failLabel.text = failStr;
    failLabel.font = [UIFont systemFontOfSize:17.0];
    failLabel.textColor = [UIColor grayColor];
    failLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:failLabel];

}

//缺省界面
-(void)showErrorMessage:(NSString*)message orImage:(NSString*)imageName{
    
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenOfWidth/2-100/2, 80, 100,100)];
    imageView.gq_centerY = self.gq_centerY - 60;
    imageView.image=[UIImage imageNamed:imageName];
    [self addSubview:imageView];
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120,imageView.gq_bottom + 20, 240, 20)];
    [label setFont:[UIFont systemFontOfSize:15]];
    label.textColor=[UIColor colorWithHexRGB:@"8c8c8c"];
    label.text=message;
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
    
}


- (void)showLoadingView{

    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.backgroundColor=[UIColor clearColor];
    activityView.frame=CGRectMake(0,kMainScreenOfHeight/2 - 80, 20, 20);
   // activityView.center = self.center;
    activityView.gq_centerX = self.gq_centerX;
    [self addSubview:activityView];
    [activityView startAnimating];
}
#pragma mark 隐藏 并且移除视图
- (void)hideNoNetWorkView{
    self.hidden = true;
    for(UIView* view in self.subviews){
        [view removeFromSuperview];
    }
}

//显示无数据
-(void)showErrorMessage:(NSString*)message
{
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenOfWidth/2-100/2, 80, 100,100)];
    imageView.image=[UIImage imageNamed:@"无数据.png"];
    [self addSubview:imageView];
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120,imageView.gq_bottom + 20, 240, 20)];
    [label setFont:[UIFont systemFontOfSize:15]];
    label.textColor=[UIColor colorWithHexRGB:@"8c8c8c"];
    label.text=message;
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
}


//获取数据为空
-(void)getNoneData
{
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
//    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenOfWidth/2-79/2, 80, 79,68)];
//    imageView.image=[UIImage imageNamed:@"暂无数据.png"];
//    [self addSubview:imageView];
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120,kMainScreenOfHeight/2-60, 240, 20)];
    [label setFont:[UIFont systemFontOfSize:15]];
    label.textColor=[UIColor colorWithHexRGB:@"8c8c8c"];
    label.text=@"暂无数据!";
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
}


//获取数据为空
-(void)getNoneUserData
{
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-150/2, self.frame.size.height/2-60/2-54, 150, 60)];
    failLabel.text = @"亲，暂无您的个人信息";
    failLabel.textColor = [UIColor grayColor];
    failLabel.font = [UIFont systemFontOfSize:15.0];
    failLabel.textAlignment = NSTextAlignmentCenter;
    failLabel.numberOfLines = 2;
    failLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:failLabel];
}


#pragma mark 无抢单数据
- (void)getNoneOrderData:(BOOL)isShowTitle{

    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenOfWidth/2-114.5/2, 80, 114.5, 152.5)];
    imageView.image=[UIImage imageNamed:@"NoneOrder.png"];
    [self addSubview:imageView];
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120, imageView.gq_bottom+10, 240, 20)];
    [label setFont:[UIFont systemFontOfSize:15]];
    label.textColor=[UIColor colorWithHexRGB:@"8c8c8c"];
    label.text=@"您还没有订单哦";
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
    
    if(isShowTitle){
        
        UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-120, label.gq_bottom+30, 240, 28)];
        [label2 setFont:[UIFont systemFontOfSize:13]];
        label2.layer.cornerRadius = 4;
        label2.layer.masksToBounds = true;
        label2.textColor=[UIColor whiteColor];
        label2.backgroundColor = [UIColor colorWithHexRGB:@"8c8c8c"];
        label2.text=@"开启抢单模式后可能会有订单消息哦";
        label2.textAlignment=NSTextAlignmentCenter;
        //[self addSubview:label2];
    }
}


































-(void)buttonClick:(UIButton *)btn
{
    if(self.noNetWorkBlock){
        self.noNetWorkBlock(true);
    }
}


@end
