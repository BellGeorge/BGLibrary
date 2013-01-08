//
//  BGCollectionUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 15/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGCollectionUtilities.h"

#import "BlocksKit.h"
#import "NSIndexPath+BGHelpers.h"

@implementation BGCollectionUtilities

#pragma mark Extraction

+ (NSArray *) objectsAtIndexPaths:(NSArray *)indexPaths fromArray:(NSArray *)array childDictionaryKey:(id)childDictionaryKey
{
    NSMutableArray * objects = [[NSMutableArray alloc] init];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * indexPaths, NSUInteger index, BOOL * stop) {
        [self objectAtIndexPath:indexPaths fromArray:array childDictionaryKey:childDictionaryKey];
    }];
    
    return objects;
}

+ (NSArray *) objectsAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *)array childDictionaryKey:(id)childDictionaryKey
{
    if(!indexPath || indexPath.length == 0)
    {
        return array;
    }
    
    NSUInteger index = [indexPath bg_firstIndex];
    id object = [array objectAtIndex:index];
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        object = object[childDictionaryKey];
    }
    
    indexPath = [indexPath bg_popFirstIndex];
    return [self objectsAtIndexPath:indexPath fromArray:object childDictionaryKey:childDictionaryKey];
}

+ (id) objectAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *) array childDictionaryKey:(id)childDictionaryKey;
{
    NSUInteger index = [indexPath bg_lastIndex];
    indexPath = [indexPath bg_popLastIndex];
    array = [self objectsAtIndexPath:indexPath fromArray:array childDictionaryKey:childDictionaryKey];
    
    return array[index];
}


#pragma mark Mutability

+ (id) recursiveMutable:(id)object
{
	if([object isKindOfClass:[NSDictionary class]])
	{
		NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:object];
		for(NSString* key in [dict allKeys])
		{
			[dict setObject:[BGCollectionUtilities recursiveMutable:[dict objectForKey:key]] forKey:key];
		}
		return dict;
	}
	else if([object isKindOfClass:[NSArray class]])
	{
		NSMutableArray* array = [NSMutableArray arrayWithArray:object];
		for(int i=0;i<[array count];i++)
		{
			[array replaceObjectAtIndex:i withObject:[BGCollectionUtilities recursiveMutable:[array objectAtIndex:i]]];
		}
		return array;
	}
	else if([object isKindOfClass:[NSString class]])
		return [NSMutableString stringWithString:object];
	return object;
}

#pragma mark Visitor

+ (void) visitCollection:(id)collection withIndexedCollectionBlock:(void (^)(id obj, NSUInteger idx, NSIndexPath * indexPath, BOOL *stop))indexedCollectionBlock withKeyedCollectionBlock:(void (^)(id key, id obj, NSIndexPath * indexPath, BOOL *stop))keyedCollectionBlock fromIndexPath:(NSIndexPath *)indexPath
{
    if([collection respondsToSelector:@selector(enumerateObjectsUsingBlock:)])
    {
        [collection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Construct Index Path
            NSIndexPath * localIndexPath = [indexPath bg_pushIndexLast:idx];
            
            // Call enumerator
            indexedCollectionBlock(obj, idx, localIndexPath, stop);
            
            // Recurse
            [BGCollectionUtilities visitCollection:obj withIndexedCollectionBlock:indexedCollectionBlock withKeyedCollectionBlock:keyedCollectionBlock fromIndexPath:indexPath];
        }];
    }
    else if([collection respondsToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)])
    {
        [collection enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // Call enumerator
            keyedCollectionBlock(key, obj, indexPath, stop);
            
            // Recurse
            [BGCollectionUtilities visitCollection:obj withIndexedCollectionBlock:indexedCollectionBlock withKeyedCollectionBlock:keyedCollectionBlock fromIndexPath:(NSIndexPath *)indexPath];
        }];
    }
}

+ (void) visitCollection:(id)collection withIndexedCollectionBlock:(void (^)(id obj, NSUInteger idx, NSIndexPath * indexPath, BOOL *stop))indexedCollectionBlock withKeyedCollectionBlock:(void (^)(id key, id obj, NSIndexPath * indexPath, BOOL *stop))keyedCollectionBlock
{
    NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:NULL length:0];
    [self visitCollection:collection withIndexedCollectionBlock:indexedCollectionBlock withKeyedCollectionBlock:keyedCollectionBlock fromIndexPath:indexPath];
}

#pragma mark Filtering

+ (id) recursivelyFilterCollection:(id)collection withKeyValueValidationBlock:(BKKeyValueValidationBlock)validationBlock
{
    collection = [self recursiveMutable:collection];
    
    [self recursivelyFilterMutableCollection:collection withKeyValueValidationBlock:validationBlock];
    
    return collection;
}

+ (void) recursivelyFilterMutableCollection:(id)collection withKeyValueValidationBlock:(BKKeyValueValidationBlock)validationBlock
{
    if([collection isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary * dictionary = (NSMutableDictionary *) collection;
        [dictionary performReject:validationBlock];
    }
    
    if([collection respondsToSelector:@selector(enumerateObjectsUsingBlock:)])
    {
        [collection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [BGCollectionUtilities recursivelyFilterMutableCollection:obj withKeyValueValidationBlock:validationBlock];
        }];
    }
    else if([collection respondsToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)])
    {
        [collection enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [BGCollectionUtilities recursivelyFilterMutableCollection:obj withKeyValueValidationBlock:validationBlock];
        }];
    }
}


+ (id) recursivelyFilterCollection:(id)collection byRejecting:(NSArray *)rejectionArray
{
    return [self recursivelyFilterCollection:collection withKeyValueValidationBlock:^BOOL(id key, id obj) {
        return !([collection containsObject:key]);
    }];
}

+ (id) recursivelyFilterCollection:(id)collection byAccepting:(NSArray *)rejectionArray
{
    return [self recursivelyFilterCollection:collection withKeyValueValidationBlock:^BOOL(id key, id obj) {
        return [collection containsObject:key];
    }];
}

@end
