//
//  NSObject+BGHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 26/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BGHelpers)

- (NSMutableDictionary *) bg_arbitraryObjectDictionary;
- (void) bg_setArbitraryObject:(id)object forKey:(id)key;
- (id) bg_arbitraryObjectForKey:(id)key;
- (void) bg_removeAbitraryObjectForKey:(id)key;

@end
