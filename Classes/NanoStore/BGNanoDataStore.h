//
//  BGNanoDataStore.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 06/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BGNanoStoreHelpers.h"
#import "BGDataStore.h"
#import "NanoStore.h"


extern NSString * const kBGDataStoreLargeFilePathKey;

extern inline NSString * BGNanoDataStoreLargeDataDirectory();
extern inline NSString * BGDataStoreLargeDataFilePath(id key);

@interface BGNanoDataStore : NSObject<BGDataStore>

@property (nonatomic, readonly) NSFNanoStore * nanoStore;
@property (nonatomic, readonly) NSCache * cache;
@property (nonatomic, readonly) NSFileManager * fileManager;

@end
