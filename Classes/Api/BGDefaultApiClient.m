//
//  BGMagazineClient.m
//  Magazine
//
//  Created by Lawrence Lomax on 17/09/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGDefaultApiClient.h"
#import "BGWebDataStore.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"
#import "BGLibraryMacros.h"

#pragma mark - Custom Private HTTP Client

@implementation BGDefaultHttpClient
{
    __strong NSURL * _baseURL;
    __strong NSString * _basePath;
    __strong NSDictionary * _defaultParameters;
}

#pragma mark - Accessors

- (id) initWithBaseURL:(NSURL *)url
{
    if(!url)
    {
        url = [NSURL URLWithString:@"http://127.0.0.1"];
    }

    if(self = [super initWithBaseURL:url])
    {
        
    }
    return self;
}

- (void) setBaseURL:(NSURL *)baseURL
{
    if ([baseURL isEqual:_baseURL])
    {
        BGDebugLog(@"Http Client base url is set to the same and ignored %@", baseURL);
        return;
    }
    
    _baseURL = baseURL;
    BGDebugLog(@"Http Client sets base URL to %@", baseURL);
}

- (NSURL *) baseURL
{
    return _baseURL;
}

- (void) setBasePath:(NSString *)basePath
{
    _basePath = basePath;
    
    BGDebugLog(@"Http Client sets base path to %@", basePath);
}

- (NSString *) basePath
{
    return _basePath;
}

- (void) setDefaultParameters:(NSDictionary *)defaultParameters
{
    _defaultParameters = defaultParameters;
    
    BGDebugLog(@"Http Client sets base parameters to %@", defaultParameters);
}

- (NSDictionary *) defaultParameters
{
    return _defaultParameters;
}


#pragma mark - Overrides

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    if(_basePath)
    {
        path = [NSString pathWithComponents:@[_basePath, path]];
    }
    if(_defaultParameters)
    {
        NSMutableDictionary * newDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [newDictionary addEntriesFromDictionary:_defaultParameters];
        parameters = [newDictionary copy];
    }
    
    return [super requestWithMethod:method path:path parameters:parameters];
}

- (void) enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
    BGDebugLog(@"Enqueue operation %@", operation);
    
    [super enqueueHTTPRequestOperation:operation];
}

@end


#pragma mark - Client Implementation

@implementation BGDefaultApiClient
{
    __strong BGDefaultHttpClient * _httpClient;
    dispatch_queue_t _processingQueue;
}


#pragma mark - Lifecycle

+ (instancetype) sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        id instance = [[self alloc] init];
        return instance;
    });
}

- (id) init
{
    if(self = [super init])
    {        
        _processingQueue = dispatch_queue_create("com.bellgeorge.processingqueue", DISPATCH_QUEUE_CONCURRENT);
        _httpClient = [[BGDefaultHttpClient alloc] initWithBaseURL:nil];
    }
    return self;
}

#pragma mark - Accessors

- (AFHTTPClient *) httpClient
{
    return _httpClient;
}

#pragma mark - JSON Requests

- (AFHTTPRequestOperation *) getJSON:(NSString *)path parameters:(NSDictionary *)parameters cache:(BGCachedDataBlock)cache success:(AFJSONSuccessBlock)success failure:(AFJSONFailureBlock)failure finished:(BGRequestCompletionBlock)finished
{
    // Make Url Request
    NSURLRequest * urlRequest = [_httpClient requestWithMethod:@"GET" path:path parameters:parameters];
    
    // Proceed with getting data from cache
    if(cache)
    {
        id data = [BGWebDataStoreGet() objectForKey:urlRequest.URL];
        NSDate * date = [BGWebDataStoreGet() dateOfObject:urlRequest.URL];
        if(data && date)
        {
            // Return immediately if the user intercepts the caching to stop the actual request
            if (cache(date, data))
            {
                // Callback now
                if(finished) finished(YES);
                
                // Finish here
                return nil;
            }
        }
    }
    
    // Success Block Definition
    AFJSONSuccessBlock wrappedSuccess = ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON){
        // Commit to cache
        [BGWebDataStoreGet() setObject:JSON forKey:urlRequest.URL];
        
        // Callback
        if(success) success(request, response, JSON);
        
        // Finished Callback
        if(finished) finished(YES);
    };
    
    // Failure Block Definition
    AFJSONFailureBlock wrappedFailure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        // Callback
        if(failure) failure(request, response, error, JSON);
        
        // Finished Callback
        if(finished) finished(NO);
    };
    
    // Start Operation
    AFJSONRequestOperation * operation =  [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:wrappedSuccess failure:wrappedFailure];
    
    [_httpClient enqueueHTTPRequestOperation:operation];
    
    return operation;
}

#pragma mark - Downloading Data Resources

