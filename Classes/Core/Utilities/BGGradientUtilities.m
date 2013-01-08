//
//  BGGradientUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 28/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGGradientUtilities.h"

@implementation BGGradientUtilities

+ (CAGradientLayer *) verticalLinearGradientFrom:(UIColor *)startColor endColor:(UIColor *)endColor
{    
    NSArray * colors = @[ (id)startColor.CGColor, (id)endColor.CGColor ];
    NSArray * locations = @[@(0.0f), @(1.0f)];
    
    CAGradientLayer * headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

@end
