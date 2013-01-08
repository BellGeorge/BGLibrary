//
//  BGGeometryUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 12/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGGeometryUtilities.h"
#import "BGMathUtilities.h"
#import "BGLibraryMacros.h"

#pragma mark CGRect

extern inline CGRect BG_CGRectZeroOriginWithSize(CGSize size)
{
    CGRect rect = CGRectZero;
    rect.size = size;
    return rect;
}

extern inline CGRect BG_CGRectInset(CGRect rect, UIEdgeInsets edgeInsets)
{
    CGRect newRect = rect;
    newRect.size.height -= edgeInsets.top;
    newRect.size.height -= edgeInsets.bottom;
    newRect.size.width -= edgeInsets.left;
    newRect.size.width -= edgeInsets.right;
    newRect.origin.x += edgeInsets.left;
    newRect.origin.y += edgeInsets.right;
    return newRect;
}

extern inline CGPoint BG_CGRectGetPoint(CGRect rect, BGAlignment alignment)
{
    CGPoint point = CGPointZero;
    
    BGAlignment horizontalAlignment = alignment & BGAligmentHorizontal;
    switch (horizontalAlignment) {
        case BGAlignmentLeft:
        case BGAlignmentLeftInside:
        case BGAlignmentLeftOutside:
        case BGAlignmentLeftOn:
            point.x = CGRectGetMinX(rect);
            break;
        case BGAlignmentRight:
        case BGAlignmentRightInside:
        case BGAlignmentRightOutside:
        case BGAlignmentRightOn:
            point.x = CGRectGetMaxX(rect);
            break;
        case BGAlignmentCenterHorizontal:
            point.x = CGRectGetMidX(rect);
            break;
        default:
            break;
            
    }
    
    BGAlignment verticalAlignment = alignment & BGAlignmentVertical;
    switch (verticalAlignment) {
        case BGAlignmentTop:
        case BGAlignmentTopInside:
        case BGAlignmentTopOutside:
        case BGAlignmentTopOn:
            point.y = CGRectGetMaxY(rect);
            break;
        case BGAlignmentBottom:
        case BGAlignmentBottomInside:
        case BGAlignmentBottomOutside:
        case BGAlignmentBottomOn:
            point.y = CGRectGetMinY(rect);
            break;
        case BGAlignmentCenterVertical:
            point.y = CGRectGetMidY(rect);
            break;
        default:
            break;
    }
    
    return point;
}

extern inline CGRect BG_CGRectAlignWithOffset(const CGRect alignRect, CGRect rect, BGAlignment alignment, CGPoint offset)
{
    BGAlignment horizontalAlignment = alignment & BGAligmentHorizontal;
    switch (horizontalAlignment) {
        case BGAlignmentLeftInside:
            rect.origin.x = CGRectGetMinX(alignRect) + offset.x;
            break;
        case BGAlignmentLeftOutside:
            rect.origin.x = CGRectGetMinX(alignRect) - CGRectGetWidth(rect) + offset.x;
            break;
        case BGAlignmentLeftOn:
            rect.origin.x = CGRectGetMinX(alignRect) - (CGRectGetWidth(rect) / 2) + offset.x;
            break;
        case BGAlignmentRightInside:
            rect.origin.x = CGRectGetMaxX(alignRect) - CGRectGetWidth(rect) - offset.x;
            break;
        case BGAlignmentRightOutside:
            rect.origin.x = CGRectGetMaxX(alignRect) + offset.x;
            break;
        case BGAlignmentRightOn:
            rect.origin.x = CGRectGetMaxX(alignRect) - (CGRectGetWidth(rect) / 2) - offset.x;
            break;
        case BGAlignmentCenterHorizontal:
            rect.origin.x = CGRectGetMidX(alignRect) - (CGRectGetWidth(rect) / 2) + offset.x;
            break;
        default:
            break;
            
    }
    
    BGAlignment verticalAlignment = alignment & BGAlignmentVertical;
    switch (verticalAlignment) {
        case BGAlignmentTopInside:
            rect.origin.y = CGRectGetMinY(alignRect) + offset.y;
            break;
        case BGAlignmentTopOutside:
            rect.origin.y = CGRectGetMinY(alignRect) - CGRectGetHeight(rect) - offset.y;
            break;
        case BGAlignmentTopOn:
            rect.origin.y = CGRectGetMinY(alignRect) - (CGRectGetHeight(rect) / 2) + offset.y;
            break;
        case BGAlignmentBottomInside:
            rect.origin.y = CGRectGetMaxY(alignRect) - CGRectGetHeight(rect) - offset.y;
            break;
        case BGAlignmentBottomOutside:
            rect.origin.y = CGRectGetMaxY(alignRect) + offset.y;
            break;
        case BGAlignmentBottomOn:
            rect.origin.y = CGRectGetMinY(alignRect) - (CGRectGetHeight(rect) / 2) - offset.y;
            break;
        case BGAlignmentCenterVertical:
            rect.origin.y = CGRectGetMidY(alignRect) - (CGRectGetHeight(rect) / 2) + offset.y;
            break;
        default:
            break;
    }
    
    return rect;
}

