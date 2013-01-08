//
//  UISearchBar+BGHelpers.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 27/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "UISearchBar+BGHelpers.h"

@implementation UISearchBar (BGHelpers)

- (void) bg_setSearchBarTextColor:(UIColor *)color
{
    for(UIView * subView in self.subviews){
        if([subView isKindOfClass:UITextField.class]){
            [(UITextField*)subView setTextColor:color];
        }
    }
}

@end
