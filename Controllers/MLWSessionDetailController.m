//
//  MLWSessionDetailController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSessionDetailController.h"

@implementation MLWSessionDetailController

- (id)initWithSession:(MLWSession *)session {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

/*
- (void)loadView
{
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

    return YES;
}

@end
