//
//  UISwipeGestureRecognizer+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 04/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UISwipeGestureRecognizer+BGHelpers.h"
#import "BGMathUtilities.h"
#import "BGGeometryUtilities.h"

@implementation UISwipeGestureRecognizer (BGHelpers)

- (CGFloat) bg_pixelVelocityInSeconds
{
    if(self.numberOfTouches >= 2)
    {
        CGPoint start = [self locationOfTouch:0 inView:self.view];
        CGPoint end = [self locationOfTouch:(self.numberOfTouches - 1) inView:self.view];
        CGPoint displacement = BG_CGPointSubtract(start, end);
        CGFloat magnitude = BG_CGPointMagnitude(displacement);
        return magnitude;
    }
    
    return 0.0f;
}

@end
