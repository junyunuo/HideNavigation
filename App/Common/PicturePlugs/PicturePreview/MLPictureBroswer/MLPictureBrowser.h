//
//  MLPictureBrowser.h
//  InventoryTool
//


#import <UIKit/UIKit.h>

@class MLPictureBrowser;
@class MLPictureBrowserCell;
@class MLBroadcastView;
@protocol MLPictureBrowserDelegate <NSObject>

@optional
//滚动到某一个页面
- (void)didScrollToIndex:(NSUInteger)index ofMLPictureBrowser:(MLPictureBrowser*)pictureBrowser;
- (void)didDisappearOfMLPictureBrowser:(MLPictureBrowser*)pictureBrowser;

@optional
//下面这俩自定义覆盖View是替换了页号的那个默认覆盖View，需要自行添加一些页号显示等其他元素
//自定义覆盖View,这俩是绑定的，只有俩都设置了才有效
- (UIView*)customOverlayViewOfMLPictureBrowser:(MLPictureBrowser*)pictureBrowser;
//自定义覆盖View的frame
- (CGRect)customOverlayViewFrameOfMLPictureBrowser:(MLPictureBrowser*)pictureBrowser;

@optional
//自定义Cell的覆盖View
- (UIView*)customOverlayViewOfMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;
//自定义Cell覆盖View的frame
- (CGRect)customOverlayViewFrameOfMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;


@end

@interface MLPictureBrowser : UIViewController

@property(nonatomic,readonly,getter=mainView) MLBroadcastView *broadcastView;

@property(nonatomic,weak) id<MLPictureBrowserDelegate> delegate;
@property(nonatomic,strong) NSArray *pictures;//要展示的图片列表,元素为MLPicture
@property(nonatomic,assign,readonly) NSUInteger currentIndex; //当前展示的索引位置
@property(nonatomic,strong)NSMutableArray* picturesDescriptionArray; //图片的描述

//通常情况下使用，通过URL数组和要显示的下标
- (void)showWithPictureURLs:(NSArray*)pictureURLs atIndex:(NSUInteger)index setDescription:(NSMutableArray*)descriptionArr;

//滚动到某一个页面
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 *  判断是否 是通过url地址 加载图片 YES 说明是通过Url加载图片 false 说明是直接加载UIImage图片对象
 */
@property(nonatomic,assign)BOOL ifUrlLoadForPicture;

@end
