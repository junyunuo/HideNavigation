//
//  Toast+UIView.m
//  Toast
//  Version 2.0
//
//  Copyright 2013 Charles Scalesse.
//

#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
//#import "hqResouce.h"
#import "UIImage+GIF.h"

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastCornerRadius        = 6.0;
static const CGFloat CSToastOpacity             = 0.9;
static const CGFloat CSToastFontSize            = 14.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const CGFloat CSToastFadeDuration        = 0.2;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 2.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = NO;

// display duration and position
static const CGFloat CSToastDefaultDuration     = 1.5;
//static const NSString * CSToastDefaultPosition  = @"bottom";

static const NSString * CSToastDefaultPosition  = @"center";

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

// activity
static const CGFloat CSToastActivityWidth       = 100.0;
static const CGFloat CSToastActivityHeight      = 100.0;
static const NSString * CSToastActivityDefaultPosition = @"center";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";


@interface UIView (ToastPrivate)

- (CGPoint)centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;

@end


@implementation UIView (Toast)

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position {
    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [self showToast:toast duration:interval position:position];  
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:interval position:position];  
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:interval position:position];  
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:interval position:position];  
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point {
    toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;
    [self addSubview:toast];
    toast.tag = 2876;
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
}

-(void)hideToast
{
    UIView *toast = [self viewWithTag:2876];
    if (toast) {
        [toast removeFromSuperview];
    }
}

-(void)showNoNetworkingTipView
{
    UIView * toast = [self viewForMessage:@"当前网络不佳" title:nil image:nil];
    toast.center = [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
    toast.alpha = 1.0;
    [self addSubview:toast];
    toast.tag = 2888;
}

-(void)hideNoNetworkingTipView
{
    UIView *toast = [self viewWithTag:2888];
    if (toast) {
        [toast removeFromSuperview];
    }
}

#pragma mark - Toast Activity Methods

- (void)makeToastActivity {
    [self makeToastActivity:CSToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CSToastActivityWidth, CSToastActivityHeight)] autorelease];
    activityView.center = [self centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = CSToastShadowOpacity;
        activityView.layer.shadowRadius = CSToastShadowRadius;
        activityView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:CSToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Private Methods

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        // convert string literals @"top", @"bottom", @"center", or any point wrapped in an NSValue object into a CGPoint
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    NSLog(@"Warning: Invalid position for toast.");
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
}

- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[[UIView alloc] init] autorelease];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSToastShadowRadius;
        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:CSToastOpacity];
    
    if(image != nil) {
        imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, CSToastImageViewWidth, CSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        //titleLabel.textAlignment = NSTextAlignmentLeft;
        //titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeTitle = [title sizeWithFont:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode]; 
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[[UILabel alloc] init] autorelease];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        //messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeMessage = [message sizeWithFont:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode]; 
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));    
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
                         
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
        
    return wrapperView;
}

-(UIView *)createIndicatorViewWithTitle{
    CGRect rcScreeno=[UIApplication sharedApplication].keyWindow.frame;
    CGRect rcScreen =CGRectMake(0, 0, rcScreeno.size.width, rcScreeno.size.height-65);
    UIView *m_viewTip=[[UIView alloc]initWithFrame:rcScreen];
    m_viewTip.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    m_viewTip.tag=2900;
    m_viewTip.backgroundColor=[UIColor clearColor];
    UIView *bgView=[[UIView alloc]initWithFrame:rcScreen];
    bgView.backgroundColor=[UIColor lightGrayColor];
    bgView.alpha=0.6;
    [m_viewTip addSubview:bgView];
    [bgView release];

    UIView *contentBGView=[[UIView alloc] initWithFrame:CGRectMake(30, (rcScreen.size.height-257)/2.0, rcScreen.size.width-60, 257)];
    contentBGView.backgroundColor=[UIColor whiteColor];
    contentBGView.layer.cornerRadius=10;
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 36, rcScreen.size.width-100, 18)];
    titleLab.tag=100;
    titleLab.font=[UIFont systemFontOfSize:16];
    titleLab.textColor=[UIColor blackColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.text=@"";
    [contentBGView addSubview:titleLab];
    [titleLab release];
    
    UIImageView *classImageView=[[UIImageView alloc]initWithFrame:CGRectMake(contentBGView.frame.size.width/2.0-50, 87, 100, 100)];
    classImageView.tag=101;
    [contentBGView addSubview:classImageView];
    [classImageView release];
    
    UILabel *classNameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 213, rcScreen.size.width-100, 14)];
    classNameLab.tag=102;
    classNameLab.font=[UIFont systemFontOfSize:13];
    classNameLab.textColor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
    classNameLab.textAlignment=NSTextAlignmentCenter;
    classNameLab.text=@"";
    [contentBGView addSubview:classNameLab];
    [classNameLab release];
    
    UIActivityIndicatorView *activeInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activeInd setCenter:CGPointMake(contentBGView.frame.size.width/2.0, contentBGView.frame.size.height/2.0-20.0)];
    activeInd.tag=103;
    [contentBGView addSubview:activeInd];
    [activeInd release];
    
    [m_viewTip addSubview:contentBGView];
    [contentBGView release];
    return [m_viewTip autorelease];
}

