//
//  BaseWebViewController.m
//  MahjongServiceApp
//
//  Created by guoqiang on 16/9/19.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIWebView* webView;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * image;
@property(nonatomic,strong)NSString * shareUrl;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self cleanCacheAndCookie];
    [self initWebView];
    

    if([self.title isEqualToString:@"更多"]){
        
        [self.rightButton setImage:[UIImage imageNamed:@"更多分享"] forState:0];
         self.rightButton.frame =CGRectMake(80,0,44,44);
        //self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        //[self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0,40,0,-35)];
        
        [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0,30,0,-10)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    }
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


- (void)backAction{
    if ([[self.webView.request.URL absoluteString] isEqualToString:self.url]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)initWebView{
    
    
    UIWebView* webView = [[UIWebView alloc]init];
    webView.frame = CGRectMake(0,0, kMainScreenOfWidth, kMainScreenOfHeight-64);
    [self.view addSubview:webView];
    self.webView=webView;
    self.webView.delegate = self;
    webView.scrollView.bounces = NO;
    self.webView.scrollView.delegate=self;
    
    
    [self loadExamplePage];
}

#pragma mark 给WebView 赋值Url
- (void)loadExamplePage{
    if (![CheckNetWork isConnectionState]){
        
        self.noNetworkView.hidden = NO;
        self.webView.hidden = YES;
        [self.noNetworkView noNetwork];
        return;
    }else{
        self.noNetworkView.hidden = YES;
        self.webView.hidden = NO;
    }
    
    
    [self showCustomProgressView];
    
    
    //self.url = @"http://jifen.startfly.cn/wap/about.html";
//self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideCustomProgressView];
    
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
