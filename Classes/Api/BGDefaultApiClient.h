//
//  BGMagazineClient.h
//  Magazine
//
//  Created by Lawrence Lomax on 17/09/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "AFNetworking.h"
#import "BGWebDataStore.h"

#pragma mark - Custom Http Client for setting baseURL

@interface BGDefaultHttpClient : AFHTTPClient

@property(nonatomic, strong, readwrite) NSURL * baseURL;
@property(nonatomic, strong, readwrite) NSString * basePath;
@property(nonatomic, strong, readwrite) NSDictionary * defaultParameters;

@end

#pragma mark - Defines of Macros and Types

// Custom Blocks, success failure only, no operation
typedef void (^BGRequestCompletionBlock)(BOOL success);
typedef void (^BGRequestSuccessBlock)(id data);
typedef void (^BGRequestFailureBlock)(NSError * error, id data);
typedef BOOL (^BGCachedDataBlock)(NSDate * cacheDate, id cachedData);

// Normal Request
typedef void (^AFSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^AFDownloadProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

// JSON Request
typedef void (^AFJSONSuccessBlock) (NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
typedef void (^AFJSONFailureBlock) (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);

// Streaming Data Request
typedef void (^BGDataDownloadSuccessBlock) (AFHTTPRequestOperation * operation, NSURL * localUrl);
typedef void (^BGDataDownloadFailureBlock) (AFHTTPRequestOperation * operation, NSError * error);
typedef void (^BGDownloadProgressBlock) (float progress);

#pragma mark - Objective-C Client

@interface BGDefaultApiClient : NSObject

#pragma mark Designated Initialiser

+ (instancetype) sharedInstance;

#pragma mark JSON Requests

- (AFHTTPRequestOperation *) getJSON:(NSString *)path parameters:(NSDictionary *)parameters cache:(BGCachedDataBlock)cache success:(AFJSONSuccessBlock)success failure:(AFJSONFailureBlock)failure finished:(BGRequestCompletionBlock)finished;

#pragma mark Downloading Data Resources

- (AFHTTPRequestOperation *) getResource:(NSURL *)url cachedData:(BGCachedDataBlock)cachedData success:(BGDataDownloadSuccessBlock)success failure:(BGDataDownloadFailureBlock)failure downloadProgress:(BGDownloadProgressBlock)progress finished:(BGRequestCompletionBlock)finished;

- (void) getResourceAtRelativePath:(NSString *)path cachedData:(BGCachedDataBlock)cachedData success:(BGDataDownloadSuccessBlock)success failure:(BGDataDownloadFailureBlock)failure downloadProgress:(BGDownloadProgressBlock)progress finished:(BGRequestCompletionBlock)finished;

- (AFHTTPRequestOperation *) getCompressedResource:(NSURL *)url cachedData:(BGCachedDataBlock)cachedData success:(BGDataDownloadSuccessBlock)success failure:(BGDataDownloadFailureBlock)failure downloadProgress:(BGDownloadProgressBlock)progress extract:(BGExtractDataBlock)extract finished:(BGRequestCompletionBlock)finished;

#pragma mark Helpers

- (NSURL *) fullUrlFromPath:(NSString *)path;

#pragma mark Exposing Internal Properties

@property (nonatomic, readonly, strong) BGDefaultHttpClient * httpClient;

@end
