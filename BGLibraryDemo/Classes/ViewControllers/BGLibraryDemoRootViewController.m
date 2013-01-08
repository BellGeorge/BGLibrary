//
//  BGLibraryDemoRootViewController.m
//  BGLibrary
//
//  Created by Lawrence Lomax on 20/11/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGLibraryDemoRootViewController.h"
#import "BGTableViewAdapter.h"
#import "BGArrayController.h"
#import "BGFacebookClient.h"

@interface BGLibraryDemoRootViewController ()

@end

@implementation BGLibraryDemoRootViewController
{
    BGTableViewAdapter * _adapter;
}

- (void) loadView
{
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.size.height = 100.0f;
    UIView * headerView = [[UIView alloc] initWithFrame:frame];
    
    frame = headerView.bounds;
    frame = CGRectInset(frame, 100, 20);
    //BGRoundedGradientView * button = [[BGRoundedGradientView alloc] initWithFrame:frame];
    //button.topColor = [UIColor redColor];
    //button.bottomColor = [UIColor greenColor];
    //[headerView addSubview:button];
    
    self.tableView.tableHeaderView = headerView;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [BGFacebookClient setAppId:@"371817866243898"];
    [BGFacebookClient setUrlSchemeSuffix:@"bglibrarydemo"];
    [BGFacebookClient setPermissions:@[ ]];
    
    BGTableViewAdapterAction loginAction = ^(BGTableViewAdapter * tableViewAdapter, NSIndexPath * indexPath){
        [[BGFacebookClient sharedFacebookClient] presentLoginDialogFromViewController:tableViewAdapter.viewController];
    };
    
    NSArray * data = @[
        @{kBGTableViewAdapterName : @"Facebook", kBGArrayControllerChildren : @[
            @{kBGTableViewAdapterName : @"Login to Facebook", kBGTableViewAdapterAction : [loginAction copy]}
        ]}
    ];
    
    _adapter = [BGTableViewAdapter adapterWithArray:data tableView:self.tableView viewController:self];
}

@end
