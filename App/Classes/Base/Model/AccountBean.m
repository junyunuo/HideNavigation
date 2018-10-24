//
//  MyCenterViewController.h
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "AccountBean.h"

@implementation AccountBean

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.mobile forKey:@"phone"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
 
    if (self = [super init]) {
        self.mobile = [aDecoder decodeObjectForKey:@"phone"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

@end