-(UIView *)createIndicatorView{
    
    CGRect rcScreeno = [UIApplication sharedApplication].keyWindow.frame;
    //CGRect rcScreen = CGRectMake(0, 0, rcScreeno.size.width, rcScreeno.size.height-65);
    CGRect rcScreen = CGRectMake(0, 0, rcScreeno.size.width, rcScreeno.size.height);
    UIView *m_viewTip=[[UIView alloc]initWithFrame:rcScreen];
    m_viewTip.autoresizingMask = (UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleWidth);
    m_viewTip.tag=2901;
    m_viewTip.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
    
    UIImageView *launchAnimationView = [[UIImageView alloc] init];
    // 创建gifImage,传入Gif图片名即可
    UIImage *gifImage = [UIImage sd_animatedGIFNamed:@"loading"];
    launchAnimationView.image = gifImage;
    launchAnimationView.tag = 103;
    launchAnimationView.frame = CGRectMake(0, 0, gifImage.size.width, gifImage.size.height);
    launchAnimationView.center = CGPointMake(m_viewTip.frame.size.width/2.0, m_viewTip.frame.size.height/2.0);
    [m_viewTip addSubview:launchAnimationView];
    [launchAnimationView release];
    
    return [m_viewTip autorelease];
}

//Just with contents
-(UIView *)createIndicatorViewWithContents{
    CGRect rcScreeno=[UIApplication sharedApplication].keyWindow.frame;
    CGRect rcScreen =CGRectMake(0, 0, rcScreeno.size.width, rcScreeno.size.height-65);
    UIView *m_viewTip=[[UIView alloc]initWithFrame:rcScreen];
    m_viewTip.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    m_viewTip.tag=2901;
    m_viewTip.backgroundColor=[UIColor clearColor];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake((rcScreen.size.width-100.0)/2.0, (rcScreen.size.height-70.0)/2.0-32, 100, 70)];
    bgView.layer.cornerRadius=10.0;
    bgView.backgroundColor=[UIColor grayColor];
    bgView.alpha=0.6;
    [m_viewTip addSubview:bgView];
    [bgView release];
    
    UILabel *classNameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, rcScreen.size.width-100, 14)];
    classNameLab.tag=102;
    classNameLab.font=[UIFont systemFontOfSize:13];
    classNameLab.textColor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
    classNameLab.textAlignment=NSTextAlignmentCenter;
    classNameLab.text=@"";
    [m_viewTip addSubview:classNameLab];
    [classNameLab release];
    
    UIActivityIndicatorView *activeInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeInd setCenter:CGPointMake(rcScreen.size.width/2.0, (rcScreen.size.height-65)/2.0)];
    activeInd.tag=103;
    [m_viewTip addSubview:activeInd];
    [activeInd release];
    return [m_viewTip autorelease];
}



-(void)showIndicatorViewWithTitle:(NSString *)title content:(NSString *)content image:(UIImage *)image{
    UIView *m_viewTip=(UIView *)[self viewWithTag:2900];
    if (!m_viewTip) {
        m_viewTip=[self createIndicatorViewWithTitle];
    }
    if (title) {
        UILabel *labTitle=(UILabel *)[m_viewTip viewWithTag:100];
        labTitle.text=title;
    }
    if (content) {
        UILabel *labContent=(UILabel *)[m_viewTip viewWithTag:102];
        labContent.text=title;
    }
    if (image) {
        UIImageView *imageVInd=(UIImageView *)[m_viewTip viewWithTag:101];
        imageVInd.image=image;
    }
    UIActivityIndicatorView *active=(UIActivityIndicatorView *)[m_viewTip viewWithTag:103];
    [active startAnimating];
//    [[UIApplication sharedApplication].keyWindow addSubview:m_viewTip];
    [self addSubview:m_viewTip];
}

