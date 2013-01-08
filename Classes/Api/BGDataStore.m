//
//  BGStore.m
//  BGMagazine
//
//  Created by Lawrence Lomax on 23/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGDataStore.h"
#import "BlocksKit.h"
#import "BGLibraryMacros.h"
#import "NSString+SSToolkitAdditions.h"


NSArray * BGDataStoreClassNames = nil;

NSString * const kBGDataStoreKey = @"__BGDataStoreKey__";
NSString * const kBGDataStorePayloadKey = @"__BGDataStorePayloadKey__";
NSString * const kBGDataStoreURLKey = @"__BGDataStoreURLKey__";
NSString * const kBGDataStoreDateKey = @"__BGDataStoreDateKey__";


extern inline NSString * BGDataStoreDirectory()
{
    static NSString * mBGDataStoreDirectory = nil;
    
	if(!mBGDataStoreDirectory)
    {
		mBGDataStoreDirectory = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
        mBGDataStoreDirectory = [mBGDataStoreDirectory stringByAppendingPathComponent:@"BGDataStore"];
	}
	
	return mBGDataStoreDirectory;
}

extern inline NSString * BGDataStoreKey(id key)
{
    if([key isKindOfClass:[NSString class]])
    {
        return (NSString *)key;
    }
    else if([key isKindOfClass:[NSURL class]])
    {
        NSString * newKey = [[key absoluteString] base64EncodedString];
        if([key pathExtension] != nil && [[key pathExtension] length] > 0)
        {
            newKey = [newKey stringByAppendingFormat:@".%@", [key pathExtension]];
        }
        return newKey;
    }
    else
    {
        return nil;
    }
}

extern inline NSString * BGDataStoreCacheDateKey(id key)
{
    NSString * cacheDateKey = [NSString stringWithFormat:@"%@_%@", kBGDataStoreDateKey, BGDataStoreKey(key)];
    return cacheDateKey;
}

extern id<BGDataStore> BGDataStoreGet()
{
    if(!BGDataStoreClassNames)
    {
        BGDataStoreClassNames = @[@"BGNanoDataStore", @"BGFileDataStore"];
    }

    static id instance = nil;
    if(!instance)
    {
        [BGDataStoreClassNames enumerateObjectsUsingBlock:^(NSString * className, NSUInteger idx, BOOL *stop) {
            if(NSClassFromString(className))
            {
                instance = [NSClassFromString(className) sharedInstance];
                *stop = YES;
            }
        }];
    }
    
    return instance;
}

