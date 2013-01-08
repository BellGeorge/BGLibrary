//
//  BGHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 08/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath(BGHelpers)

- (NSIndexPath *) bg_popFirstIndex;
- (NSIndexPath *) bg_popLastIndex;

- (NSIndexPath *) bg_pushIndexLast:(NSUInteger)index;

- (NSIndexPath *) bg_replaceFirstIndex:(NSUInteger)index;
- (NSIndexPath *) bg_replaceLastIndex:(NSUInteger)index;
- (NSIndexPath *) bg_replaceIndex:(NSUInteger)index atPosition:(NSUInteger)position;

- (NSUInteger) bg_firstIndex;
- (NSUInteger) bg_lastIndex;

@end
