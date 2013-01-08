//
//  BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 08/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "NSIndexPath+BGHelpers.h"

@implementation NSIndexPath(BGHelpers)

- (NSIndexPath *) bg_popLastIndex
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * self.length);
    [self getIndexes:intArray];
    
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intArray length:self.length - 1];
    free(intArray);
    
    return nextIndexPath;
}


- (NSIndexPath *) bg_popFirstIndex
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * self.length);
    [self getIndexes:intArray];
    
    NSUInteger * intStart = intArray;
    intStart++;
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intStart length:self.length - 1];
    free(intArray);
    
    return nextIndexPath;
}


- (NSIndexPath *) bg_pushIndexLast:(NSUInteger)index
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * (self.length + 1));
    [self getIndexes:intArray];
    intArray[self.length] = index;
    
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intArray length:self.length + 1];
    free(intArray);
    
    return nextIndexPath;
}


- (NSIndexPath *) bg_replaceFirstIndex:(NSUInteger)index
{
    return [self bg_replaceIndex:index atPosition:(0)];
}


- (NSIndexPath *) bg_replaceLastIndex:(NSUInteger)index
{
    return [self bg_replaceIndex:index atPosition:(self.length - 1)];
}


- (NSIndexPath *) bg_replaceIndex:(NSUInteger)index atPosition:(NSUInteger)position
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * (self.length));
    [self getIndexes:intArray];
    intArray[position] = index;
    
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intArray length:self.length];
    free(intArray);
    
    return nextIndexPath;
}


- (NSUInteger) bg_firstIndex
{
    return [self indexAtPosition:0];
}


- (NSUInteger) bg_lastIndex
{
    return [self indexAtPosition:([self length]-1)];
}


@end
