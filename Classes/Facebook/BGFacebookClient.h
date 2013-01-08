//
//  BGFacebookClient.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 19/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "BGDefaultApiClient.h"

@interface BGFacebookClient : NSObject

#pragma mark - Set these properties first before instantiating

+ (void) setAppId:(NSString *)appId;
+ (void) setUrlSchemeSuffix:(NSString *)urlSchemeSuffix;
+ (void) setPermissions:(NSArray *)permissions;

#pragma mark - Designated Initialiser

+ (BGFacebookClient *) sharedFacebookClient;

#pragma mark - User Interface

- (void) presentLoginDialogFromViewController:(UIViewController *)viewController;

#pragma mark - Graph Requests

//- (void) myProfile:(BGReq)handler;

#pragma mark - Queries

- (BOOL) isLoggedIn;

@end
