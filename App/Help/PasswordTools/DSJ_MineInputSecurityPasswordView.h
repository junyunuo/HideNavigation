//
//  DSJ_MineInputSecurityPasswordView.h
//  GlobalTravel
//
//  Created by 李忠 on 2016/12/1.
//  Copyright © 2016年 YuJing. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^InputCompleteBlock)(NSString *password);

@interface DSJ_MineInputSecurityPasswordView : UIViewController

@property(nonatomic,strong)void (^inputCompleteBlock)(NSString *password);
@property(nonatomic,strong)void (^forgetPsdCompleteBlock)();//忘记密码

@property(nonatomic,strong)NSString* balance;

@end