-(void)showIndicatorView{
    UIView *m_viewTip=(UIView *)[self viewWithTag:2901];
    if (!m_viewTip) {
        m_viewTip=[self createIndicatorView];
    }

    [self addSubview:m_viewTip];
}

-(void)showIndicatorViewWithContents:(NSString *)content{
    UIView *m_viewTip=(UIView *)[self viewWithTag:2901];
    if (!m_viewTip) {
        m_viewTip=[self createIndicatorViewWithContents];
    }
    UILabel *labContent=(UILabel *)[m_viewTip viewWithTag:102];
    labContent.text=content;
    UIActivityIndicatorView *active=(UIActivityIndicatorView *)[m_viewTip viewWithTag:103];
    [active startAnimating];
    [self addSubview:m_viewTip];
}


-(void)hideIndicatorView{
    UIView *m_viewTip=(UIView *)[self viewWithTag:2901];
    if (m_viewTip) {
        [m_viewTip removeFromSuperview];
    }
}

-(UIView *)createCoverView{
    CGRect rcScreeno=[UIApplication sharedApplication].keyWindow.frame;
    CGRect rcScreen =CGRectMake(0, 0, rcScreeno.size.width, rcScreeno.size.height-65);
    UIView * viewCover =[[UIView alloc]initWithFrame:rcScreen];
    viewCover.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    viewCover.tag=2902;
    viewCover.backgroundColor=[UIColor grayColor];
    viewCover.alpha=0.4;
    return viewCover;
}

-(void)showCoverView
{
    UIView * viewCover =(UIView *)[self viewWithTag:2902];
    if (!viewCover) {
        viewCover=[self createCoverView];
    }
    [self addSubview:viewCover];
}

-(void)hideCoverView
{
    UIView * viewCover =(UIView *)[self viewWithTag:2902];
    if (viewCover) {
        [viewCover removeFromSuperview];
    }
}

-(UIView *)creatBadNetworkView:(CGRect)viewFrame{

    UIView * BadNetworkView =[[UIView alloc]initWithFrame:viewFrame];
    BadNetworkView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    BadNetworkView.tag=2903;
    BadNetworkView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:245.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    UIImageView *logoView=[[UIImageView alloc] initWithFrame:CGRectMake((viewFrame.size.width-90)/2.0, (viewFrame.size.height-90)/2.0, 90, 90)];
    logoView.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    logoView.image=[UIImage imageNamed:@"badNetworkLogo.png"];
    logoView.hidden=YES;
    [BadNetworkView addSubview:logoView];
    [logoView release];
    
    UIButton *logoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame=CGRectMake((viewFrame.size.width-90)/2.0, (viewFrame.size.height-90)/2.0, viewFrame.size.width, 90);
    logoBtn.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    [logoBtn addTarget:self action:@selector(refreshButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [BadNetworkView addSubview:logoBtn];
    
    
    UIButton *refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"点击屏幕，重新加载" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    refreshBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    refreshBtn.frame=CGRectMake(0, 0, viewFrame.size.width, 30);
    refreshBtn.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    [refreshBtn addTarget:self action:@selector(refreshButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [BadNetworkView addSubview:refreshBtn];

    return [BadNetworkView autorelease];
}

-(void)refreshButtonPressed:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:BAD_NETWORK object:nil];
}

-(void)reLoginButtonPressed:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOT_LOGIN_STATE object:nil];
}

-(void)showBadNetworkView:(CGRect)viewFrame{
    UIView * badNetView =(UIView *)[self viewWithTag:2903];
    if (!badNetView) {
        badNetView=[self creatBadNetworkView:viewFrame];
    }
    [self addSubview:badNetView];
}

-(void)hideBadNetworkView{
    UIView * badNetView =(UIView *)[self viewWithTag:2903];
    if (badNetView) {
        [badNetView removeFromSuperview];
    }
}

