//
//  UIViewController+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 25/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UIViewController+BGHelpers.h"
#import "BlocksKit.h"
#import "BGLibraryMacros.h"

@implementation UIViewController (BGHelpers)

+ (NSString *) bg_defaultNibName
{
    BOOL (^checkNibExists)(NSString *) = ^BOOL(NSString * nibName){
        NSString * path = [[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"];
        if(path)
            return YES;
        
        return NO;
    };
    
    
    NSString * nibName = nil;
    NSString * className = NSStringFromClass(self);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSString * iPadNib = [NSString stringWithFormat:@"%@_iPad", className];
        if(checkNibExists(iPadNib))
            nibName = iPadNib;
    }
    else
    {
        NSString * iPhoneNib = [NSString stringWithFormat:@"%@_iPhone", className];
        if(checkNibExists(iPhoneNib))
            nibName = iPhoneNib;
    }
    
    if(!nibName)
    {
        if(checkNibExists(className))
            nibName = className;
    }
    
    return nibName;
}

- (BOOL) bg_addDoneButton
{
    if(self.presentingViewController)
    {
        BG_WEAKSELF;
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone handler:^(id sender) {
            [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        NSArray * leftItems = @[ doneButton ];
        if(self.navigationItem.leftBarButtonItems)
        {
            leftItems = [leftItems arrayByAddingObjectsFromArray:self.navigationItem.leftBarButtonItems];
        }
        self.navigationItem.leftBarButtonItems = leftItems;
        
        return YES;
    }
    
    return NO;
}

#pragma - mark Traversal

- (UIViewController *) bg_topMost
{
    if(self.presentedViewController)
        return [self.presentedViewController bg_topMost];
    
    return self;
}

- (void) bg_traverseHeirarchyDown:(BGViewControllerTraversalBlock)traversalBlock
{
    BOOL stop = NO;
    [self bg_traverseHeirarchyDown:traversalBlock stop:&stop];
}

- (void) bg_traverseHeirarchyDown:(BGViewControllerTraversalBlock)traversalBlock stop:(BOOL *)stop
{
    traversalBlock(self, stop);
    if(*stop)
        return;
    
    // Presenting viewcontrollers
    if(self.presentedViewController)
    {
        [self.presentedViewController bg_traverseHeirarchyDown:traversalBlock stop:stop];
        if(*stop)
            return;
    }
    
    // Child View Controllers Iterator
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController * child, NSUInteger idx, BOOL * iteratorStop) {
        if(child != self.presentedViewController)
        {
            [child bg_traverseHeirarchyDown:traversalBlock stop:stop];
            
            if(*stop)
            {
                *iteratorStop = YES;
            }
        }
    }];
    if(*stop)
        return;
}

- (void) bg_traverseHeirarchyUp:(BGViewControllerTraversalBlock)traversalBlock
{
    BOOL stop = NO;
    [self bg_traverseHeirarchyDown:traversalBlock stop:&stop];
}

- (void) bg_traverseHeirarchyUp:(BGViewControllerTraversalBlock)traversalBlock stop:(BOOL *)stop
{
    traversalBlock(self, stop);
    if(*stop)
        return;
    
    if(self.presentingViewController)
    {
        [self.presentingViewController bg_traverseHeirarchyUp:traversalBlock stop:stop];
        if(*stop)
            return;
    }
}


- (id) bg_firstViewControllerOfClassDown:(Class)targetClass
{
    __block UIViewController * retViewController = nil;
    
    [self bg_traverseHeirarchyDown:^(UIViewController *viewController, BOOL *stop) {
        if([viewController isKindOfClass:targetClass])
        {
            retViewController = viewController;
            *stop = YES;
        }
    }];
    
    return retViewController;
}


- (id) bg_firstViewControllerOfClassUp:(Class)targetClass
{
    __block UIViewController * retViewController = nil;
    
    [self bg_traverseHeirarchyUp:^(UIViewController *viewController, BOOL *stop) {
        if([viewController isKindOfClass:targetClass])
        {
            retViewController = viewController;
            *stop = YES;
        }
    }];
    
    return retViewController;
}

#pragma - mark Orientation

- (BOOL) bg_shouldAutorotateFromMask:(UIInterfaceOrientation)orientation;
{
    NSUInteger mask = [self supportedInterfaceOrientations];
    NSUInteger maskFromOrientation = [self bg_singularOrientationMaskFromInterfaceOrientation:orientation];
    
    if(mask &= maskFromOrientation)
    {
        return YES;
    }
    
    return NO;
}

- (NSUInteger) bg_singularOrientationMaskFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationMaskPortraitUpsideDown;
        default:
            return UIInterfaceOrientationMaskAll;
            break;
    }
}

@end
