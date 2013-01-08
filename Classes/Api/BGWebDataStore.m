//
//  BGWebDataStore.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGWebDataStore.h"

#pragma mark - C

NSArray * BGWebDataStoreClassNames = nil;

extern inline NSString * BGDataStoreIncompleteDirectory()
{
    static NSString * mBGDataStoreIncompleteDirectory = nil;
    
    if(!mBGDataStoreIncompleteDirectory)
    {
        mBGDataStoreIncompleteDirectory = [BGDataStoreDirectory() stringByAppendingPathComponent:@"incomplete/"];
    }
    return mBGDataStoreIncompleteDirectory;
}

extern inline NSString * BGDataStoreCompleteDirectory()
{
    static NSString * mBGDataStoreCompleteDirectory = nil;
    
    if(!mBGDataStoreCompleteDirectory)
    {
        mBGDataStoreCompleteDirectory = [BGDataStoreDirectory() stringByAppendingPathComponent:@"complete/"];
    }
    return mBGDataStoreCompleteDirectory;
}

extern inline NSString * BGDataStoreIncompletePathForKey(NSString * key)
{
    return [BGDataStoreIncompleteDirectory() stringByAppendingPathComponent:key];
}

extern inline NSString * BGDataStoreCompletePathForKey(NSString * key)
{
    return [BGDataStoreCompleteDirectory() stringByAppendingPathComponent:key];
}

extern inline NSString * BGDataStoreCompletePathForRemoteURL(NSURL * url)
{
    return BGDataStoreCompletePathForKey(BGDataStoreKey(url));
}

extern inline NSString * BGDataStoreIncompletePathForRemoteURL(NSURL * url)
{
    return BGDataStoreIncompletePathForKey(BGDataStoreKey(url));
}

extern id<BGWebDataStore> BGWebDataStoreGet()
{
    if(!BGWebDataStoreClassNames)
    {
        BGWebDataStoreClassNames = @[@"BGNanoWebDataStore", @"BGFileWebDataStore"];
    }
    
    static id instance = nil;
    if(!instance)
    {
        [BGWebDataStoreClassNames enumerateObjectsUsingBlock:^(NSString * className, NSUInteger idx, BOOL *stop) {
            if(NSClassFromString(className))
            {
                instance = [NSClassFromString(className) sharedInstance];
                *stop = YES;
            }
        }];
    }
    
    return instance;
}


