//
//  BGLaunchUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 08/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGLaunchUtilities.h"
#import "BGLibraryMacros.h"

@implementation BGLaunchUtilities

+ (void) performBlockOnceEver:(dispatch_block_t)block withName:(const char *)name
{
    static NSString * const key = @"881D9AA0-3EC5-412F-AD06-EDF469203362";
    NSString * nameValue = [NSString stringWithUTF8String:name];
    
    NSArray * array = [[NSUserDefaults standardUserDefaults] arrayForKey:key ];
    if(BGIsNull(array))
    {
        array = [NSArray array];
    }
    
    if(![array containsObject:nameValue])
    {
        // Perform the Block
        block();
        // Add to array
        array = [array arrayByAddingObject:nameValue];
        // Set the object in defaults
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void) performBlockOncePerVersionEver:(dispatch_block_t)block withName:(const char *)name
{
    static NSString * const keyParent = @"A52C446E-334C-40C4-8EE5-6FF4819DDF07";
    NSString * key = [NSString stringWithFormat:@"%@____%@", keyParent, [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]];
    NSString * nameValue = [NSString stringWithUTF8String:name];
    
    NSArray * array = [[NSUserDefaults standardUserDefaults] arrayForKey:key ];
    if(BGIsNull(array))
    {
        array = [NSArray array];
    }
    
    if(![array containsObject:nameValue])
    {
        // Perform the Block
        block();
        // Add to array
        array = [array arrayByAddingObject:nameValue];
        // Set the object in defaults
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void) performBlockIfFirstAppLaunch:(dispatch_block_t)block
{
    static NSString * const key = @"BF6856BE-49BC-40F2-8E69-887328B14AEF";
    BOOL hasLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if(!hasLaunched)
    {
        block();
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


+ (void) performBlockIfFirstAppLaunchOfThisVersion:(dispatch_block_t)block
{
    static NSString * const keyParent = @"30CB95FD-AB81-46CD-9E31-A1A8BEE2554A";
    NSString * key = [NSString stringWithFormat:@"%@____%@", keyParent, [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]];
    BOOL hasLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    if(!hasLaunched)
    {
        block();
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}


@end
