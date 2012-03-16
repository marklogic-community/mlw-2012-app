//
//  MLWSponsorController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSponsorController.h"
#import "MLWSponsorListController.h"
#import "MLWSponsorDetailController.h"

@implementation MLWSponsorController

- (id)init {
    self = [super init];
    if(self) {
		MLWSponsorListController *listController = [[[MLWSponsorListController alloc] init] autorelease];
		UINavigationController *listNavController = [[[UINavigationController alloc] initWithRootViewController:listController] autorelease];

		MLWSponsorDetailController *detailController = [[[MLWSponsorDetailController alloc] init] autorelease];
		UINavigationController *detailNavController = [[[UINavigationController alloc] initWithRootViewController:detailController] autorelease];

		self.viewControllers = [NSArray arrayWithObjects:listNavController, detailNavController, nil];

		self.tabBarItem.title = @"Sponsors";
		self.tabBarItem.image = [UIImage imageNamed:@"badge"];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

    return YES;
}

@end