extern inline CGRect BG_CGRectAlign(const CGRect alignRect, CGRect rect, BGAlignment alignment)
{
    return BG_CGRectAlignWithOffset(alignRect, rect, alignment, CGPointMake(0.0f, 0.0f));
}

#pragma mark CGSize

extern inline CGSize BG_CGSizeUnion(CGSize s1, CGSize s2)
{
    CGRect r1 = BG_CGRectZeroOriginWithSize(s1);
    CGRect r2 = BG_CGRectZeroOriginWithSize(s2);
    CGRect rect = CGRectUnion(r1, r2);
    return rect.size;
}

extern inline CGSize BG_CGSizeAdd(CGSize s1, CGSize s2)
{
    CGSize result = CGSizeMake(s1.width + s2.width, s1.height + s2.height);
    return result;
}

extern inline CGSize BG_CGSizeInset(CGSize size, CGFloat dw, CGFloat dh)
{
    CGSize newSize = size;
    newSize.width += dw;
    newSize.height += dh;
    return newSize;
}

extern inline CGSize BG_CGSizeCombine(CGSize s1, CGSize s2, BGAlignment alignment)
{
    CGRect frame1 = BG_CGRectZeroOriginWithSize(s1);
    CGRect frame2 = BG_CGRectZeroOriginWithSize(s2);
    frame2 = BG_CGRectAlign(frame1, frame2, alignment);
    CGSize result = CGRectUnion(frame1, frame2).size;
    return result;
}

#pragma mark CGPoint

extern inline CGPoint BG_CGPointSubtract(CGPoint minuend, CGPoint subtrahend)
{
    CGPoint result = CGPointMake(minuend.x - subtrahend.x, minuend.y - subtrahend.y);
    return result;
}

extern inline CGPoint BG_CGPointAdd(CGPoint p1, CGPoint p2)
{
    CGPoint point = CGPointMake(p1.x + p2.x, p1.y + p2.y);
    return point;
}

extern inline CGPoint BG_CGPointModulus(CGPoint point)
{
    CGPoint result = CGPointMake(ABS(point.x), ABS(point.y));
    return result;
}

extern inline CGPoint BG_CGPointScalarDivide(CGPoint point, CGFloat divisor)
{
    CGPoint result = CGPointMake((point.x / divisor), (point.y / divisor));
    return result;
}

extern inline CGPoint BG_CGPointScalarMultiply(CGPoint point, CGFloat scalarValue)
{
    CGPoint result = CGPointMake((point.x * scalarValue), (point.y * scalarValue));
    return result;
}

extern inline CGFloat BG_CGPointMagnitude(CGPoint point)
{
    CGFloat magnitude = sqrtf( (point.x * point.x) + (point.y * point.y) );
    return magnitude;
}

extern inline CGPoint BG_CGPointClamp(CGPoint min, CGPoint max, CGPoint value)
{
    CGPoint result = CGPointMake(BGClamp(min.x, max.x, value.x), BGClamp(min.y, max.y, value.y));
    return result;
}

extern inline CGPoint BG_CGPointNormalize(CGPoint point)
{
    CGFloat magnitude = BG_CGPointMagnitude(point);
    CGPoint result = BG_CGPointScalarMultiply(point, (1 / magnitude) );
    return result;
}

#pragma mark CGAffineTransform

extern inline CGFloat BG_CGAffineTransformGetRotation(CGAffineTransform transform)
{
    CGFloat value = atan2(transform.b, transform.a);
    return value;
}

@implementation BGGeometryUtilities

@end
