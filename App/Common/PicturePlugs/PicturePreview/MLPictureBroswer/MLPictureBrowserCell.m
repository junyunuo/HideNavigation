//
//  MLPictureBrowserCell.m
//  InventoryTool
//


#import "MLPictureBrowserCell.h"
#import "MLPicture.h"
#import "UIImageView+WebCache.h"

#define kMinZoomScale 1.0f
#define kMaxZoomScale 2.5f

#define kIsFullWidthForLandScape NO //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES
@interface MLPictureBrowserCell()<UIScrollViewDelegate>

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *tipsLabel;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *overlayView; //覆盖View

@end

@implementation MLPictureBrowserCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.clipsToBounds = YES;
    
    [self resetZoomScale];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];
    
    //其他View
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.layer.cornerRadius = 3.0f;
    tipsLabel.font = [UIFont systemFontOfSize:13.0f];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.backgroundColor = [UIColor darkGrayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.layer.opacity = .0f;
    [self addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:indicator];
    self.indicator = indicator;

}


- (UIView*)overlayView
{
    //获取覆盖View
    if (!_overlayView) {
        //delegate设置了然后当前有绑定图像才启用
        if (self.picture&&self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureCell:ofIndex:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureCell:ofIndex:)]) {
            _overlayView = [self.delegate customOverlayViewOfMLPictureCell:self ofIndex:self.picture.index];
            [self addSubview:_overlayView];
        }
    }
    return _overlayView;
}

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] init];
        _scrollView.clipsToBounds = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop=NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.decelerationRate /= 2;
        _scrollView.bouncesZoom = YES; //缩放反弹，其实默认就是YES
		[self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView*)imageView
{
    if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        _imageView.backgroundColor = [UIColor yellowColor];
		[self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark 设置加载图片类型
-(void)setIfUrlLoadForPicture:(BOOL)ifUrlLoadForPicture{

    _ifUrlLoadForPicture=ifUrlLoadForPicture;
}

- (void)setPicture:(MLPicture *)picture
{
    if ([picture isEqual:_picture]) {
        return;
    }
    _picture = picture;
    //图像修改了，覆盖View就剔除
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    
    [self reloadImage];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //记不清为什么不写在layoutSubviews里了，就记得会影响缩放功能
    
    //scrollView的frame
    self.scrollView.frame = self.bounds;
    
    //重置缩放等级
    [self resetZoomScale];
    
    //设置图片View frame
    [self adjustFrame];
    
    self.tipsLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.indicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self bringSubviewToFront:self.tipsLabel];
    [self bringSubviewToFront:self.indicator];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)adjustFrame
{
    CGRect frame = self.scrollView.frame;
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        }else{
            if (frame.size.width<=frame.size.height) {
                //说白了就是竖屏时候
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageView.frame = imageFrame;
        self.scrollView.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollView:self.scrollView];
        
        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        //初始化
        self.scrollView.minimumZoomScale = kMinZoomScale;
        self.scrollView.maximumZoomScale = maxScale;
        self.scrollView.zoomScale = 1.0f;
    }else{
        
        
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        //重置内容大小
        self.scrollView.contentSize = self.imageView.frame.size;
        
        [self resetZoomScale];
    }
    self.scrollView.contentOffset = CGPointZero;
    
    //覆盖View
    if (self.picture&&self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureCell:ofIndex:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureCell:ofIndex:)]) {
                
        self.overlayView.frame = [self.delegate customOverlayViewFrameOfMLPictureCell:self ofIndex:self.picture.index];
        [self bringSubviewToFront:self.overlayView];
    }
}

- (void)resetZoomScale
{
    self.scrollView.minimumZoomScale = 1.0f;;
    self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    //重用前把缩放等级重置
    [self resetZoomScale];
    
}

#pragma mark 装载图片
- (void)reloadImage
{
    [self resetZoomScale];
    self.imageView.image = nil;
   // [self.imageView cancelImageRequestOperation];
    [self.imageView sd_cancelCurrentImageLoad];
    
    
    self.tipsLabel.text = @"加载网络图片失败";
    self.tipsLabel.layer.opacity = .0f;
    self.tipsLabel.frame = CGRectMake((self.bounds.size.width-120)/2, (self.bounds.size.height-30)/2, 120, 30);
    self.indicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.indicator startAnimating];
    
    //测试延迟
    //    double delayInSeconds = 1.0f;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //加载图像
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.picture.url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak __typeof(self)weakSelf = self;
    
    
    
    
    
    
    if(_ifUrlLoadForPicture){
        //通过url 加载图片
        NSURL *recordImageURL =self.picture.url;
        [self.imageView sd_setImageWithURL:recordImageURL placeholderImage:[UIImage imageNamed:@"DefaultPicture.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(error){
                
                NSLog(@"异常出现咯咯咯咯。。。");
                
                return;
            }
            if (![recordImageURL isEqual:weakSelf.picture.url]) {
                NSLog(@"不等于NSUrl哦哦哦哦");
                return;
            }
            weakSelf.picture.isLoaded = YES;
            [weakSelf.indicator stopAnimating];
            weakSelf.imageView.image = image;
            [weakSelf adjustFrame];
            
        }];
    }else{
        
        weakSelf.picture.isLoaded = YES;
        [weakSelf.indicator stopAnimating];
        weakSelf.imageView.image = self.picture.image;
        [weakSelf adjustFrame];
    
    }
    
    [self adjustFrame];
}


- (CGPoint)centerOfScrollView:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    return CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                       scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - tap
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self];
	if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) { //除去最小的时候双击最大，其他时候都还原成最小
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	} else {
		[self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES]; //还原
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    if (self.picture&&self.delegate&&[self.delegate respondsToSelector:@selector(didTapForMLPictureCell:ofIndex:)]) {
        [self.delegate didTapForMLPictureCell:self ofIndex:self.picture.index];
    }
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView //这里是缩放进行时调整
{
    self.imageView.center = [self centerOfScrollView:scrollView];
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale //缩放完毕后调整
{
    [UIView animateWithDuration:0.25f animations:^{
        view.center = [self centerOfScrollView:scrollView];
    }];
}

@end
