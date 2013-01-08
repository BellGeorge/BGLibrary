//
//  NSObject+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 26/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "NSObject+BGHelpers.h"
#import <objc/runtime.h>


@implementation NSObject (BGHelpers)

- (NSMutableDictionary *) bg_arbitraryObjectDictionary
{
    static char * const arbitraryDictionaryKey = "__BGArbitraryObjectDictionary";
    
    NSMutableDictionary * dictionary = objc_getAssociatedObject(self, arbitraryDictionaryKey);
    if(!dictionary)
    {
        dictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, arbitraryDictionaryKey, dictionary, OBJC_ASSOCIATION_RETAIN);
    }
    
    return dictionary;
}

- (void) bg_setArbitraryObject:(id)object forKey:(id)key
{
    [[self bg_arbitraryObjectDictionary] setObject:object forKey:key];
}

- (id) bg_arbitraryObjectForKey:(id)key
{
    return [[self bg_arbitraryObjectDictionary] objectForKey:key];
}

- (void) bg_removeAbitraryObjectForKey:(id)key
{
    [[self bg_arbitraryObjectDictionary] removeObjectForKey:key];
}



@end
