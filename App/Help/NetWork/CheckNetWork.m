//
//  CheckNetWork.m
//  arc_peiwowan
//
//  Created by MacBook on 11/20/14.
//  Copyright (c) 2014 MacBook. All rights reserved.
//

#import "CheckNetWork.h"
#import "Reachability.h"

@implementation CheckNetWork

//判断网络连接
+ (BOOL)isConnectionState
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach =  [Reachability reachabilityForInternetConnection];
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
        {
            isExistenceNetwork = NO;
        }
            
            break;
        case ReachableViaWiFi:
        {
            isExistenceNetwork = YES;
        }
            
            break;
        case ReachableViaWWAN:
        {
            isExistenceNetwork = YES;
        }
            break;
    }
    
    return isExistenceNetwork;
}


@end
