//
//  ApiConfig.h
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#ifndef ApiConfig_h
#define ApiConfig_h


//----------------当前系统版本----------------------
#define MaxSystemVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//-----------当前版本的Build ------------------
#define MaxSystemBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define BASE_URL @""

#define getQiNiuTokenApi @""

#endif /* ApiConfig_h */

