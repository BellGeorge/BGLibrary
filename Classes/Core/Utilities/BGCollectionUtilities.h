//
//  BGCollectionUtilities.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 15/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGCollectionUtilities : NSObject

#pragma mark Extraction

+ (NSArray *) objectsAtIndexPaths:(NSArray *)indexPaths fromArray:(NSArray *) array childDictionaryKey:(id)childDictionaryKey;
+ (NSArray *) objectsAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *) array childDictionaryKey:(id)childDictionaryKey;
+ (id) objectAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *) array childDictionaryKey:(id)childDictionaryKey;

#pragma mark Mutability

+ (id) recursiveMutable:(id)collection;

#pragma mark Visitor

+ (void) visitCollection:(id)collection withIndexedCollectionBlock:(void (^)(id obj, NSUInteger idx, NSIndexPath * indexPath, BOOL *stop))indexedCollectionBlock withKeyedCollectionBlock:(void (^)(id key, id obj, NSIndexPath * indexPath, BOOL *stop))keyedCollectionBlock;

#pragma mark Filtering

+ (id) recursivelyFilterCollection:(id)collection byRejecting:(NSArray *)rejectionArray;
+ (id) recursivelyFilterCollection:(id)collection byAccepting:(NSArray *)rejectionArray;

@end
