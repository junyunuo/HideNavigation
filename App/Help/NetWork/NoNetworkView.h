//
//  NoDataView.h
//
#import <UIKit/UIKit.h>

typedef void (^ NoNetWorkBlock)(BOOL isReload);

@interface NoNetworkView : UIView

@property (nonatomic,copy) NoNetWorkBlock noNetWorkBlock;

- (void)initLoadingView;

-(void)noNetwork;
-(void)getDataFail;
-(void)getNoneData;
-(void)getNoneUserData;
-(void)getDataFail:(NSString *)failStr;

-(id)initWithFrame:(CGRect)frame complete:(NoNetWorkBlock)comblock;
-(id)initWithFrame:(CGRect)frame;

- (void)getNoneOrderData:(BOOL)isShowTitle;

-(void)showErrorMessage:(NSString*)message;

-(void)showErrorMessage:(NSString*)message orImage:(NSString*)imageName;

- (void)showLoadingView;

- (void)hideNoNetWorkView;

@end
