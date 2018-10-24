//
//  MLPicture.h
//
//


#import <Foundation/Foundation.h>

@interface MLPicture : NSObject

@property(nonatomic,assign) NSUInteger index;//序号
@property(nonatomic,strong) NSURL *url; //图片的网络地址
@property(nonatomic,assign) BOOL isLoaded; //是否已经加载过
@property(nonatomic,strong)UIImage* image;//图片数据

@end
