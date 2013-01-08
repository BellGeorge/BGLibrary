//
//  BGFileWebDataStore.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 06/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGNanoWebDataStore.h"
#import "BGLibraryMacros.h"
#import "SSZipArchive.h"

@interface BGConcreteZipDelegate : NSObject<SSZipArchiveDelegate>

@property(nonatomic, strong) BGExtractDataBlock extractBlock;

@end

@implementation BGConcreteZipDelegate

- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo
{
    float fileProgress = (float)((float)fileIndex / (float)totalFiles);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _extractBlock(fileProgress, NO, YES);
    });
}

@end

@implementation BGNanoWebDataStore


+ (id<BGWebDataStore>) sharedWebDataStore
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        BGNanoWebDataStore * instance = [[self alloc] init];
        return instance;
    });
}


- (id) init
{
    if(self = [super init])
    {
        NSError * error = nil;
        
        [self.fileManager createDirectoryAtPath:BGDataStoreIncompleteDirectory()
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error];
        
        [self.fileManager createDirectoryAtPath:BGDataStoreCompleteDirectory()
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error];
        
    }
    return self;
}

#pragma mark - Data and Streaming

- (NSURL *) commitStreamResult:(BOOL)success outputStream:(NSOutputStream *)stream remoteUrl:(NSURL *)remoteUrl
{
    // Close Stream and reallocate resources
    [stream close];
    
    NSString * incompletePath = BGDataStoreIncompletePathForRemoteURL(remoteUrl);
    NSURL * incompleteUrl = [NSURL fileURLWithPath:incompletePath];
    NSURL * completeUrl = nil;
    
    NSError * error = nil;
    if(![incompleteUrl checkResourceIsReachableAndReturnError:&error])
    {
        return nil;
    }
    else if(success)
    {
        NSString * completePath = BGDataStoreCompletePathForRemoteURL(remoteUrl);
        completeUrl = [NSURL fileURLWithPath:completePath];
        
        // Delete existing before moving
        if([completeUrl checkResourceIsReachableAndReturnError:&error])
        {
            [[NSFileManager defaultManager] removeItemAtURL:completeUrl error:nil];
        }
        
        BOOL success = [[NSFileManager defaultManager] moveItemAtURL:incompleteUrl toURL:completeUrl error:&error];
        if(success)
        {
            [self setObject:completePath forKey:remoteUrl];
        }
        else
        {
            completeUrl = nil;
        }
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:incompleteUrl error:&error];
    
    return completeUrl;
}

- (NSOutputStream *) outputStreamForRemoteUrl:(NSURL *)url
{
    NSString * path = BGDataStoreIncompletePathForRemoteURL(url);
    NSURL * localUrl = [NSURL fileURLWithPath:path];
    NSOutputStream * outputStream = [NSOutputStream outputStreamWithURL:localUrl append:NO];
    return outputStream;
}


- (NSURL *) localDataUrlForRemoteUrl:(NSURL *)remoteUrl
{
    NSString * path = BGDataStoreCompletePathForRemoteURL(remoteUrl);
    NSURL * localUrl = [NSURL fileURLWithPath:path];
    NSError * error = nil;
    BOOL exists = [localUrl checkResourceIsReachableAndReturnError:&error];
    
    if(exists)
        return localUrl;
    
    return nil;
}

- (NSURL *) localDataUrlForRemoteUrl:(NSURL *)url withPath:(NSString *)path
{
    NSURL * localUrl = [self localDataUrlForRemoteUrl:url];
    if(localUrl)
    {
        localUrl = [localUrl URLByAppendingPathComponent:path];
        
        NSError * error = nil;
        BOOL reachable = [localUrl checkResourceIsReachableAndReturnError:&error];
        if(reachable)
            return localUrl;
    }
    
    return nil;
}


- (NSURL *) localUnzippedDirectoryUrlForRemoteUrl:(NSURL *)remoteUrl
{
    NSURL * localUrl = [self localDataUrlForRemoteUrl:remoteUrl];
    localUrl = [localUrl URLByDeletingPathExtension];
    
    NSString * directoryName = [localUrl lastPathComponent];
    directoryName = [directoryName stringByAppendingString:@"__unzipped"];
    
    localUrl = [localUrl URLByDeletingLastPathComponent];
    localUrl = [localUrl URLByAppendingPathComponent:directoryName isDirectory:YES];
    
    return localUrl;
}


#pragma mark Zip Files

- (NSURL *) extractZipFileWithRemoteUrl:(NSURL *)remoteUrl progressCallback:(BGExtractDataBlock)progressCallback
{
    NSURL * localUrl = [self localDataUrlForRemoteUrl:remoteUrl];
    NSURL * localUrlUnzipDirectory = [self localUnzippedDirectoryUrlForRemoteUrl:remoteUrl];
    
    //Create Path
    NSError * error = nil;
    BOOL result = [self.fileManager createDirectoryAtURL:localUrlUnzipDirectory
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    
    BAIL_IF_FALSE(result, nil);
    
    BGConcreteZipDelegate * delegate = nil;
    if(progressCallback)
    {
        // Only create delegate if callback exists
        delegate = [[BGConcreteZipDelegate alloc] init];
        delegate.extractBlock = progressCallback;
    }
    
    BOOL ret = [SSZipArchive unzipFileAtPath:[localUrl path]
                               toDestination:[localUrlUnzipDirectory path]
                                   overwrite:YES
                                    password:nil
                                       error:&error
                                    delegate:delegate];
    
    if(ret)
        return localUrlUnzipDirectory;
    
    return nil;
}


@end