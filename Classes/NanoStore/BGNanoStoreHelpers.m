//
//  BGNanoStoreHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGNanoStoreHelpers.h"

#pragma mark - Inline Helpers

inline NSArray * BGDictionaryArrayToNano(NSArray * dictionaryArray)
{
    NSMutableArray * arrayOut = [NSMutableArray arrayWithCapacity:dictionaryArray.count];
    [dictionaryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [arrayOut addObject:[NSFNanoObject nanoObjectWithDictionary:obj]];
    }];
    
    return arrayOut;
}

inline NSArray * BGResultsToDicitionaryArray(NSDictionary * searchResults)
{
    NSMutableArray * arrayOut = [NSMutableArray arrayWithCapacity:searchResults.count];
    [searchResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [arrayOut addObject:[obj dictionaryRepresentation]];
    }];
    return arrayOut;
}

inline NSUInteger BGSearchReturnCount(NSFNanoSearch * search)
{
    NSError * error = nil;
    NSDictionary * results = [search searchObjectsWithReturnType:NSFReturnKeys error:&error];
    
    return results.count;
}

inline NSArray * BGSearchReturnMulti(NSFNanoSearch * search)
{
    NSError * error = nil;
    NSDictionary * results = [search searchObjectsWithReturnType:NSFReturnObjects error:&error];
    if(results.count)
    {
        return BGResultsToDicitionaryArray(results);
    }
    
    return [NSArray array];
}

inline NSArray * BGSearchReturnMultiNano(NSFNanoSearch * search)
{
    NSError * error = nil;
    NSDictionary * results = [search searchObjectsWithReturnType:NSFReturnObjects error:&error];
    if(results.count)
    {
        return [results allValues];
    }
    
    return [NSArray array];
}

inline NSDictionary * BGSearchReturnSingle(NSFNanoSearch * search)
{
    NSError * error = nil;
    NSDictionary * results = [search searchObjectsWithReturnType:NSFReturnObjects error:&error];
    if(results.count)
    {
        return [[[results allValues] objectAtIndex:0] dictionaryRepresentation];
    }
    
    return nil;
}

inline NSFNanoObject * BGSearchReturnSingleNano(NSFNanoSearch * search)
{
    NSError * error = nil;
    NSDictionary * results = [search searchObjectsWithReturnType:NSFReturnObjects error:&error];
    if(results.count)
    {
        return [[results allValues] objectAtIndex:0];
    }
    
    return nil;
}

inline NSFNanoPredicate * BGColumnPredicate(NSString * key)
{
    NSFNanoPredicate * columnPredicate = [NSFNanoPredicate predicateWithColumn:NSFAttributeColumn matching:NSFEqualTo value:key];
    return columnPredicate;
}

inline NSFNanoPredicate * BGValuePredicate(id value, NSFMatchType matchType)
{
    NSFNanoPredicate * valuePredicate = [NSFNanoPredicate predicateWithColumn:NSFValueColumn matching:matchType value:value];
    return valuePredicate;
}

inline void BGExpressionAppendAndPredicate(NSFNanoExpression * expression, NSString * key, id value, NSFMatchType matchType)
{
    NSFNanoPredicate * columnPredicate = BGColumnPredicate(key);
    NSFNanoPredicate * valuePredicate = BGValuePredicate(value, matchType);
    
    [expression addPredicate:columnPredicate withOperator:NSFAnd];
    [expression addPredicate:valuePredicate withOperator:NSFAnd];
}


inline void BGSearchAppendAndPredicate(NSFNanoSearch * search, NSString * key, id value, NSFMatchType matchType)
{
    NSFNanoExpression * expression = [search.expressions objectAtIndex:0];
    BGExpressionAppendAndPredicate(expression, key, value, matchType);
}

NS_REQUIRES_NIL_TERMINATION inline NSFNanoSearch * BGSearchWithPredicates(NSFNanoStore * store, NSFNanoPredicate * predicates, ...)
{
    NSFNanoExpression * expression = nil;
    
    va_list args;
    va_start(args, predicates);
    NSFNanoPredicate * predicate = nil;
    for(predicate = predicates; predicate != nil; predicate = va_arg(args, NSFNanoPredicate *))
    {
        if(expression)
        {
            [expression addPredicate:predicate withOperator:NSFAnd];
        }
        else
        {
            expression = [NSFNanoExpression expressionWithPredicate:predicate];
        }
    }
    va_end(args);
    
    NSFNanoSearch * search = [NSFNanoSearch searchWithStore:store];
    search.expressions = @[ expression ];
    
    return search;
}


@implementation BGNanoStoreHelpers

+ (void) enumerateSearch:(NSFNanoSearch *)search withBlock:(void (^)(NSString *, NSFNanoObject *, NSUInteger))block
{
    NSError * error = nil;
    id results = [search searchObjectsWithReturnType:NSFReturnObjects error:&error];
    
    if([results respondsToSelector:@selector(enumerateRangesWithOptions:usingBlock:)])
    {
        [results enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            block(key, obj, 0);
        }];
    }
}

+ (void) deleteFromSearch:(NSFNanoSearch *)search
{
    NSError * error = nil;
    NSArray * keys = [search searchObjectsWithReturnType:NSFReturnKeys error:&error];
    [search.nanoStore removeObjectsWithKeysInArray:keys error:&error];
}


@end
