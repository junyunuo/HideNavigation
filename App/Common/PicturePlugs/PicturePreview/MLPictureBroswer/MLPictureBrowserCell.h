//
//  MLPictureBrowserCell.h
//  InventoryTool
//


#import "MLBroadcastViewCell.h"

@class MLPicture;

@class MLPictureBrowserCell;
@protocol MLPictureBrowserCellDelegate <NSObject>

//点击了某个页面
- (void)didTapForMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

@optional
//自定义覆盖View
- (UIView*)customOverlayViewOfMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;
//自定义覆盖View的frame
- (CGRect)customOverlayViewFrameOfMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

@end

@interface MLPictureBrowserCell : MLBroadcastViewCell

/**
 *  判断是否 是通过url地址 加载图片 YES 说明是通过Url加载图片 false 说明是图片对象
 */
@property(nonatomic,assign)BOOL ifUrlLoadForPicture;

@property(nonatomic,strong) MLPicture *picture;
@property(nonatomic,weak) id<MLPictureBrowserCellDelegate> delegate;




@end
