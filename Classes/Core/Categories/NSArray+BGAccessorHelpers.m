//
//  NSArray+BGAccessorHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 04/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "NSArray+BGAccessorHelpers.h"
#import "BGCollectionUtilities.h"

@implementation NSArray (BGAccessorHelpers)

- (id) bg_firstObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))test
{
    NSUInteger index = [self indexOfObjectPassingTest:test];
    if(index != NSNotFound)
        return [self objectAtIndex:index];
    
    return nil;
}

- (id) bg_recursiveMutableCopy
{
    return [BGCollectionUtilities recursiveMutable:self];
}

@end
