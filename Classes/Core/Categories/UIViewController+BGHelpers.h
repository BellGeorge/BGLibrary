//
//  UIViewController+BGHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 25/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __IPHONE_6_0 // Only do the rotation fix if we are building with iOS 6 API
@protocol DeprecatedRotationSupported
@optional
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toOrientation;
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end

#define shouldAutorotateToInterface_fixed shouldAutorotate \
{ \
UIViewController <DeprecatedRotationSupported> *selfTyped = (UIViewController <DeprecatedRotationSupported> *) self; \
\
if(![self respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) \
return NO; \
int optionCount = 0; \
for(UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait; orientation <= UIDeviceOrientationLandscapeLeft; orientation++) \
{ \
if(![selfTyped shouldAutorotateToInterfaceOrientation:orientation]) continue; \
if(optionCount==1) return YES; \
optionCount++; \
} \
return NO; \
} \
\
- (NSUInteger)supportedInterfaceOrientations \
{ \
UIViewController <DeprecatedRotationSupported> *selfTyped = (UIViewController <DeprecatedRotationSupported> *) self; \
\
if(![self respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) return UIInterfaceOrientationMaskPortrait; \
\
NSUInteger supported = 0; \
\
if([selfTyped shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait]) supported |= UIInterfaceOrientationMaskPortrait; \
if([selfTyped shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft]) supported |= UIInterfaceOrientationMaskLandscapeLeft; \
if([selfTyped shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight]) supported |= UIInterfaceOrientationMaskLandscapeRight; \
if([selfTyped shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown]) supported |= UIInterfaceOrientationMaskPortraitUpsideDown; \
return supported;  \
} \
\
- (BOOL)shouldAutorotateToInterfaceOrientation
#else // We are building with the older API, leave shouldAutorotateToInterfaceOrientation alone.
#define shouldAutorotateToInterface_fixed shouldAutorotateToInterfaceOrientation
#endif // __IPHONE_6_0

typedef void (^BGViewControllerTraversalBlock)(UIViewController * viewController, BOOL * stop);

@interface UIViewController (BGHelpers)

+ (NSString *) bg_defaultNibName;

- (BOOL) bg_addDoneButton;

- (UIViewController *) bg_topMost;

#pragma - mark Traversal

- (void) bg_traverseHeirarchyDown:(BGViewControllerTraversalBlock)traversalBlock;
- (void) bg_traverseHeirarchyUp:(BGViewControllerTraversalBlock)traversalBlock;

- (id) bg_firstViewControllerOfClassDown:(Class)targetClass;
- (id) bg_firstViewControllerOfClassUp:(Class)targetClass;

#pragma - mark Orientation

- (BOOL) bg_shouldAutorotateFromMask:(UIInterfaceOrientation)orientation;
- (NSUInteger) bg_singularOrientationMaskFromInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
