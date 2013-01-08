//
//  BGErrorUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 31/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGErrorUtilities.h"
#import "BGLibraryMacros.h"

NSString * const BGErrorDomainDefault = @"com.bellgeorge.error";

@implementation BGErrorUtilities

+ (BOOL) defaultPopulateError:(NSError **)errorRef errorString:(NSString *)errorString domain:(NSString *)errorDomain errorCode:(NSInteger)errorCode userInfo:(NSDictionary *)userInfo
{
    if(errorRef != nil && errorRef != NULL) 
    { 
        NSMutableDictionary * mUserInfo = (BGIsNull(userInfo)) ? [NSMutableDictionary dictionary] : [userInfo mutableCopy];
        if(BGNotNull(errorString))
        {
            mUserInfo[NSLocalizedDescriptionKey] = errorString;
        }
        
        NSString * mErrorDomain = (BGIsNull(errorDomain)) ? BGErrorDomainDefault : errorDomain;
        
        *errorRef = [NSError errorWithDomain:mErrorDomain code:errorCode userInfo:mUserInfo];
        
        return YES;
    }
    
    return NO;
}

@end
