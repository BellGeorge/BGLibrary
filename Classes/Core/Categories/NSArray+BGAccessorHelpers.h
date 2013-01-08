//
//  NSArray+BGAccessorHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 04/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BGAccessorHelpers)

- (id) bg_firstObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))test;

- (id) bg_recursiveMutableCopy;

@end
