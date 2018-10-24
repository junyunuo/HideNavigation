//
//  LoadingView.m
//

#import "LoadingView.h"

@interface LoadingView ()

@property (nonatomic) NSInteger currentIndex;

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{

    //加载动画
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.backgroundColor=[UIColor clearColor];
    activityView.frame=CGRectMake(0,0, 20, 20);
    
    activityView.center = self.center;
    
    [activityView startAnimating];
    
    [self addSubview:activityView];

}

@end
