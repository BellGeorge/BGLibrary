//
//  UIImageView+BGImageLoading.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 07/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BGImageLoading)

- (void) bg_cancelImageLoading;
- (void) bg_loadScaledImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder; 

@end
