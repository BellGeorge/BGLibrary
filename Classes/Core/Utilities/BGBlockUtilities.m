//
//  BGBlockUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 27/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGBlockUtilities.h"

@implementation BGBlockUtilities

+ (BOOL) isObjectAtBlock:(id)block
{
    if([block isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        return YES;
    }
    
    return NO;
}

@end
