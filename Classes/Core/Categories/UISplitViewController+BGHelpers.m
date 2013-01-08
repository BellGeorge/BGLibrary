//
//  UISplitViewController+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 14/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UISplitViewController+BGHelpers.h"

@implementation UISplitViewController (BGHelpers)

#pragma mark Accessors

- (UIViewController *) bg_masterViewController
{
    if(self.viewControllers.count)
    {
        return self.viewControllers[0];
    }
    
    return nil;
}

- (UIViewController *) bg_detailViewController
{
    if(self.viewControllers.count >= 2)
    {
        return self.viewControllers[1];
    }

    return nil;
}

- (void) setBg_masterViewController:(UIViewController *)bg_masterViewController
{
    NSMutableArray * viewControllers = [self.viewControllers mutableCopy];
    viewControllers[0] = bg_masterViewController;
    self.viewControllers = viewControllers;
}

- (void) setBg_detailViewController:(UIViewController *)bg_detailViewController
{
    NSMutableArray * viewControllers = [self.viewControllers mutableCopy];
    viewControllers[1] = bg_detailViewController;
    self.viewControllers = viewControllers;
}

@end
