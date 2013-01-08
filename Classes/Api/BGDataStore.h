//
//  BGStore.h
//  BGMagazine
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Protocol Definition

@protocol BGDataStore <NSObject>

+ (instancetype) sharedInstance;

#pragma mark Subscripting Support

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey;

#pragma mark Key Value Store

- (void) setObject:(id)value forKey:(id)key;
- (id) objectForKey:(id)key;

- (NSDate *) dateOfObject:(id)key;

- (void) removeObjectForKey:(id)key;
- (BOOL) hasObjectForKey:(id)key;

@end

#pragma mark - C Level

extern NSArray * BGDataStoreClassNames;

extern NSString * const kBGDataStoreKey;
extern NSString * const kBGDataStorePayloadKey;
extern NSString * const kBGDataStoreURLKey;
extern NSString * const kBGDataStoreDateKey;

extern inline NSString * BGDataStoreDirectory();
extern inline NSString * BGDataStoreKey(id key);
extern inline NSString * BGDataStoreCacheDateKey(id key);

#pragma mark Convenience Accessor

extern id<BGDataStore> BGDataStoreGet();

