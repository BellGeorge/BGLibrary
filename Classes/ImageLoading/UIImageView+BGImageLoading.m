//
//  UIImageView+BGImageLoading.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 07/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UIImageView+BGImageLoading.h"

#import <objc/runtime.h>
#import "BGLibraryMacros.h"
#import "ReactiveCocoa.h"
#import "OGScaledImage.h"

@implementation UIImageView (BGImageLoading)

#pragma mark Private

static const char * ogImageKey = "__BGImageLoading__OGImage";

- (void) bg_setOGImage:(OGImage *)ogImage
{
    if(ogImage)
    {
        // Need to switch on type
        BG_WEAKSELF
        [RACAble(ogImage, image) subscribeNext:^(UIImage * image){
            weakSelf.image = image;
        }];
    }
    
    objc_setAssociatedObject(self, ogImageKey, ogImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (OGImage *) bg_getOGImage
{
    OGImage * ogImage = objc_getAssociatedObject(self, ogImageKey);
    return ogImage;
}

#pragma mark Image Loading

- (void) bg_cancelImageLoading
{
    [self bg_setOGImage:nil];
}

- (void) bg_loadScaledImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder
{
    CGSize imageSize = self.bounds.size;
    OGScaledImage * scaledImage = [[OGScaledImage alloc] initWithURL:url size:imageSize key:nil placeholderImage:placeholder];
    [self bg_setOGImage:scaledImage];
}


@end
