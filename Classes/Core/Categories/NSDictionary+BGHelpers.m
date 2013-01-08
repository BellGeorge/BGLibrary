//
//  NSDictionary+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 21/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "NSDictionary+BGHelpers.h"
#import "BGCollectionUtilities.h"

@implementation NSDictionary (BGHelpers)

- (id) bg_recursiveMutableCopy
{
    return [BGCollectionUtilities recursiveMutable:self];
}

@end
