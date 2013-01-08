//
//  BGNanoDataStore.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 06/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGNanoDataStore.h"
#import "BlocksKit.h"
#import "BGNanoStoreHelpers.h"
#import "BGLibraryMacros.h"
#import "NSException+BGHelepers.h"

NSString * const kBGDataStoreLargeFilePathKey = @"__BGDataStoreLargeFilePathKey__";

extern inline NSString * BGNanoDataStoreLargeDataDirectory()
{
    static NSString * mBGNanoDataStoreLargeDataDirectory = nil;
    
    if(!mBGNanoDataStoreLargeDataDirectory)
    {
        mBGNanoDataStoreLargeDataDirectory = [BGDataStoreDirectory() stringByAppendingPathComponent:@"data/"];
    }
    return mBGNanoDataStoreLargeDataDirectory;
}

inline NSString * BGNanoDataStoreDatabasePath()
{
    static NSString * mBGNanoDataStoreDatabasePath = nil;
    if(!mBGNanoDataStoreDatabasePath)
    {
        mBGNanoDataStoreDatabasePath = [BGDataStoreDirectory() stringByAppendingPathComponent:@"NanoStore.database"];
    }
    return mBGNanoDataStoreDatabasePath;
}

extern inline NSString * BGDataStoreLargeDataFilePath(id key)
{
    return [BGNanoDataStoreLargeDataDirectory() stringByAppendingPathComponent:BGDataStoreKey(key)];
}

@implementation BGNanoDataStore
{
    NSCache * _cache;
    NSFNanoStore * _store;
    NSFileManager * _fileManager;    
}

+ (instancetype) sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        BGNanoDataStore * instance = [[self alloc] init];
        return instance;
    });
}

- (id) init
{
    if(self = [super init])
    {
        _cache = [[NSCache alloc] init];
        _fileManager = [NSFileManager defaultManager];
        
        NSError * error = nil;
        
        BOOL result = [_fileManager createDirectoryAtPath:BGDataStoreDirectory()
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
        
        BGRaiseIfError(error);
        
        result = [_fileManager createDirectoryAtPath:BGNanoDataStoreLargeDataDirectory()
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:&error];
        
        BGRaiseIfError(error);
        
        _store = [NSFNanoStore createAndOpenStoreWithType:NSFPersistentStoreType
                                                     path:[BGDataStoreDirectory() stringByAppendingPathComponent:@"NanoStore.database"]
                                                    error:&error];
        
        BGRaiseIfError(error);
    }
    return self;
}

#pragma mark - Access the underlying data

- (NSFNanoStore *) nanoStore
{
    return _store;
}


- (NSCache *) cache
{
    return _cache;
}

- (NSFileManager *) fileManager
{
    return _fileManager;
}


#pragma mark Subscripting Support

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey
{
    [self setObject:object forKey:(NSString *)aKey];
}

#pragma mark - NSData Based

- ( BKReturnBlock ) dateDataStoreGetterForKey:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return nil;
    }
    
    
    BKReturnBlock dataStoreGetter = ^id{
        NSFNanoObject * result = BGSearchReturnSingleNano([self searchForKey:key]);
        if(result)
        {
            NSDate * date = [result objectForKey:kBGDataStoreDateKey];
            
            if(date)
            {
                return date;
            }
        }
        
        return [NSNull null];
    };
    
    return dataStoreGetter;
}

- ( BKReturnBlock ) dataStoreGetterForKey:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return nil;
    }
    
    BKReturnBlock dataStoreGetter = ^id{
        NSFNanoObject * nanoObject = BGSearchReturnSingleNano([self searchForKey:key]);
        
        if([nanoObject objectForKey:kBGDataStorePayloadKey] != nil)
        {
            return [nanoObject objectForKey:kBGDataStorePayloadKey];
        }
        else if([nanoObject objectForKey:kBGDataStoreLargeFilePathKey] != nil)
        {
            NSString * filePath = [nanoObject objectForKey:kBGDataStoreLargeFilePathKey];
            NSData * data = [NSData dataWithContentsOfFile:filePath];
            if(data)
            {
                return data;
            }
        }
        else if([nanoObject objectForKey:kBGDataStoreURLKey] != nil)
        {
            NSString * urlString = [nanoObject objectForKey:kBGDataStoreURLKey];
            NSURL * url = [NSURL URLWithString:urlString];
            if(url)
            {
                return url;
            }
        }
        else if(nanoObject != nil)
        {
            [nanoObject removeObjectForKey:kBGDataStoreDateKey];
            [nanoObject removeObjectForKey:kBGDataStoreKey];
            NSDictionary * result = [nanoObject dictionaryRepresentation];
            return result;
        }
        
        return [NSNull null];
    };
    
    return dataStoreGetter;
}


- (id) objectForKey:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return nil;
    }
    
    id ret = nil;
    BKReturnBlock dataStoreGetter = [self dataStoreGetterForKey:key];
    if(BGIsNull(_cache))
    {
        ret = [_cache objectForKey:key withGetter:dataStoreGetter];
    }
    else
    {
        ret = dataStoreGetter();
    }
    
    if([ret isEqual:[NSNull null]])
        return nil;
    
    return ret;
}

