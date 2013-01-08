//
//  UISplitViewController+BGHelpers.h
//  BGLibrary
//
//  Created by Lawrence Lomax on 14/12/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISplitViewController (BGHelpers)

@property (nonatomic, readwrite) UIViewController * bg_masterViewController;
@property (nonatomic, readwrite) UIViewController * bg_detailViewController;

@end
