//
//  BGMathHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 14/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BGMax(val1, val2) ((val1 > val2) ? val1 : val2)
#define BGMin(val1, val2) ((val1 < val2) ? val1 : val2)
#define BGClamp(min, max, val) ((val < min) ? min : ((val > max) ? max : val))
#define BGScale(minStart, maxStart, minEnd, maxEnd, value) ( minEnd + (value * (maxEnd - minEnd)) )

extern inline CGFloat BGFractionClampCGFloat(CGFloat min, CGFloat max, CGFloat value);

extern inline CGFloat BGLerpClampCGFloat(CGFloat min, CGFloat max, CGFloat fraction);

@interface BGMathUtilities : NSObject

@end
