//
//  BGDeviceUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 25/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGDeviceUtilities.h"
#import <UIKit/UIKit.h>

extern BOOL BGDeviceIsPhone()
{
    return !BGDeviceIsPad();
}


extern BOOL BGDeviceIsPad()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

extern BOOL BGDeviceIsRetina()
{
    static CGFloat scale = -1.0f;
    
    if (scale < 0.0f) {
        UIScreen* screen = [UIScreen mainScreen];
        // Get the scale of the screen if available (iOS 4.0 only)
        if ([screen respondsToSelector:@selector(scale)]) {
            scale = screen.scale;
        } else {
            scale = 1.0f;           // not a retina display
        }
    }
    
    return scale > 1.5f;            // retina display has scale of 2.0, others 1.0
}

extern BOOL BGDeviceIsTall()
{
    BOOL tall = ([UIScreen mainScreen].bounds.size.height >= 568) ? YES : NO;
    return tall;

}

@implementation BGDeviceUtilities

+(BOOL)isPad
{
    return BGDeviceIsPad();
}

+(BOOL)isRetina                 // screen has a scale factor of > 1.5
{
    return BGDeviceIsRetina();
}

+(BOOL)isTall
{
    return BGDeviceIsTall();
}

@end
