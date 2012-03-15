//
//  MLWScheduleGridController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWScheduleGridController.h"
#import "MLWScheduleListController.h"
#import "MLWSessionDetailController.h"

@implementation MLWScheduleGridController

- (id)init {
    self = [super init];
    if(self) {
		self.navigationItem.title = @"Schedule";
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

    return YES;
}

- (void)loadView {
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.backgroundColor = [UIColor whiteColor];
	self.view = scrollView;
	[scrollView release];
}

@end
