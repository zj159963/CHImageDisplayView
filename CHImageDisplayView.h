//
//  CHImageScrollView.h
//  ImageTest
//
//  Created by yicha on 1/13/16.
//  Copyright © 2016 yicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHImageDisplayView : UIView

+ (void)showImage:(UIImage *)image InView:(UIView *)view;
+ (void)showImageInKeyWindow:(UIImage *)image;

@end