//
//  BGCoreDataStore.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 04/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGCoreDataStore.h"

inline NSString * BGCoreDataStoreDatabasePath()
{
    static NSString * mBGCoreDataStoreDatabasePath = nil;
    if(!mBGCoreDataStoreDatabasePath)
    {
        mBGCoreDataStoreDatabasePath = [BGDataStoreDirectory() stringByAppendingPathComponent:@"CoreDataStore.database"];
    }
    return mBGCoreDataStoreDatabasePath;
}


@implementation BGCoreDataStore

#pragma mark Explicit Initializer

- (id) init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

+ (id<BGDataStore>) sharedDataStore
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^(){
        id instance = [[self alloc] init];
        return instance;
    });
}

#pragma mark Subscripting Support

- (id)objectForKeyedSubscript:(id)key
{
    
}


- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey
{
    
}

#pragma mark Key Value Store

- (void) setObject:(id)value forKey:(id)key
{
    
}


- (id) objectForKey:(id)key
{
    
}

- (NSDate *) dateOfObject:(id)key
{
    
}


- (void) removeObjectForKey:(id)key
{
    
}


- (BOOL) hasObjectForKey:(id)key
{
    
}

@end
