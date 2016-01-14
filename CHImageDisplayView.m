//
//  CHImageScrollView.m
//  ImageTest
//
//  Created by yicha on 1/13/16.
//  Copyright © 2016 yicha. All rights reserved.
//

#import "CHImageDisplayView.h"

@interface CHImageDisplayView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation CHImageDisplayView

+ (void)showImageInKeyWindow:(UIImage *)image
{
  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  [self showImage:image InView:keyWindow];
}

+ (void)showImage:(UIImage *)image InView:(UIView *)view
{
  CHImageDisplayView *displayView = [CHImageDisplayView new];
  displayView.frame = [UIScreen mainScreen].bounds;
  displayView.alpha = 0.0;
  [view addSubview:displayView];
  [displayView initializeWithImage:image];
  [UIView animateWithDuration:1.0 animations:^{
    displayView.alpha = 1.0;
  }];
}

- (void)initializeWithImage:(UIImage *)image
{
  self.backgroundColor = [UIColor blackColor];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  [self addGestureRecognizer:tap];
  
  [self createScrollViewWithImage:image];
  [self addSubview:self.scrollView];
  
  self.imageView = [UIImageView new];
  self.imageView.image = image;
  
  if (image.size.width < self.scrollView.frame.size.width && image.size.height < self.scrollView.frame.size.height) {
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale;
  } else {
    CGFloat screenWHRate = self.scrollView.frame.size.width / self.scrollView.frame.size.height;
    CGFloat imageWHRate = image.size.width / image.size.height;
    if (imageWHRate > screenWHRate) {
      CGFloat scaleRate = image.size.width / self.scrollView.frame.size.width;
      self.scrollView.maximumZoomScale = scaleRate;
      CGFloat width = self.scrollView.frame.size.width;
      CGFloat height = image.size.height / scaleRate;
      CGFloat y = (self.scrollView.frame.size.height - height) * 0.5;
      self.imageView.frame = CGRectMake(0, y, width, height);
    } else {
      CGFloat scaleRate = image.size.height / self.scrollView.frame.size.height;
      self.scrollView.maximumZoomScale = scaleRate;
      CGFloat height = self.scrollView.frame.size.height;
      CGFloat width = image.size.width / scaleRate;
      CGFloat x = (self.scrollView.frame.size.width - width) * 0.5;
      self.imageView.frame = CGRectMake(x, 0, width, height);
    }
  }
  
  [self.scrollView addSubview:self.imageView];
  
}

- (void)createScrollViewWithImage:(UIImage *)image
{
  self.scrollView = [UIScrollView new];
  self.scrollView.frame = [UIScreen mainScreen].bounds;
  self.scrollView.minimumZoomScale = 1.0;
  self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
  self.scrollView.delegate = self;
}

- (void)tap:(id)sender
{
  [UIView animateWithDuration:0.5 animations:^{
    self.alpha = 0.0;
  } completion:^(BOOL finished) {
    if (finished) {
      [self removeFromSuperview];
    }
  }];
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
  CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
  self.imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

@end