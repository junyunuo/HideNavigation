//
//  MLPictureBrowser.m
//  InventoryTool
//


#import "MLPictureBrowser.h"
#import "MLPictureBrowserCell.h"
#import "MLBroadcastView.h"
#import "MLPicture.h"
#import "UIImage+Tint.h"
#import "UIImageView+WebCache.h"
//#import "NSString+Extension.h"
//#import "CurrentChatStatus.h"
#define kPadding 10.0f //图片与图片之间的黑色间隔/2,因为每个图片左右都有占位，所以实际间隔是kPadding*2
#define kIsShowStatusBar NO //是否显示状态栏
#define kShowAndDisappearAnimationDuration .35f

#define kDefaultCurrentDescriptionLabelTag 1910110101019
#define kDefaultCurrentIndexLabelTag 111
#define kDefaultDownloadTag 112

#define kBundleName @"MLPictureBroswer.bundle"
#define kSrcName(file) [kBundleName stringByAppendingPathComponent:file]

@interface MLPictureBrowser ()<UIScrollViewDelegate,MLBroadcastViewDataSource,MLBroadcastViewDelegate,MLPictureBrowserCellDelegate>

@property(nonatomic,strong)UIButton* closeCurrentViewBtn;
@property(nonatomic,strong) MLBroadcastView *mainView;
@property(nonatomic,strong) UIView *overlayView; //覆盖View

@property(nonatomic,strong) UIWindow *actionWindow;

@end

@implementation MLPictureBrowser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.closeCurrentViewBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self onDeviceOrientationChange]; //当时就处理下
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

//旋转 暂时禁止
-(void)onDeviceOrientationChange
{
    
    //return;
    
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    
//    CGRect screenBounds = [UIScreen mainScreen].bounds;
//#define kAnimationDuration 0.35f
//    if (UIDeviceOrientationIsLandscape(orientation)) {
//        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
//            self.view.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
//            self.view.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
//            [self.view setNeedsLayout];
//            [self.view layoutIfNeeded];
//        } completion:nil];
//    }else if (orientation==UIDeviceOrientationPortrait){
//        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
//            self.view.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
//            self.view.bounds = screenBounds;
//            [self.view setNeedsLayout];
//            [self.view layoutIfNeeded];
//        } completion:nil];
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _mainView.frame = self.view.bounds;
        
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
           
           
            //图片描述Label
            UILabel *currentIndexLabel = [[UILabel alloc]init];
            currentIndexLabel.userInteractionEnabled = NO;
            currentIndexLabel.textColor = [UIColor whiteColor];
            currentIndexLabel.textAlignment = NSTextAlignmentRight;
            currentIndexLabel.font = [UIFont systemFontOfSize:14.0f];
            currentIndexLabel.tag = kDefaultCurrentIndexLabelTag;
            currentIndexLabel.backgroundColor = [UIColor clearColor];
            currentIndexLabel.contentMode = UIViewContentModeCenter;
            [_overlayView addSubview:currentIndexLabel];
        }
    }
    return _overlayView;
}

