
//
//  BGCoreGraphicsUtilties.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 06/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGCoreGraphicsUtilties.h"

CGMutablePathRef CGMutablePathRefCreateRoundedRect(CGRect rect, BGCornerRadiuses cornerRadiuses)
{
    CGPoint startPoint, endPoint;
    CGFloat radius;
    
    CGMutablePathRef path = CGPathCreateMutable();
    startPoint.x = CGRectGetMidX(rect);
    startPoint.y = CGRectGetMinY(rect);
    
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    
    startPoint.x = CGRectGetMaxX(rect);
    startPoint.y = CGRectGetMinY(rect);
    endPoint.x = CGRectGetMaxX(rect);
    endPoint.y = CGRectGetMaxY(rect);
    radius = cornerRadiuses.topRight;
    CGPathAddArcToPoint(path, NULL, startPoint.x, startPoint.y, endPoint.x, endPoint.y, radius);
    
    startPoint.x = CGRectGetMaxX(rect);
    startPoint.y = CGRectGetMaxY(rect);
    endPoint.x = CGRectGetMinX(rect);
    endPoint.y = CGRectGetMaxY(rect);
    radius = cornerRadiuses.bottomRight;
    CGPathAddArcToPoint(path, NULL, startPoint.x, startPoint.y, endPoint.x, endPoint.y, radius);
    
    startPoint.x = CGRectGetMinX(rect);
    startPoint.y = CGRectGetMaxY(rect);
    endPoint.x = CGRectGetMinX(rect);
    endPoint.y = CGRectGetMinY(rect);
    radius = cornerRadiuses.bottomLeft;
    CGPathAddArcToPoint(path, NULL, startPoint.x, startPoint.y, endPoint.x, endPoint.y, radius);

    startPoint.x = CGRectGetMinX(rect);
    startPoint.y = CGRectGetMinY(rect);
    endPoint.x = CGRectGetMaxX(rect);
    endPoint.y = CGRectGetMinY(rect);
    radius = cornerRadiuses.topLeft;
    CGPathAddArcToPoint(path, NULL, startPoint.x, startPoint.y, endPoint.x, endPoint.y, radius);
    
    CGPathCloseSubpath(path);
    
    return path;        
}


extern void BGDrawRoundedRectWithGradient(CGContextRef context, CGRect rect, CGFloat lineWidth, BGCornerRadiuses cornerRadiuses, UIColor * topColor, UIColor * bottomColor, UIColor * borderColor)
{
    // Save State
    CGContextSaveGState(context);
        
    // Clear The Rect
    CGContextClearRect(context, rect);
    
    /* Draw the Gradient */
    CGContextSaveGState(context);
    
    // Rounded Rect Path
    // Half point radius keeps color from bleeding
    CGMutablePathRef gradientPathRef = CGMutablePathRefCreateRoundedRect(CGRectInset(rect, 0.5, 0.5), cornerRadiuses);
    // Add Path to context
    CGContextAddPath(context, gradientPathRef);
    // Release Path
    CGPathRelease(gradientPathRef);
    
    // Clip for Gradient
    CGContextClip(context);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    // Draw Gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray * colors = @[(id) topColor.CGColor, (id) bottomColor.CGColor];
    const CGFloat locations[] = {0.0f, 1.0f};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // Release
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    // Restore State
    CGContextRestoreGState(context);
    
    /* End of the Gradient */
    
    /* Draw the Lines */
    CGContextSaveGState(context);
    
    // Setup Line
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetLineJoin(context, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(context, YES);
    
    // Clip Path
    CGMutablePathRef clipBathRef = CGMutablePathRefCreateRoundedRect(rect, cornerRadiuses);
    CGContextAddPath(context, clipBathRef);
    CGContextClip(context);
    CGPathRelease(clipBathRef);
    
    // Create Border Path
    CGMutablePathRef borderPathRef = CGMutablePathRefCreateRoundedRect(rect, cornerRadiuses);
    CGContextAddPath(context, borderPathRef);
    CGPathRelease(borderPathRef);
    
    // Stroke the Path
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    /* End of draw the Lines */
    
    // Restore State Stack
    CGContextRestoreGState(context);
}

@implementation BGCoreGraphicsUtilties

@end
