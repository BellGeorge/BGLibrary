//
//  BGGeometryUtilities.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 12/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    // Vertical Aligment
    BGAlignmentTopInside = 1 << 1,
    BGAlignmentTopOutside = 1 << 2,
    BGAlignmentTopOn = 1 << 3,
    BGAlignmentTop = (BGAlignmentTopInside | BGAlignmentTopOutside | BGAlignmentTopOn),
    
    BGAlignmentBottomInside = 1 << 4,
    BGAlignmentBottomOutside = 1 << 5,
    BGAlignmentBottomOn = 1 << 6,
    BGAlignmentBottom = (BGAlignmentBottomInside | BGAlignmentBottomOutside | BGAlignmentBottomOn),
    
    BGAlignmentCenterVertical = 1 << 7,
    BGAlignmentVertical = (BGAlignmentTopInside | BGAlignmentTopOutside | BGAlignmentTopOn | BGAlignmentBottomInside | BGAlignmentBottomOutside | BGAlignmentBottomOn | BGAlignmentCenterVertical),
    
    // Horizontal Aligment
    BGAlignmentLeftInside = 1 << 8,
    BGAlignmentLeftOutside = 1 << 9,
    BGAlignmentLeftOn = 1 << 10,
    BGAlignmentLeft = (BGAlignmentLeftInside | BGAlignmentLeftOutside | BGAlignmentLeftOn),
    
    BGAlignmentRightInside = 1 << 11,
    BGAlignmentRightOutside = 1 << 12,
    BGAlignmentRightOn = 1 << 13,
    BGAlignmentRight = (BGAlignmentRightInside | BGAlignmentRightOutside | BGAlignmentRightOn),
    
    BGAlignmentCenterHorizontal = 1 << 14,
    BGAligmentHorizontal = (BGAlignmentLeftInside | BGAlignmentLeftOutside | BGAlignmentLeftOn | BGAlignmentRightInside | BGAlignmentRightOutside | BGAlignmentRightOn | BGAlignmentCenterHorizontal),
    
    // Composites
    BGAlignmentCenter = BGAlignmentCenterHorizontal | BGAlignmentCenterVertical,
    
    // Aliases
    BGAlignmentAbove = BGAlignmentTopOutside,
    BGAlignmentBelow = BGAlignmentBottomOutside,
    BGAlignmentToLeftOf = BGAlignmentLeftOutside,
    BGAlignmentToRightOf = BGAlignmentRightOutside
} BGAlignment;

#define BGDegreesToRadians(x) (M_PI * x / 180.0)

#pragma mark CGRect

extern inline CGRect BG_CGRectZeroOriginWithSize(CGSize size);
extern inline CGRect BG_CGRectInset(CGRect rect, UIEdgeInsets edgeInsets);
extern inline CGPoint BG_CGRectGetPoint(CGRect rect, BGAlignment position);

// Offsetting will displace the target rectange from its anchor point
extern inline CGRect BG_CGRectAlignWithOffset(const CGRect alignRect, CGRect rect, BGAlignment alignment, CGPoint offset);
extern inline CGRect BG_CGRectAlign(const CGRect alignRect, CGRect rect, BGAlignment alignment);

#pragma mark CGSize

extern inline CGSize BG_CGSizeUnion(CGSize s1, CGSize s2);
extern inline CGSize BG_CGSizeAdd(CGSize s1, CGSize s2);
extern inline CGSize BG_CGSizeInset(CGSize size, CGFloat dw, CGFloat dh);
extern inline CGSize BG_CGSizeCombine(CGSize s1, CGSize s2, BGAlignment relativePosition);

#pragma mark CGPoint

extern inline CGPoint BG_CGPointAdd(CGPoint p1, CGPoint p2);
extern inline CGPoint BG_CGPointSubtract(CGPoint minuend, CGPoint subtrahend);

extern inline CGPoint BG_CGPointModulus(CGPoint point);
extern inline CGPoint BG_CGPointScalarMultiply(CGPoint point, CGFloat scalarValue);
extern inline CGPoint BG_CGPointScalarDivide(CGPoint point, CGFloat divisor);

extern inline CGFloat BG_CGPointMagnitude(CGPoint p1);
extern inline CGPoint BG_CGPointClamp(CGPoint min, CGPoint max, CGPoint value);
extern inline CGPoint BG_CGPointNormalize(CGPoint point);

#pragma mark CGAffineTransform

extern inline CGFloat BG_CGAffineTransformGetRotation(CGAffineTransform transform);

@interface BGGeometryUtilities : NSObject

@end
