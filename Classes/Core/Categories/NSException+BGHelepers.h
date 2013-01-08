//
//  NSException+BGHelepers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 21/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (BGHelepers)

+ (void) raiseWithError:(NSError *)error;

@end
