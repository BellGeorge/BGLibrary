//
//  BGGradientUtilities.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 28/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BGGradientUtilities : NSObject

+ (CAGradientLayer *) verticalLinearGradientFrom:(UIColor *)startColor endColor:(UIColor *)color;

@end
