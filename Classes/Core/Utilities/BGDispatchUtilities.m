//
//  BGDispatchUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 15/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGDispatchUtilities.h"

extern void bg_dispatch_delay_main(dispatch_block_t block , CFTimeInterval timeDelay)
{
    int64_t timeDelayInt = (int64_t) ((timeDelay) * ((CFTimeInterval) 10e+8));
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, timeDelayInt);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@implementation BGDispatchUtilities

@end
