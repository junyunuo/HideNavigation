//
//  WXLoginShare.m
//  NinthStreet
//
//  Created by zhucheng on 16/3/24.
//  Copyright © 2016年 CherryPocketTec. All rights reserved.
//

#import "WXLoginShare.h"

@implementation WXLoginShare

@synthesize delegate = _delegate;

+ (WXLoginShare *)shareInstance {
    static WXLoginShare *LoginShare = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        LoginShare = [[self alloc] init];
    });
    return LoginShare;
}
/**
 *  注册ID
 */
- (void)WXLoginShareRegisterApp{
    [WXApi registerApp:WXKey];
}

/**
 *  微信登录
 */
- (void)WXLogin{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"WXLoginViewController";
    [WXApi sendReq:req];
}


-(BOOL)isWXInstalled
{
    return [WXApi isWXAppInstalled];
}

/**
 *  微信文字分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendMessageToWX:(int)scene{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = @"测试数据";
    req.bText = YES;
    req.scene = scene;
    [WXApi sendReq:req];
}
/**
 *  微信图片分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendImageToWX:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    WXImageObject *imageobject = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
    imageobject.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
/**
 *  微信音乐分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendMusicToWX:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这事一首音乐";
    message.description = @"好听吗?";
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    
    WXMusicObject *musicobject = [WXMusicObject object];
    musicobject.musicUrl = @"http://tsmusic24.tc.qq.com/102396.mp3";
    musicobject.musicLowBandUrl = musicobject.musicUrl;
    musicobject.musicDataUrl = @"http://tsmusic24.tc.qq.com/102396.mp3";
    musicobject.musicLowBandDataUrl = musicobject.musicDataUrl;
    message.mediaObject = musicobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

/**
 *  微信视频分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendVideoToWX:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这事一段视频";
    message.description = @"好看吗?";
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    
    WXVideoObject *videoobject = [WXVideoObject object];
    videoobject.videoUrl = @"http://www.iqiyi.com/v_19rrok5lvc.html";
    videoobject.videoLowBandUrl = videoobject.videoUrl;
    message.mediaObject = videoobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

/**
 *  微信网页分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendWebToWX:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这事一个网页";
    message.description = @"好看吗?";
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    
    WXWebpageObject *videoobject = [WXWebpageObject object];
    videoobject.webpageUrl = @"http://www.hao123.com";
    message.mediaObject = videoobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}


/**
 *  微信网页分享
 *
 *  @param scene WXSceneSession:微信聊天  WXSceneTimeline:朋友圈  WXSceneFavorite:收藏
 */
- (void)WXSendWebToWX:(int)scene title:(NSString*)nssTitle description:(NSString*)nssDesc image:(UIImage*)img url:(NSString*)nssUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = nssTitle;
    message.description = nssDesc;
    [message setThumbImage:img];
    
    WXWebpageObject *videoobject = [WXWebpageObject object];
    videoobject.webpageUrl = nssUrl;
    message.mediaObject = videoobject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq*)req
{
    
}

-(void)onResp:(BaseResp*)resp
{
    // 微信登录
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == 0) {
            SendAuthResp *aresp = (SendAuthResp *)resp;
            [self getAccessTokenWithCode:aresp.code];//注销掉，不再通过客户端获取信息，直接让服务端解析
            
            if (_delegate && [_delegate respondsToSelector:@selector(WXLoginAuthSuccess:)]) {
                [_delegate WXLoginAuthSuccess:aresp.code];
            }
            return;
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(WXLoginAuthFailed)]) {
                [_delegate WXLoginAuthFailed];
            }
            
            return;
        }
    }
    else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {// 微信分享/收藏
        SendMessageToWXResp *aresp = (SendMessageToWXResp *)resp;
        NSLog(@"county = %@",aresp.country);
        NSLog(@"lang = %@",aresp.lang);
        if (aresp.errCode == WXSuccess) {
            //分享成功
            if (_delegate && [_delegate respondsToSelector:@selector(WXShareSucceed)]) {
                [_delegate WXShareSucceed];
            }
        }
        else
        {
            //分享失败
            if (_delegate && [_delegate respondsToSelector:@selector(WXShareFailed)]) {
                [_delegate WXShareFailed];
            }
        }
    }else if([resp isKindOfClass:[PayResp class]]){//微信支付
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if (_delegate && [_delegate respondsToSelector:@selector(WXPaySuccessed)]) {
                    [_delegate WXPaySuccessed];
                }
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                if (_delegate && [_delegate respondsToSelector:@selector(WXPayFailed:)]) {
                    [_delegate WXPayFailed:resp.errStr];
                }
                break;
        }
    }

}
/**
 *  获取access_token
 *
 *  @param code code description
 */
- (void)getAccessTokenWithCode:(NSString *)code
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXKey,WXSecret,code];
    NSLog(@"urlString = %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dict = %@",dict);
                if ([dict objectForKey:@"errcode"])
                {
                    // 授权失败(用户取消/拒绝)
                    if (_delegate && [self.delegate respondsToSelector:@selector(WXLoginShareLoginFail:)]) {
                        [self.delegate WXLoginShareLoginFail:dict];
                    }
                }else{
                    self.kWeiXinRefreshToken = [dict objectForKey:@"access_token"];
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
}
/**
 *  获取用户信息
 *
 *  @param accessToken access_token
 *  @param openId      openId description
 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSLog(@"urlString = %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString * dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dict = %@",dict);
                if ([dict objectForKey:@"errcode"])
                {
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:self.kWeiXinRefreshToken]];
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(WXLoginShareLoginSuccess:)]) {
                        [_delegate WXLoginShareLoginSuccess:dict];
                    }
                }
            }
        });
    });
}
/**
 *  刷新access_token
 *
 *  @param refreshToken refreshToken description
 */
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",@"wx29c1153063de230b",refreshToken];
    NSLog(@"urlString = %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else{
                    //重新使用AccessToken获取信息
                }
            }
        });
    });
    
}

@end
