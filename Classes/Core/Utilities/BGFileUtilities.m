//
//  BGFileUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 04/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGFileUtilities.h"

NSURL * BGDocumentsDirectoryURL()
{
    static NSURL * url = nil;
    if(!url)
    {
        NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        url = [NSURL fileURLWithPath:path];
    }
    return url;
}

NSURL * BGCachesDirectoryURL()
{
    static NSURL * url = nil;
    if(!url)
    {
        NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        url = [NSURL fileURLWithPath:path];
    }
    return url;
}

NSURL * BGApplicationSupportDirectoryURL()
{
    static NSURL * url = nil;
    if(!url)
    {
        NSString * path = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
        url = [NSURL fileURLWithPath:path];
    }
    return url;
}

@implementation BGFileUtilities


@end
