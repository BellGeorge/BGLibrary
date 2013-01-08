//
//  BGDeviceUtilities.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 25/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL BGDeviceIsPhone();
extern BOOL BGDeviceIsPad();
extern BOOL BGDeviceIsRetina();
extern BOOL BGDeviceIsTall();

@interface BGDeviceUtilities : NSObject

+ (BOOL) isPad;
+ (BOOL) isRetina;
+ (BOOL) isTall;

@end
