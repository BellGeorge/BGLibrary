//
//  NSException+BGHelepers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 21/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "NSException+BGHelepers.h"

@implementation NSException (BGHelepers)

+ (void) raiseWithError:(NSError *)error
{
    [NSException raise:[error localizedDescription] format:nil];
}

@end
