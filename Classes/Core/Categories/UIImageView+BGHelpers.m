//
//  UIImageView+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 27/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UIImageView+BGHelpers.h"

@implementation UIImageView (BGHelpers)

- (CGRect) bg_fullImageFrame
{
    CGRect frame = self.frame;
    
    if(self.contentMode == UIViewContentModeScaleAspectFill)
    {
        CGFloat imageAspectRatio = self.image.size.width / self.image.size.height;
        CGFloat frameAspectRatio = frame.size.width / frame.size.height;
        CGRect newFrame = self.frame;
        
        // Image Frame is taller than the View Frame
        if(imageAspectRatio < frameAspectRatio)
        {
            CGFloat newHeight = newFrame.size.height * imageAspectRatio;
            newFrame.size.height = newHeight;
            CGFloat heightDelta = newHeight - frame.size.height;
            newFrame.origin.y -= (heightDelta / 2);
        }
        // Image Frame is wider than the View Frame
        else if(imageAspectRatio > frameAspectRatio)
        {
            CGFloat newWidth = newFrame.size.width * imageAspectRatio;
            newFrame.size.width = newWidth;
            CGFloat widthDelta = newWidth - frame.size.width;
            newFrame.origin.x -= (widthDelta / 2);
        }
        
        frame = newFrame;
    }
    
    return frame;
}

@end
