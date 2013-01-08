//
//  BGWebDataStore.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGDataStore.h"

extern NSArray * BGWebDataStoreClassNames;

// Extracting local data
typedef void (^BGExtractDataBlock) (float progress, BOOL finished, BOOL success);

@protocol BGWebDataStore <BGDataStore>

#pragma mark Arbitrary Data

- (NSOutputStream *) outputStreamForRemoteUrl:(NSURL *)url;
- (NSURL *) commitStreamResult:(BOOL)success outputStream:(NSOutputStream *)stream remoteUrl:(NSURL *)url;
- (NSURL *) localDataUrlForRemoteUrl:(NSURL *)url;
- (NSURL *) localDataUrlForRemoteUrl:(NSURL *)url withPath:(NSString *)path;

#pragma mark Compressed Data

- (NSURL *) extractZipFileWithRemoteUrl:(NSURL *)remoteUrl progressCallback:(BGExtractDataBlock)progressCallback;

@end

#pragma mark C

extern inline NSString * BGDataStoreCompleteDirectory();
extern inline NSString * BGDataStoreIncompleteDirectory();
extern inline NSString * BGDataStoreCompletePathForKey(NSString * key);
extern inline NSString * BGDataStoreIncompletePathForKey(NSString * key);
extern inline NSString * BGDataStoreCompletePathForRemoteURL(NSURL * url);
extern inline NSString * BGDataStoreIncompletePathForRemoteURL(NSURL * url);

extern id<BGWebDataStore> BGWebDataStoreGet();

#pragma mark Objective-C

