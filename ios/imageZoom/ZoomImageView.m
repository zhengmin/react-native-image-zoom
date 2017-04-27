//
//  ZoomImageView.m
//  zapda
//
//  Created by 郑章民 on 2017/4/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ZoomImageView.h"
#import "SDWebImageDownloader.h"

@interface ZoomImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@property (nonatomic, copy) NSString *loadUri;

@end

@implementation ZoomImageView

- (instancetype)init
{
  if (self = [super init])
  {
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    // enable double tap
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
  }
  return self;
}

- (void)reactSetFrame:(CGRect)frame
{
  [super reactSetFrame:frame];
  
  //创建UI
  [self createView];
  
  [self loadImage:self.loadUri];
}

-(void)setUri:(NSString *)uri{

  self.loadUri = uri;
}

#pragma mark - createView
-(void)createView{
  self.backgroundColor = [UIColor clearColor];
  
  _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
  _scrollView.delegate = self;
  _scrollView.zoomScale = 1.0;
  _scrollView.minimumZoomScale = 1.0;
  _scrollView.maximumZoomScale = 2.0f;
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.backgroundColor = [UIColor clearColor];
  [self addSubview:_scrollView];
  
  _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
  _imageView.contentMode = UIViewContentModeScaleAspectFit;
  _imageView.backgroundColor = [UIColor clearColor];
  [_scrollView addSubview:_imageView];
  
  _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  _activityIndicator.center = _scrollView.center;
  [self addSubview:_activityIndicator];
  _activityIndicator.hidesWhenStopped = YES;
}

#pragma mark - method
- (void)scaleImageView:(UITapGestureRecognizer*)tapGesture
{
  CGPoint tapPoint = [tapGesture locationInView:self.scrollView];
  if (self.scrollView.zoomScale > 1.f) {
    [self.scrollView setZoomScale:1.f animated:YES];
  }
  else {
    [self zoomScrollView:self.scrollView toPoint:tapPoint withScale:2.f animated:YES];
  }
}

-(void)removeFromSuperview{
  
}

- (void)zoomScrollView:(UIScrollView*)view toPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated
{
  //Normalize current content size back to content scale of 1.0f
  CGSize contentSize = CGSizeZero;
  
  contentSize.width = (view.contentSize.width / view.zoomScale);
  contentSize.height = (view.contentSize.height / view.zoomScale);
  
  //translate the zoom point to relative to the content rect
  //jimneylee add compare contentsize with bounds's size
  if (view.contentSize.width < view.bounds.size.width) {
    zoomPoint.x = (zoomPoint.x / view.bounds.size.width) * contentSize.width;
  }
  else {
    zoomPoint.x = (zoomPoint.x / view.contentSize.width) * contentSize.width;
  }
  if (view.contentSize.height < view.bounds.size.height) {
    zoomPoint.y = (zoomPoint.y / view.bounds.size.height) * contentSize.height;
  }
  else {
    zoomPoint.y = (zoomPoint.y / view.contentSize.height) * contentSize.height;
  }
  
  //derive the size of the region to zoom to
  CGSize zoomSize = CGSizeZero;
  zoomSize.width = view.bounds.size.width / scale;
  zoomSize.height = view.bounds.size.height / scale;
  
  //offset the zoom rect so the actual zoom point is in the middle of the rectangle
  CGRect zoomRect = CGRectZero;
  zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0f;
  zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0f;
  zoomRect.size.width = zoomSize.width;
  zoomRect.size.height = zoomSize.height;
  
  //apply the resize
  [view zoomToRect: zoomRect animated: animated];
}

- (CGRect)calculateScaledFinalFrame:(UIImage *)image
{
  CGSize thumbSize = image.size;
  CGFloat finalHeight = self.frame.size.width * (thumbSize.height / thumbSize.width);
  CGFloat top = 0.f;
  if (finalHeight < self.frame.size.height) {
    top = (self.frame.size.height - finalHeight) / 2.f;
  }
  return CGRectMake(0.f, top, self.frame.size.width, finalHeight);
}

-(void)loadImage:(NSString *)url{
  
  if([url rangeOfString:@"http"].location !=NSNotFound){
    //包含
    [_activityIndicator startAnimating];
    
    __weak ZoomImageView *wSelf = self;
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
      
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
      
      dispatch_async(dispatch_get_main_queue(), ^(void){
        [wSelf.activityIndicator stopAnimating];
        
        if (finished && image) {
          //下载成功
          [wSelf reSizeImage:image];
        }else{
          //下载失败
          
        }
      });
      
    }];
  }else{
    UIImage *image = [UIImage imageWithContentsOfFile:url];
    [self reSizeImage:image];
  }
}

-(void)reSizeImage:(UIImage *)image{
  CGRect finalFrame = [self calculateScaledFinalFrame:image];
  if (finalFrame.size.height > self.frame.size.height) {
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, finalFrame.size.height);
  }
  self.imageView.frame = finalFrame;
  [self.imageView setImage:image];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5f : 0.f;
  
  CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5f : 0.f;
  
  self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5f + offsetX, scrollView.contentSize.height * 0.5f + offsetY);
}

@end
