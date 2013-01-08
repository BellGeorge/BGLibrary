//
//  BGErrorUtilities.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 31/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BGErrorDomainDefault;

@interface BGErrorUtilities : NSObject

+ (BOOL) defaultPopulateError:(NSError **)errorRef errorString:(NSString *)errorString domain:(NSString *)errorDomain errorCode:(NSInteger)errorCode userInfo:(NSDictionary *)userInfo;

@end
