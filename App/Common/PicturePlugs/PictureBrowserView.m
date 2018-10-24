//
//  CategoryTableViewCell.m
//  IPadApp
//
//  Created by 郭强 on 16/6/19.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "PictureBrowserView.h"
#import "MLPictureBrowserCell.h"
#import "MLBroadcastView.h"
#import "MLPicture.h"
#import "UIImage+Tint.h"
#import "UIImageView+WebCache.h"
#define kPadding 10.0f 
#define kIsShowStatusBar NO //是否显示状态栏
#define kShowAndDisappearAnimationDuration .35f

#define kDefaultCurrentDescriptionLabelTag 1910110101019
#define kDefaultCurrentIndexLabelTag 111
#define kDefaultDownloadTag 112

#define kBundleName @"MLPictureBroswer.bundle"
#define kSrcName(file) [kBundleName stringByAppendingPathComponent:file]

@interface PictureBrowserView()<UIScrollViewDelegate,MLBroadcastViewDataSource,MLBroadcastViewDelegate,MLPictureBrowserCellDelegate>

@property(nonatomic,strong)UIButton* closeCurrentViewBtn;
@property(nonatomic,strong) MLBroadcastView *mainView;
@property(nonatomic,strong) UIView *overlayView; //覆盖View
@end

@implementation PictureBrowserView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.backgroundColor =  [UIColor blackColor];
        [self addSubview:self.mainView];
        [self addSubview:self.overlayView];
        [self addSubview:self.closeCurrentViewBtn];
    }
    return self;
}

#pragma mark - 显示图片的视图
- (MLBroadcastView*)mainView
{
    if (!_mainView) {
        _mainView = [[MLBroadcastView alloc]init];
        _mainView.backgroundColor = [UIColor blackColor];
        _mainView.delegate = self;
        _mainView.dataSource = self;
        _mainView.padding = kPadding;
        _mainView.frame = self.frame;
        
        UILabel* currentDescriptionLabel=[[UILabel alloc] init];
        currentDescriptionLabel.userInteractionEnabled = NO;
        currentDescriptionLabel.textColor = [UIColor whiteColor];
        currentDescriptionLabel.tag= kDefaultCurrentDescriptionLabelTag;
        currentDescriptionLabel.font = [UIFont systemFontOfSize:14.0f];
        currentDescriptionLabel.contentMode = UIViewContentModeCenter;
        currentDescriptionLabel.numberOfLines=0;
        currentDescriptionLabel.layer.borderColor=[[UIColor blueColor] CGColor];
        [_mainView addSubview:currentDescriptionLabel];
        currentDescriptionLabel.text=@"";
        
        
    }
    return _mainView;
}

#pragma mark 图片底部的 覆盖视图 显示描述和图片数量
- (UIView*)overlayView
{
    if (!_overlayView) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {
            _overlayView = [self.delegate customOverlayViewOfMLPictureBrowser:self];
        }
        if (!_overlayView) {
            _overlayView = [[UIView alloc]init];
            _overlayView.userInteractionEnabled = YES;
            _overlayView.backgroundColor = [UIColor clearColor];
            _overlayView.frame = CGRectMake(0, self.gq_height-44,self.gq_width, 44);
            
            BOOL isCustomOverlay = NO;
            if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {
                _overlayView.frame = [self.delegate customOverlayViewFrameOfMLPictureBrowser:self];
                isCustomOverlay = YES;
            }
            
            
            UILabel *currentIndexLabel = [[UILabel alloc]init];
            currentIndexLabel.userInteractionEnabled = NO;
            currentIndexLabel.textColor = [UIColor whiteColor];
            currentIndexLabel.textAlignment = NSTextAlignmentRight;
            currentIndexLabel.font = [UIFont systemFontOfSize:14.0f];
            currentIndexLabel.tag = kDefaultCurrentIndexLabelTag;
            currentIndexLabel.backgroundColor = [UIColor clearColor];
            currentIndexLabel.contentMode = UIViewContentModeCenter;
            [_overlayView addSubview:currentIndexLabel];
            
            if (!isCustomOverlay) {
                
                self.closeCurrentViewBtn.frame=CGRectMake(kMainScreenOfWidth-64,10, 54,54);
                //显示图片数量 label坐标
                UILabel *currentIndexLabel = (UILabel *)[self.overlayView viewWithTag:kDefaultCurrentIndexLabelTag];
                currentIndexLabel.frame =CGRectMake(kMainScreenOfWidth-90,15, 80, 20);
            }
        }
    }
    return _overlayView;
}

