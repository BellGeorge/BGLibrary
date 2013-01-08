//
//  UIView+BGHelpers.m
//  BGMagazine
//
//  Created by Lawrence Lomax on 18/09/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UIView+BGHelpers.h"

@implementation UIView (BGHelpers)

#pragma mark

+ (id) bg_instantiateViewFromNamedNib
{
    NSString * nibName = NSStringFromClass(self);
    NSArray * nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    if ([nibViews count])
    {
        return [nibViews objectAtIndex:0];
    }
    
    return nil;
}

- (BOOL) bg_hasSubviews
{
    if(self.subviews.count > 0)
        return YES;
    
    return NO;
}

#pragma mark Subviews

- (void) bg_removeAllSubviews
{
    for(UIView * view in [self subviews])
    {
        [view removeFromSuperview];
    }
}

- (CGRect) bg_frameInView:(UIView *)view
{
    return [self.superview convertRect:self.frame toView:view];
}

- (CGRect) bg_boundsInView:(UIView *)view
{
    return [self convertRect:self.bounds toView:view];
}


- (void) bg_traverseHeirarchyDown:(UIViewHierarchyTraversalBlock)traversalBlock
{
    BOOL stop = NO;
    [self bg_traverseHeirarchyDown:traversalBlock stop:&stop];
}

- (void) bg_traverseHeirarchyDown:(UIViewHierarchyTraversalBlock)traversalBlock stop:(BOOL *)traversalStop
{
    traversalBlock(self, traversalStop);
    if(*traversalStop)
        return;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        [subview bg_traverseHeirarchyDown:traversalBlock stop:stop];
        if(*stop)
        {
            *traversalStop = YES;
        }
    }];    
}


- (id) bg_firstChildViewOfClass:(Class)class
{
    __block id childView = nil;
    
    [self bg_traverseHeirarchyDown:^(UIView * view, BOOL *stop) {
        if([view isKindOfClass:class])
        {
            childView = view;
            *stop = YES;
        }
    }];
    
    return childView;
}


- (NSArray *) bg_immediateSubviewsOfClass:(Class)class
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:class])
        {
            [array addObject:obj];
        }
    }];
    
    return [array copy];
}


- (NSArray *) bg_subviewsOfClassRecursive:(Class)class
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    [self bg_traverseHeirarchyDown:^(UIView *view, BOOL *stop) {
        if([view isKindOfClass:class])
        {
            [array addObject:view];
        }
    }];
    
    return [array copy];
}

#pragma mark Gesture Recognizers

- (void) bg_removeAllGestureRecognizers
{
    NSArray * gestureRecognizers = [self.gestureRecognizers copy];
    
    [gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer * gestureRecognizer, NSUInteger idx, BOOL *stop) {
        [self removeGestureRecognizer:gestureRecognizer];
    }];
}

#pragma mark - Dimming Helpers

- (void) bg_dimAndDisable
{
    [UIView animateWithDuration:2.0f animations:^{
        self.userInteractionEnabled = NO;
        self.alpha = 0.8f;
    } completion:^(BOOL finished) {
        
    }];
}


- (void) bg_lightAndEnable
{
    [UIView animateWithDuration:2.0f animations:^{
        self.userInteractionEnabled = YES;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - Sizing

- (CGSize) bg_sizeThatFitsSubviews
{
    __block CGRect boundingRect = CGRectZero;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * view, NSUInteger idx, BOOL *stop) {
        boundingRect = CGRectUnion(boundingRect, view.frame);
    }];
    
    return boundingRect.size;
}


- (void) bg_sizeToFitSubviews
{
    CGRect frame = self.frame;
    frame.size = [self bg_sizeThatFitsSubviews];
    self.frame = frame;
}


@end
