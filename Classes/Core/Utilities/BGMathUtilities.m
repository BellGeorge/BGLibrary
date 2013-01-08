//
//  BGMathHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 14/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGMathUtilities.h"

extern inline CGFloat BGFractionClampCGFloat(CGFloat min, CGFloat max, CGFloat value)
{
    // Scale to 0 minimum
    if(min < 0)
    {
        max += ABS(min);
        value += ABS(min);
        min = 0;
    }
    
    CGFloat extent = max - min;
    CGFloat positionInExtent = value - min;
    CGFloat fraction = positionInExtent / extent;
    fraction = BGClamp(0.0f, 1.0f, fraction);
    return fraction;
}

extern inline CGFloat BGLerpClampCGFloat(CGFloat min, CGFloat max, CGFloat fraction)
{
    CGFloat extent = max - min;
    CGFloat value = fraction * extent;
    value += min;
    value = BGClamp(min, max, value);
    return value;
}

@implementation BGMathUtilities

@end