#pragma mark 关闭按钮
-(UIButton*)closeCurrentViewBtn{
    if(!_closeCurrentViewBtn){
        _closeCurrentViewBtn=[[UIButton alloc] init];
        [_closeCurrentViewBtn setImage:[UIImage imageNamed:@"Preview_Close"] forState:0];
        [_closeCurrentViewBtn addTarget:self action:@selector(closeCurrentViewBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeCurrentViewBtn;
}

#pragma 点击关闭按钮 返回到上一个界面
-(void)closeCurrentViewBtnAction{
    [self disappear];
}
- (void)setPictures:(NSArray *)pictures
{
    if ([_pictures isEqual:pictures]) {
        return;
    }
    _pictures = pictures;
    //设置对应的元素的下标序号
    for (int i = 0; i<pictures.count; i++) {
        MLPicture *picture = pictures[i];
        picture.index = i;
    }
}



#pragma mark - 获取图片数据
- (void)showWithPictureURLs:(NSArray*)pictureURLs atIndex:(NSUInteger)index setDescription:(NSMutableArray *)descriptionArr
{
    NSMutableArray *pictures = [NSMutableArray arrayWithCapacity:pictureURLs.count];
    
    if(self.isUrlLoadForPicture){
        //通过Url
        for (int i = 0; i<pictureURLs.count; i++) {
            MLPicture *picture = [[MLPicture alloc] init];
            
            if(self.isLocalUrl){
                //本地图片路径
                if ([pictureURLs[i] isKindOfClass:[NSString class]]){
                    picture.url = [NSURL fileURLWithPath:pictureURLs[i]];
                }
            }else{
                if ([pictureURLs[i] isKindOfClass:[NSString class]]){
                    picture.url = [NSURL URLWithString:pictureURLs[i]];
                    
                }else if ([pictureURLs[i] isKindOfClass:[NSURL class]]) {
                    picture.url = pictureURLs[i];
                }else{
                    NSAssert(NO, @"图片的URL类型异常");
                    return;
                }
            }
            [pictures addObject:picture];
        }
        
    }else{
        for (int i = 0; i<pictureURLs.count; i++) {
            MLPicture *picture = [[MLPicture alloc] init];
            picture.image=pictureURLs[i];
            [pictures addObject:picture];
        }
    }
    
    
    self.picturesDescriptionArray=descriptionArr;
    self.pictures = pictures;
    [self.mainView reloadData];
    [self.mainView scrollToPageIndex:index animated:NO];
    [self showWithAnimated:YES];
}

- (void)showWithAnimated:(BOOL)animated
{
    if (!self.pictures||self.pictures.count<=0) {
        NSLog(@"没有图片需要显示");
        return;
    }
    for (NSUInteger i=0; i<self.pictures.count; i++) {
        if (![self.pictures[i] isKindOfClass:[MLPicture class]]) {
            NSAssert(NO, @"传递的图片类型非MLPicture");
            return;
        }
    }
    
   // [[[[UIApplication sharedApplication].keyWindow subviews] lastObject] addSubview:self];

   [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
}

#pragma 让当前视图消失
- (void)disappear
{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
    [self.mainView scrollToPageIndex:index animated:animated];
}

#pragma mark - broadcast datasource
- (NSUInteger)cellCountOfBroadcastView:(MLBroadcastView *)broadcastView
{
    return self.pictures.count;
}

- (MLBroadcastViewCell *)broadcastView:(MLBroadcastView *)broadcastView cellAtPageIndex:(NSUInteger)pageIndex
{
    static NSString *CellIdentifier = @"BroadcastCell";
    MLPictureBrowserCell *cell = [broadcastView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MLPictureBrowserCell alloc]initWithReuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    cell.ifUrlLoadForPicture=self.isUrlLoadForPicture;
    cell.picture = self.pictures[pageIndex]; //设置对应的图像
    return cell;
}

#pragma mark - broadcast delegate  图片翻页时进入
- (void)didScrollToPageIndex:(NSUInteger)pageIndex ofBroadcastView:(MLBroadcastView *)broadcastView
{
    _currentIndex = pageIndex;
    
    if (!self.delegate||![self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]||![self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {

         UILabel *currentIndexLabel = (UILabel *)[self.overlayView viewWithTag:kDefaultCurrentIndexLabelTag];
    
        if (self.pictures.count>1) {
            currentIndexLabel.text = [NSString stringWithFormat:@"%lu/%lu",pageIndex+1,self.pictures.count];
        }else{
            currentIndexLabel.text = @"";
        }
        
        
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didScrollToIndex:ofMLPictureBrowser:)]) {
        [self.delegate didScrollToIndex:pageIndex ofMLPictureBrowser:self];
    }
}



#pragma mark 默认加载第一张图片
- (void)preOperateInBackgroundAtPageIndex:(NSUInteger)pageIndex ofBroadcastView:(MLBroadcastView *)broadcastView
{
    MLPicture *picture = (MLPicture*)self.pictures[pageIndex];
    if (picture.isLoaded) {
        return;
    }
    //加载
    UIImageView *tempImageView = [[UIImageView alloc]init];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:picture.url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
   
    
    if(self.isUrlLoadForPicture){
        //通过url 加载图片
        [tempImageView sd_setImageWithURL:picture.url placeholderImage:[UIImage imageNamed:@"DefaultPicture.png"] options:SDWebImageRetryFailed];
    }else{
        //直接赋值图片数据
        tempImageView.image=picture.image;
    }
}

#pragma mark - cell delegate  点击图片时<单击>
- (void)didTapForMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index
{
     [self disappear];
}

//自定义覆盖View
- (UIView*)customOverlayViewOfMLPictureCell:(MLPictureBrowserCell *)pictureCell ofIndex:(NSUInteger)index
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureCell:ofIndex:)]) {
        return [self.delegate customOverlayViewOfMLPictureCell:pictureCell ofIndex:index];
    }
    return nil;
}

//自定义覆盖View的frame
- (CGRect)customOverlayViewFrameOfMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureCell:ofIndex:)]) {
        return [self.delegate customOverlayViewFrameOfMLPictureCell:pictureCell ofIndex:index];
    }
    return CGRectZero;
    //测试数据
    //    return CGRectMake(0, 0, pictureCell.bounds.size.width, 50);
}

#pragma mark - rotate 这里限制住旋转，旋转在上面监控OBServer里有处理

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}




@end
