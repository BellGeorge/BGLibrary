//
//  UIView+BGHelpers.h
//  BGMagazine
//
//  Created by Lawrence Lomax on 18/09/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIViewHierarchyTraversalBlock) (UIView * view, BOOL * stop);

@interface UIView (BGHelpers)

#pragma mark Instantiate from nib

+ (id) bg_instantiateViewFromNamedNib;

#pragma mark Subviews

- (void) bg_removeAllSubviews;
- (BOOL) bg_hasSubviews;

- (void) bg_traverseHeirarchyDown:(UIViewHierarchyTraversalBlock)traversalBlock;

- (id) bg_firstChildViewOfClass:(Class)class;
- (NSArray *) bg_immediateSubviewsOfClass:(Class)class;
- (NSArray *) bg_subviewsOfClassRecursive:(Class)class;

#pragma mark Gesture Recognizers

- (void) bg_removeAllGestureRecognizers;

#pragma mark Frames

- (CGRect) bg_frameInView:(UIView *)view;
- (CGRect) bg_boundsInView:(UIView *)view;

#pragma mark - Dimming Helpers

- (void) bg_dimAndDisable;
- (void) bg_lightAndEnable;

#pragma mark - Sizing

- (CGSize) bg_sizeThatFitsSubviews;
- (void) bg_sizeToFitSubviews;

@end