- (void) getResourceAtRelativePath:(NSString *)path cachedData:(BGCachedDataBlock)cachedData success:(BGDataDownloadSuccessBlock)success failure:(BGDataDownloadFailureBlock)failure downloadProgress:(BGDownloadProgressBlock)progress finished:(BGRequestCompletionBlock)finished
{
    // Construct Url
    NSURL * url = [NSURL URLWithString:path relativeToURL:_httpClient.baseURL];
    
    // Construct Resource
    [self getResource:url cachedData:cachedData success:success failure:failure downloadProgress:progress finished:finished];
}

- (AFHTTPRequestOperation *) getResource:(NSURL *)url cachedData:(BGCachedDataBlock)BGCachedDataBlock success:(BGDataDownloadSuccessBlock)successBlock failure:(BGDataDownloadFailureBlock)failureBlock downloadProgress:(BGDownloadProgressBlock)progressBlock finished:(BGRequestCompletionBlock)finished
{
    // Proceed in getting data from cache
    if(BGCachedDataBlock)
    {
        id localUrl = [BGWebDataStoreGet() localDataUrlForRemoteUrl:url];
        NSDate * date = [BGWebDataStoreGet() dateOfObject:url];
        if(localUrl && date)
        {
            // Return immediately if the user intercepts the caching to stop the actual request
            if(BGCachedDataBlock(date, localUrl))
            {
                // Call Completion Block
                if(finished) finished(YES);
                
                // End now
                return nil;
            }
        }
    }
    
    // Make Url Request
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    // Make Output Stream
    NSOutputStream * outputStream = [BGWebDataStoreGet() outputStreamForRemoteUrl:request.URL];
    
    BGDataDownloadSuccessBlock wrappedSuccess = ^(AFHTTPRequestOperation * operation, id responseObject) {
        // Commit Stream Result
        NSURL * localUrl = [BGWebDataStoreGet() commitStreamResult:YES outputStream:outputStream remoteUrl:request.URL];
        // Callback
        if(successBlock) successBlock(operation, localUrl);
        
        // Call Completion Block
        if(finished) finished(YES);
    };
    
    BGDataDownloadFailureBlock wrappedFailure = ^(AFHTTPRequestOperation * operation, NSError * error) {
        // Commit Stream Result
        [BGWebDataStoreGet() commitStreamResult:NO outputStream:outputStream remoteUrl:request.URL];
        // Callback
        if(failureBlock) failureBlock(operation, error);
        
        // Call Completion Block
        if(finished) finished(NO);
    };
    
    
    // Download Progress Callback
    __block float progress = -1.0f;
    AFDownloadProgressBlock progressWrapper = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float nextProgress = (float)((double) totalBytesRead / (double)totalBytesExpectedToRead);
        if(nextProgress > progress)
        {
            progress = nextProgress;
            progressBlock(progress);
        }
    };
    
    
    // Make Request Operation and set callback blocks and output stream
    AFHTTPRequestOperation * requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:wrappedSuccess failure:wrappedFailure];
    requestOperation.outputStream = outputStream;
    [requestOperation setDownloadProgressBlock:progressWrapper];
    
    // Enqueue Request
    [_httpClient enqueueHTTPRequestOperation:requestOperation];
    
    return requestOperation;
}

- (AFHTTPRequestOperation *) getCompressedResource:(NSURL *)url cachedData:(BGCachedDataBlock)cachedData success:(BGDataDownloadSuccessBlock)success failure:(BGDataDownloadFailureBlock)failure downloadProgress:(BGDownloadProgressBlock)progress extract:(BGExtractDataBlock)extract finished:(BGRequestCompletionBlock)finished
{
    dispatch_queue_t callbackQueue = dispatch_get_current_queue();
    
    BGDataDownloadSuccessBlock successWrapper = ^(AFHTTPRequestOperation * operation, NSURL * localUrl){
        dispatch_async(_processingQueue, ^{
            NSURL * extractDirURL = [BGWebDataStoreGet() extractZipFileWithRemoteUrl:url progressCallback:extract];
            
            dispatch_async(callbackQueue  , ^{
                BOOL successResult = (extractDirURL) ? YES : NO;
                BOOL finishedResult = YES;
                float progressResult = 1.0f;
                
                extract(successResult, finishedResult, progressResult);
                
                // Wrapped Success Callback
                if(success) success(operation, extractDirURL);
                
                // Completion Callback
                if(finished) finished(YES);
            });
        });
    };
    
    BGDataDownloadFailureBlock failureWrapper = ^(AFHTTPRequestOperation * operation, NSError * error){
        // Wrapped Failure Callback
        if(failure) failure(operation, error);
        
        // Completion Callback
        if(finished) finished(NO);
    };
    
    // Call original with wrapped success block
    // Pass nil for failure block to prevent callback before compress finished
    return [self getResource:url cachedData:cachedData success:successWrapper failure:failureWrapper downloadProgress:progress finished:nil];
}

#pragma mark Get URLS

- (NSURL *) fullUrlFromPath:(NSString *)path
{
    return [NSURL URLWithString:path relativeToURL:_httpClient.baseURL];
}



@end
