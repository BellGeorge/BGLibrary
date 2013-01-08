//
//  BGCoreGraphicsUtilties.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 06/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef struct{
    CGFloat topLeft, topRight, bottomLeft, bottomRight;
} BGCornerRadiuses;

extern CGMutablePathRef CGMutablePathRefCreateRoundedRect(CGRect rect, BGCornerRadiuses cornerRadiuses);

extern void BGDrawRoundedRectWithGradient(CGContextRef context, CGRect rect, CGFloat lineWidth, BGCornerRadiuses cornerRadiuses, UIColor * topColor, UIColor * bottomColor, UIColor * borderColor);

@interface BGCoreGraphicsUtilties : NSObject

@end
