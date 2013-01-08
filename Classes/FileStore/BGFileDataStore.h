//
//  BGFileDataStore.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 06/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGDataStore.h"

extern inline NSString * BGFileDataStorePayloadDirectory();
extern inline NSString * BGFileDataStorePayloadFilePath(id key);

@interface BGFileDataStore : NSObject<BGDataStore>

@property (nonatomic, readonly) NSCache * cache;
@property (nonatomic, readonly) NSFileManager * fileManager;

@end
