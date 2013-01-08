//
//  UIImageView+BGThumbnailHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UIImageView+BGThumbnailHelpers.h"
#import "UIImageView+AFNetworking.h"
#import "BGWebDataStore.h"
#import "BGLibraryMacros.h"

@implementation UIImageView (BGThumbnailHelpers)

- (void) bg_setImageWithURL:(NSURL *)url
{
    [self bg_setImageWithURL:url placeholderImage:nil];
}

- (void) bg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
    [self bg_setImageWithURL:url placeholderImage:placeholderImage success:NULL failure:NULL];
}

- (void) bg_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, UIImage *))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *))failure
{
    [self bg_setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:placeholderImage success:success failure:failure];
}

- (void) bg_setImageWithURLRequest:(NSURLRequest *)urlRequest placeholderImage:(UIImage *)placeholderImage success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, UIImage *))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *))failure
{
    BG_WEAKSELF;
    void (^successBlockContinuation)(NSURLRequest *, NSHTTPURLResponse *, UIImage *) = ^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image){
        // Set Image
        weakSelf.image = image;
        
        // This is expensive, do it asynchronously
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Cache Data
            NSData * imageData = nil;
            imageData = UIImagePNGRepresentation(image);
            
            // Allways do on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [BGWebDataStoreGet() setObject:imageData forKey:request.URL];
            });
        });
        
        if(success)
        {
            success(request, response, image);
        }
    };
    
    void (^failureBlockContinuation)(NSURLRequest *, NSHTTPURLResponse *, NSError *) = ^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error){
        if(failure)
        {
            //[BGWebDataStoreGet() removeObjectForKey:request.URL];
            
            if(failure)
            {
                failure(request, response, error);
            }
        }
    };
    
    if([BGWebDataStoreGet() hasObjectForKey:urlRequest.URL])
    {
        NSData * imageData = [BGWebDataStoreGet() objectForKey:urlRequest.URL];
        if([imageData isKindOfClass:[NSData class]])
        {
            UIImage * cachedImage = [UIImage imageWithData:imageData];
            if(cachedImage)
            {
                placeholderImage = cachedImage;
            }
        }
    }
    
    [self setImage:placeholderImage];
    [self setImageWithURLRequest:urlRequest placeholderImage:placeholderImage success:successBlockContinuation failure:failureBlockContinuation];
}

@end
