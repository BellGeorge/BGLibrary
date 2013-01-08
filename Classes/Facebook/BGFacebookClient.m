//
//  BGFacebookClient.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 19/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGFacebookClient.h"
#import "SSKeychain.h"

static NSString * const kBGFacebookKeychainService = @"kBGFacebookKeychainService";
static NSString * const kBGFacebookKeychainAccountToken = @"kBGFacebookKeychainAccountToken";
static NSString * const kBGFacebookKeychainAccountExpirationDate = @"kBGFacebookKeychainAccountExpirationDate";

@interface BGFacebookClient()

@end

@implementation BGFacebookClient
{
    __strong FBSession * _session;
}

#pragma mark - Set these properties first before instantiating

static __strong NSString * _appId = nil;
static __strong NSString * _urlSchemeSuffix = nil;
static __strong NSArray * _permissions = nil;
static BOOL _hasBeenInstantiated = NO;

+ (void) setAppId:(NSString *)appId
{
    if(_hasBeenInstantiated && ![appId isEqualToString:_appId])
    {
        [NSException raise:@"Do not set the app id after the facebook client has been instantiated" format:nil];
    }
    
    _appId = [appId copy];
    [FBSession setDefaultAppID:_appId];
}

+ (void) setUrlSchemeSuffix:(NSString *)urlSchemeSuffix
{
    if(_hasBeenInstantiated && ![urlSchemeSuffix isEqualToString:_urlSchemeSuffix])
    {
        [NSException raise:@"Do not set the url scheme suffix after the facebook client has been instantiated" format:nil];
    }
    
    _urlSchemeSuffix = [urlSchemeSuffix copy];
}

+ (void) setPermissions:(NSArray *)permissions
{
    if(_hasBeenInstantiated && ![permissions isEqual:_permissions])
    {
        [NSException raise:@"Do not set the permissions suffix after the facebook client has been instantiated" format:nil];
    }
    
    _permissions = [permissions copy];
}

#pragma mark - Initialisation

- (id) init
{
    if(self = [super init])
    {
        /*
        _facebook = [[Facebook alloc] initWithAppId:_appId
                                    urlSchemeSuffix:_urlSchemeSuffix
                                        andDelegate:self];
         */
    }
    return self;
}

+ (BGFacebookClient *) sharedFacebookClient
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^(){
        BGFacebookClient * instance = [[self alloc] init];
        _hasBeenInstantiated = YES;
        return instance;
    });
}

#pragma mark - User Interface

- (void) presentLoginDialogFromViewController:(UIViewController *)viewController
{
    // http://developers.facebook.com/docs/howtos/ios-6/
    
    FBSessionStateHandler handler = ^(FBSession *session, FBSessionState status, NSError *error){
        BGDebugLog(@"Facebook Session state changed to %@", session);
    };
    
    /*
    _session = [[FBSession alloc] initWithAppID:_appId
                                    permissions:_permissions
                                defaultAudience:FBSessionDefaultAudienceEveryone
                                urlSchemeSuffix:_urlSchemeSuffix
                                tokenCacheStrategy:nil];
    _session.

    [FBSession setActiveSession:_session];
    [_session openWithCompletionHandler:handler];
     
     */
    
    [FBSession openActiveSessionWithReadPermissions:@[ @"email" ]
                                       allowLoginUI:YES
                                  completionHandler:handler];
     
}

#pragma mark - Queries

- (BOOL) isLoggedIn
{
    if([FBSession activeSession])
    {
        return [[FBSession activeSession] isOpen];
    }
    return NO;
}

#pragma mark - Graph Requests

- (FBRequestHandler) defaultRequestHandlerContinuation:(FBRequestHandler)requestHandler
{
    FBRequestHandler handler = ^(FBRequestConnection * connection, id result, NSError * error){
        requestHandler(connection, result, error);
    };
    
    return handler;
}


/*#pragma mark - Session Delegate

- (void)fbDidLogin
{
    NSString * token = _facebook.accessToken;
    NSDate * expirationDate = _facebook.expirationDate;
    NSData * expirationDateData = [NSKeyedArchiver archivedDataWithRootObject:expirationDate];
    
    NSError * error = nil;
    [SSKeychain setPassword:token forService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountToken error:&error];
    [SSKeychain setPasswordData:expirationDateData forService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountExpirationDate error:&error];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSError * error = nil;
    [SSKeychain deletePasswordForService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountToken error:&error];
    [SSKeychain deletePasswordForService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountExpirationDate error:&error];
}

- (void)fbDidExtendToken:(NSString * )accessToken expiresAt:(NSDate*)expiresAt
{
    NSData * expirationDateData = [NSKeyedArchiver archivedDataWithRootObject:expiresAt];
    
    NSError * error = nil;
    [SSKeychain setPassword:accessToken forService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountToken error:&error];
    [SSKeychain setPasswordData:expirationDateData forService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountExpirationDate error:&error];
}

- (void)fbDidLogout
{
    NSError * error = nil;
    [SSKeychain deletePasswordForService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountToken error:&error];
    [SSKeychain deletePasswordForService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountExpirationDate error:&error];
}

- (void)fbSessionInvalidated
{
    NSError * error = nil;
    [SSKeychain deletePasswordForService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountToken error:&error];
    [SSKeychain deletePasswordForService:kBGFacebookKeychainService account:kBGFacebookKeychainAccountExpirationDate error:&error];
}

#pragma mark - Dialog Delegate

- (void)dialogDidComplete:(FBDialog *)dialog
{
    
}

- (void)dialogCompleteWithUrl:(NSURL *)url
{
    
}

- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    
}

- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    
}

- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL *)url
{
    return NO;
}
*/

@end
