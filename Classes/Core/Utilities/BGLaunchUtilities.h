//
//  BGLaunchUtilities.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 08/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGLaunchUtilities : NSObject

+ (void) performBlockOnceEver:(dispatch_block_t)block withName:(const char *)name;
+ (void) performBlockOncePerVersionEver:(dispatch_block_t)block withName:(const char *)name;

+ (void) performBlockIfFirstAppLaunch:(dispatch_block_t)block;
+ (void) performBlockIfFirstAppLaunchOfThisVersion:(dispatch_block_t)block;

@end
