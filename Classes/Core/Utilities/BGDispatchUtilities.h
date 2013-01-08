//
//  BGDispatchUtilities.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 15/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void bg_dispatch_delay_main(dispatch_block_t block , CFTimeInterval timeDelay);

@interface BGDispatchUtilities : NSObject

@end
