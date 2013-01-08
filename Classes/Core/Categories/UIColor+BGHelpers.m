//
//  UIColor+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 04/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UIColor+BGHelpers.h"

@implementation UIColor (BGHelpers)

+ (UIColor *) bg_randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