#pragma mark 关闭按钮
-(UIButton*)closeCurrentViewBtn{
    if(!_closeCurrentViewBtn){
        _closeCurrentViewBtn=[[UIButton alloc] init];
        [_closeCurrentViewBtn setImage:[UIImage imageNamed:@"预览图片_关闭"] forState:0];
        [_closeCurrentViewBtn addTarget:self action:@selector(closeCurrentViewBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeCurrentViewBtn;
}

#pragma 点击关闭按钮 返回到上一个界面
-(void)closeCurrentViewBtnAction{
    //[self disappear];
        
    [self dismissViewControllerAnimated:NO completion:nil];

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
#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mainView.frame = self.view.bounds; //包裹完
    
    //overlayView 的frame
    CGRect overlayViewFrame = CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44);//默认覆盖View的frame
    BOOL isCustomOverlay = NO;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {
        overlayViewFrame = [self.delegate customOverlayViewFrameOfMLPictureBrowser:self];
        isCustomOverlay = YES;
    }
    self.overlayView.frame = overlayViewFrame;
    
    if (!isCustomOverlay) {
        
        self.closeCurrentViewBtn.frame=CGRectMake(kMainScreenOfWidth-64,10, 54,54);
        
        //显示图片数量 label坐标
        UILabel *currentIndexLabel = (UILabel *)[self.overlayView viewWithTag:kDefaultCurrentIndexLabelTag];
        currentIndexLabel.frame =CGRectMake(kMainScreenOfWidth-90,15, 80, 20);
       

        //显示图片描述坐标
        UILabel* currentDescriptionLabel=(UILabel*)[self.mainView viewWithTag:kDefaultCurrentDescriptionLabelTag];
        
        
        
//        CGFloat currentDescriptionLabelY=kMainScreenOfHeight-140;
//        
//        if(IPhone5){
//            currentDescriptionLabelY=kMainScreenOfHeight-180;
//        }else if(iPhone6){
//            currentDescriptionLabelY=kMainScreenOfHeight-210;
//        }else if(iPhone6Plus){
//           
//        }else if(iPhone6PlusZoom){
//            currentDescriptionLabelY=kMainScreenOfHeight-210;
//        }
        currentDescriptionLabel.frame=CGRectMake(10,self.mainView.gq_bottom-60,kMainScreenOfWidth-110,60);
    }
}

#pragma mark - 获取图片数据
- (void)showWithPictureURLs:(NSArray*)pictureURLs atIndex:(NSUInteger)index setDescription:(NSMutableArray *)descriptionArr
{
    NSMutableArray *pictures = [NSMutableArray arrayWithCapacity:pictureURLs.count];
    
    if(self.ifUrlLoadForPicture){
        //通过Url 
        for (int i = 0; i<pictureURLs.count; i++) {
            MLPicture *picture = [[MLPicture alloc] init];
            if ([pictureURLs[i] isKindOfClass:[NSString class]]) {
                picture.url = [NSURL URLWithString:pictureURLs[i]];
            }else if ([pictureURLs[i] isKindOfClass:[NSURL class]]) {
                picture.url = pictureURLs[i];
            }else{
                NSAssert(NO, @"图片的URL类型异常");
                return;
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
    
    
    //老方法 1.7.5 之前的版本 调用以下方法 1.7.5以后使用 presentViewController:self.mlPictureBrowse
    
//    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    window.opaque = YES;
//    UIWindowLevel level = UIWindowLevelStatusBar+10.0f;
//    if (kIsShowStatusBar) {
//        level = UIWindowLevelNormal+10.0f;
//    }
//    window.windowLevel = level;
//    window.rootViewController = self;
//   // window.backgroundColor = [UIColor blackColor];
//   // window.backgroundColor =[UIColor redColor];
//    [window makeKeyAndVisible];
//    self.actionWindow = window;
//    
//    if (animated) {
//        self.actionWindow.layer.opacity = .01f;
//        [UIView animateWithDuration:kShowAndDisappearAnimationDuration animations:^{
//            self.actionWindow.layer.opacity = 1.0f;
//        }];
//    }
}

#pragma 让当前视图消失
- (void)disappear
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [UIView animateWithDuration:kShowAndDisappearAnimationDuration animations:^{
        self.actionWindow.layer.opacity = .01f;
    } completion:^(BOOL finished) {
        [self.actionWindow removeFromSuperview];
        [self.actionWindow resignKeyWindow];
        self.actionWindow = nil;
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didDisappearOfMLPictureBrowser:)]) {
            [self.delegate didDisappearOfMLPictureBrowser:self];
        }
    }];
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
    cell.ifUrlLoadForPicture=self.ifUrlLoadForPicture;
    cell.picture = self.pictures[pageIndex]; //设置对应的图像
    return cell;
}

#pragma mark - broadcast delegate  图片翻页时进入
- (void)didScrollToPageIndex:(NSUInteger)pageIndex ofBroadcastView:(MLBroadcastView *)broadcastView
{
    _currentIndex = pageIndex;
    
    if (!self.delegate||![self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]||![self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {
        
        UILabel *currentIndexLabel = (UILabel *)[self.overlayView viewWithTag:kDefaultCurrentIndexLabelTag];
        
        
        UILabel* currentDescriptionLabel=(UILabel*)[self.mainView viewWithTag:kDefaultCurrentDescriptionLabelTag];
        if(self.picturesDescriptionArray.count>0){
            
          
            
            
            NSString* descr=[NSString stringWithFormat:@"%@",self.picturesDescriptionArray[pageIndex]];
            if([NSString isBlankString:descr]){
                descr=@"";
            }
            
           // descr=@"在哪里啊哈哈大小真的吗我不知道哦是吗恩恩好的哈哈哈哈哈哈哈哈在哪里啊哈哈大小真的吗我不知道哦是吗恩恩好的哈哈哈哈哈哈哈哈";
            
            
          //  CGSize size = [NSString getStringSize:descr andWidht:self.mainView.width-currentIndexLabel.width-20 andFont:14];
            
    
            
            
            
          //  currentDescriptionLabel.text=descr;
            
           
        }
        
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
    
    NSString* defineImageName=@"默认图";
    if(iPhone6Plus){
        defineImageName=@"默认图6p";
    }else if(iPhone6){
        defineImageName=@"默认图6";
    }else if(iPhone6PlusZoom){
        defineImageName=@"默认图6p";
    }
    
    if(self.ifUrlLoadForPicture){
        //通过url 加载图片
        [tempImageView sd_setImageWithURL:picture.url placeholderImage:[UIImage imageNamed:defineImageName] options:SDWebImageRetryFailed];
    }else{
        //直接赋值图片数据
        tempImageView.image=picture.image;
    }
}

#pragma mark - cell delegate  点击图片时<单击>
- (void)didTapForMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index
{
   // [self disappear];

    [self dismissViewControllerAnimated:NO completion:nil];
    
  //  [self.navigationController dismissViewControllerAnimated:false completion:nil];
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

#pragma mark - status bar
#if kIsShowStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
#endif

@end
