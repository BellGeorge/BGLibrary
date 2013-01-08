//
//  BGImageUtilities.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 25/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGImageUtilities.h"
#import "BGDeviceUtilities.h"

@implementation BGImageUtilities

+ (UIImage *) launchImage
{
    UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
    switch (currentOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationPortrait:
            interfaceOrientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        default:
            interfaceOrientation = UIInterfaceOrientationPortrait;
            break;
    }
    
    return [self launchImageWithInterfaceOrientation:interfaceOrientation];
}

+ (UIImage *) launchImageWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if([BGDeviceUtilities isPad])
    {
        UIImage * image = nil;
        
        //Try specific images
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
                image = [UIImage imageNamed:@"Default-LandscapeLeft.png"];
                break;
            case UIInterfaceOrientationLandscapeRight:
                image = [UIImage imageNamed:@"Default-LandscapeRight.png"];
                break;
            case UIInterfaceOrientationPortrait:
                image = [UIImage imageNamed:@"Default-Portrait.png"];
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                image = [UIImage imageNamed:@"Default-PortraitUpsideDown.png"];
                break;
            default:
                break;
        }
        
        // Try reversed images
        if(!image)
        {
            if(UIInterfaceOrientationIsLandscape(orientation))
            {
                image = [UIImage imageNamed:@"Default-Landscape.png"];
            }
            else
            {
                image = [UIImage imageNamed:@"Default-Portrait.png"];
            }
        }
        
        return image;
    }
    else if([BGDeviceUtilities isTall])
    {
        return [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    else
    {
        return [UIImage imageNamed:@"Default.png"];
    }

}

@end
