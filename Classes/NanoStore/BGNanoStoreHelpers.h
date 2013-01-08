//
//  BGNanoStoreHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NanoStore.h"

#pragma mark - Inline Helpers

extern inline NSArray * BGDictionaryArrayToNano(NSArray * dictionaryArray);
extern inline NSArray * BGResultsToDicitionaryArray(NSDictionary * searchResults);
extern inline NSUInteger BGSearchReturnCount(NSFNanoSearch * search);
extern inline NSArray * BGSearchReturnMulti(NSFNanoSearch * search);
extern inline NSArray * BGSearchReturnMultiNano(NSFNanoSearch * search);
extern inline NSDictionary * BGSearchReturnSingle(NSFNanoSearch * search);
extern inline NSFNanoObject * BGSearchReturnSingleNano(NSFNanoSearch * search);
extern inline NSFNanoPredicate * BGColumnPredicate(NSString * key);
extern inline NSFNanoPredicate * BGValuePredicate(id value, NSFMatchType matchType);
extern inline void BGExpressionAppendAndPredicate(NSFNanoExpression * expression, NSString * key, id value, NSFMatchType matchType);
extern inline void BGSearchAppendAndPredicate(NSFNanoSearch * search, NSString * key, id value, NSFMatchType matchType);

NS_REQUIRES_NIL_TERMINATION extern  inline NSFNanoSearch * BGSearchWithPredicates(NSFNanoStore * store, NSFNanoPredicate * predicates, ...);

@interface BGNanoStoreHelpers : NSObject

+ (void) enumerateSearch:(NSFNanoSearch *)search withBlock:(void (^)(NSString *, NSFNanoObject *, NSUInteger))block;
+ (void) deleteFromSearch:(NSFNanoSearch *)search;

@end
