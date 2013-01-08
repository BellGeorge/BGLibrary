//
//  UIImageView+BGThumbnailHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BGThumbnailHelpers)

- (void) bg_setImageWithURL:(NSURL *)url;

- (void) bg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

- (void) bg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, UIImage *))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *))failure;

- (void) bg_setImageWithURLRequest:(NSURLRequest *)urlRequest placeholderImage:(UIImage *)placeholderImage success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, UIImage *))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *))failure;

@end