-(void)showNotLoginNetworkView:(CGRect)viewFrame{
    UIView * badNetView =(UIView *)[self viewWithTag:2904];
    if (!badNetView) {
        badNetView=[self creatNotLoginNetworkView:viewFrame];
    }
    if (!badNetView.superview) {
        [self addSubview:badNetView];
    }
}

-(void)ShowNormalNotLoginNetworkView:(CGRect)viewFrame{
    UIView * badNetView =(UIView *)[self viewWithTag:2909];
    if (!badNetView) {
        badNetView=[self creatNormalNotLoginNetworkView:viewFrame];
    }
    if (!badNetView.superview) {
        [self addSubview:badNetView];
    }
}

-(void)hideNotLoginNetworkView{
    UIView * badNetView =(UIView *)[self viewWithTag:2904];
    if (badNetView) {
        [badNetView removeFromSuperview];
    }
}

-(UIView *)creatNotLoginNetworkView:(CGRect)viewFrame{
    UIView * BadNetworkView =[[UIView alloc]initWithFrame:viewFrame];
    BadNetworkView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    BadNetworkView.tag=2904;
    BadNetworkView.backgroundColor=[UIColor grayColor];
    
    UIImageView *logoView=[[UIImageView alloc] initWithFrame:CGRectMake((viewFrame.size.width-90)/2.0, (viewFrame.size.height-90)/2.0, 90, 90)];
    logoView.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    logoView.image=[UIImage imageNamed:@"badNetworkLogo.png"];
    logoView.hidden=YES;
    [BadNetworkView addSubview:logoView];
    [logoView release];
    
    UIButton *logoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame=CGRectMake((viewFrame.size.width-90)/2.0, (viewFrame.size.height-90)/2.0, viewFrame.size.width, 90);
    logoBtn.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    [logoBtn addTarget:self action:@selector(refreshButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [BadNetworkView addSubview:logoBtn];
    UIButton *refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"为你的健康买单,每天坚持一个好习惯\n                      快来登录吧"];
    NSRange strRange = [@"为你的健康买单,每天坚持一个好习惯\n                      快来登录吧" rangeOfString:@"登录"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:strRange];
    [refreshBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    refreshBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    refreshBtn.titleLabel.numberOfLines = 2;
    refreshBtn.frame=CGRectMake(20, 0, viewFrame.size.width-40, 40);
    refreshBtn.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    [refreshBtn addTarget:self action:@selector(reLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [BadNetworkView addSubview:refreshBtn];
    
    return [BadNetworkView autorelease];
}

-(UIView *)creatNormalNotLoginNetworkView:(CGRect)viewFrame{
    UIView * BadNetworkView =[[UIView alloc]initWithFrame:viewFrame];
    BadNetworkView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    BadNetworkView.tag=2909;
    BadNetworkView.backgroundColor=[UIColor grayColor];
    
    UIImageView *logoView=[[UIImageView alloc] initWithFrame:CGRectMake((viewFrame.size.width-90)/2.0, (viewFrame.size.height-90)/2.0, 90, 90)];
    logoView.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    logoView.image=[UIImage imageNamed:@"badNetworkLogo.png"];
    logoView.hidden=YES;
    [BadNetworkView addSubview:logoView];
    [logoView release];
    
    UIButton *logoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame=CGRectMake((viewFrame.size.width-90)/2.0, (viewFrame.size.height-90)/2.0, viewFrame.size.width, 90);
    logoBtn.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    [logoBtn addTarget:self action:@selector(refreshButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [BadNetworkView addSubview:logoBtn];
    UIButton *refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"尚未登录,请登录" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    refreshBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    refreshBtn.frame=CGRectMake(0, 0, viewFrame.size.width, 30);
    refreshBtn.center=CGPointMake(viewFrame.size.width/2.0, viewFrame.size.height/3.0);
    [refreshBtn addTarget:self action:@selector(reLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [BadNetworkView addSubview:refreshBtn];
    
    return [BadNetworkView autorelease];
}

-(void)hideNormalNotLoginNetworkView{
    UIView * badNetView =(UIView *)[self viewWithTag:2909];
    if (badNetView) {
        [badNetView removeFromSuperview];
    }
}

@end