- (void) setObject:(id)value forKey:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return;
    }
    
    if(BGIsNull(value))
    {
        [self removeObjectForKey:key];
        return;
    }
    
    NSDate * cacheDate = [NSDate date];
    
    if(_cache)
    {
        [_cache setObject:value forKey:key];
        [_cache setObject:cacheDate forKey:BGDataStoreCacheDateKey(key)];
    }
    
    //Setup Nano Object
    NSFNanoObject * object = BGSearchReturnSingleNano([self searchForKey:key]);
    if(object)
    {
        [object removeAllObjects];
    }
    else
    {
        object = [NSFNanoObject nanoObject];
    }
    [object setObject:key forKey:kBGDataStoreKey];
    [object setObject:@([cacheDate timeIntervalSince1970]) forKey:kBGDataStoreDateKey];
    
    
    // Add Payload
    // If it's a dictionary it can just be added to the NanoObject
    if([value isKindOfClass:NSDictionary.class])
    {
        [object addEntriesFromDictionary:value];
    }
    else if([value isKindOfClass:NSData.class])
    {
        // If it is data, we should store int in a file.
        // SQLIte can take NSData but it isnt suited to large files
        // We should restrict really small globs for this since it is quicker than file i/o
        NSData * data = (NSData *) value;
        
        // Encrypt data if necessary
#ifdef BGDataStoreCryptKey
#endif
        
        if (data.length > 2048)
        {
            NSString * filePath = BGDataStoreLargeDataFilePath(key);
            NSError * error;
            BOOL result = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
            if(result)
            {
                [object setObject:filePath forKey:kBGDataStoreLargeFilePathKey];
            }
            else
            {
                BGDebugLog(@"Failed to write data %@ with key %@ to store", data, key);
                object = nil;
            }
        }
        // Otherwise store it in Sqlite
        else
        {
            [object setObject:value forKey:kBGDataStorePayloadKey];
        }
        
    }
    // URLS need to be archived correctly
    else if([value isKindOfClass:NSURL.class])
    {
        NSString * stringRepresentation = [(NSURL *)value absoluteString];
        [object setObject:stringRepresentation forKey:kBGDataStoreURLKey];
    }
    // Attempt to store the object in the NSFNanoObject. Restricted to type
    else
    {
        [object setObject:value forKey:kBGDataStorePayloadKey];
    }
    
    // Only proceed if the object exists, can be removed if there are data integrity issues
    if(object)
    {
        NSError * error = nil;
        BOOL saveResult = [_store addObject:object error:&error];
        if(error || saveResult == NO)
        {
            BGDebugLog(@"Error %@ saving object %@ to store", error, object);
        }
    }
}

- (NSDate *) dateOfObject:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return nil;
    }
    
    BKReturnBlock dataStoreGetter = [self dateDataStoreGetterForKey:key];
    id ret = nil;
    if(_cache)
    {
        ret = [_cache objectForKey:key withGetter:dataStoreGetter];
    }
    else
    {
        ret = dataStoreGetter();
    }
    
    if([ret isEqual:[NSNull null]])
    {
        return nil;
    }
    else if([ret isKindOfClass:[NSNumber class]])
    {
        ret = [NSDate dateWithTimeIntervalSince1970:[ret doubleValue]];
    }
    
    return ret;
}

- (void) removeObjectForKey:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return;
    }
    
    if(_cache)
    {
        [_cache removeObjectForKey:key];
        [_cache removeObjectForKey:BGDataStoreCacheDateKey(key)];
    }
    
    NSFNanoObject * nanoObject = BGSearchReturnSingleNano([self searchForKey:key]);
    
    NSError * error = nil;
    
    //Cleanup
    if([nanoObject objectForKey:kBGDataStoreLargeFilePathKey])
    {
        NSString * localFilePath = [nanoObject objectForKey:kBGDataStoreLargeFilePathKey];
        [_fileManager removeItemAtPath:localFilePath error:&error];
    }
    
    [_store removeObject:nanoObject error:&error];
    return;
}


- (BOOL) hasObjectForKey:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return NO;
    }
    
    id object = nil;
    BKReturnBlock dataStoreGetter = [self dataStoreGetterForKey:key];
    if(_cache)
    {
        object = [_cache objectForKey:key withGetter:dataStoreGetter];
    }
    else
    {
        object = dataStoreGetter();
    }
    
    // If object exists we are all good
    if(BGNotNull(object))
    {
        return YES;
    }
    
    return NO;
}


#pragma mark - Private Methods

- (NSFNanoSearch *) searchForKey:(id)key
{
    key = BGDataStoreKey(key);
    if(BGIsNull(key))
    {
        return nil;
    }
    
    NSFNanoSearch * search = [NSFNanoSearch searchWithStore:_store];
    search.attribute = kBGDataStoreKey;
    search.match = NSFEqualTo;
    search.value = key;
    
    return search;
}

@end
