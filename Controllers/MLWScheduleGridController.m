/*
    MLWScheduleGridController.m
	MarkLogic World
	Created by Ryan Grimm on 3/9/12.

	Copyright 2012 MarkLogic

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

#import "MLWScheduleGridController.h"
#import "MLWScheduleListController.h"
#import "MLWSessionDetailController.h"
#import "MLWAppDelegate.h"
#import "MLWScheduleGridView.h"


@interface MLWScheduleGridController ()
@property (nonatomic, retain) MLWFilterViewController *filterController;
@property (nonatomic, retain) UINavigationController *filterNavController;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) MLWScheduleGridView *gridView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIView *noResultsView;
@property (nonatomic, retain) NSArray *sessionBlocks;
@property (nonatomic, retain) UIPopoverController *sessionPopover;
@property (nonatomic, retain) UIPopoverController *filterPopover;
@property (nonatomic, retain) MLAndConstraint *filterConstraint;

- (void)fetchSessions;
- (void)filterResults:(UIBarButtonItem *)sender;
@end

@implementation MLWScheduleGridController

@synthesize filterController = _filterController;
@synthesize filterNavController = _filterNavController;
@synthesize scrollView = _scrollView;
@synthesize gridView = _gridView;
@synthesize loadingView = _loadingView;
@synthesize noResultsView = _noResultsView;
@synthesize sessionBlocks = _sessionsInBlocks;
@synthesize sessionPopover = _sessionPopover;
@synthesize filterPopover = _filterPopover;
@synthesize filterConstraint = _filterConstraint;

- (id)init {
    self = [super init];
    if(self) {
		self.filterConstraint = nil;
		self.filterController = [[[MLWFilterViewController alloc] init] autorelease];
		self.filterController.delegate = self;
		self.filterNavController = [[[UINavigationController alloc] initWithRootViewController:self.filterController] autorelease];
		self.filterNavController.navigationBar.tintColor = [UIColor colorWithRed:(236.0f/255.0f) green:(125.0f/255.0f) blue:(30.0f/255.0f) alpha:1.0f];
		self.filterNavController.title = @"Filter Sessions";

		self.navigationItem.title = @"Schedule";
		self.tabBarItem.title = @"Schedule";
		self.tabBarItem.image = [UIImage imageNamed:@"calendar"];
    }
    return self;
}

- (void)loadView {
	UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterResults:)];
	self.navigationItem.rightBarButtonItem = filter;
	[filter release];

	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fabric"]];

	self.scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.scrollView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.scrollView];

	self.loadingView = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
	self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.loadingView.backgroundColor = [UIColor blackColor];
	self.loadingView.alpha = 1.0f;
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = self.loadingView.center;
	spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[spinner startAnimating];
	[self.loadingView addSubview:spinner];
    [spinner release];

	self.noResultsView = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
	self.noResultsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.noResultsView.backgroundColor = [UIColor clearColor];
	UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:self.view.frame];
	noResultsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	noResultsLabel.backgroundColor = [UIColor clearColor];
	noResultsLabel.text = @"No Sessions";
	noResultsLabel.textAlignment = UITextAlignmentCenter;
	noResultsLabel.font = [UIFont boldSystemFontOfSize:30];
	noResultsLabel.textColor = [UIColor whiteColor];
	[self.noResultsView addSubview:noResultsLabel];
	[noResultsLabel release];

	self.gridView = [[[MLWScheduleGridView alloc] initWithFrame:self.view.bounds] autorelease];
	self.gridView.backgroundColor = [UIColor whiteColor];
	self.gridView.delegate = self;
	[self.gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addSubview:self.gridView];

	[self fetchSessions];

	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	[conference.userSchedule addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)fetchSessions {
	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	BOOL cached = [conference fetchSessionsWithConstraint:self.filterConstraint callback:^(NSArray *sessions, NSError *error) {
		self.sessionBlocks = [conference sessionsToBlocks:sessions];
		self.gridView.sessions = self.sessionBlocks;
		[self.gridView setNeedsLayout];

		[UIView transitionWithView:self.loadingView duration:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
			self.loadingView.alpha = 0.0f;
		}
		completion:^(BOOL finished) {
			[self.loadingView removeFromSuperview];
		}];

		if(sessions.count == 0) {
			self.noResultsView.frame = self.view.frame;
			[self.view addSubview:self.noResultsView];
		}
	}];

	[self.noResultsView removeFromSuperview];
	if(!cached) {
		[self.view addSubview:self.loadingView];
		[self.loadingView setNeedsLayout];
		self.loadingView.alpha = 1.0f;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"frame"]) {
		[self.scrollView setContentSize:self.gridView.frame.size];
	}
	else if([keyPath isEqualToString:@"count"]) {
		[self.gridView updateUserSchedule];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.gridView setNeedsLayout];
}

- (void)sessionViewWasSelected:(MLWSessionView *)sessionView {
	if(sessionView.session.selectable == NO) {
		return;
	}

	MLWSessionDetailController *viewShowController = [[MLWSessionDetailController alloc] initWithSession:sessionView.session];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewShowController];
	[viewShowController release];

	if(self.sessionPopover == nil) {
		self.sessionPopover = [[[UIPopoverController alloc] initWithContentViewController:navController] autorelease];
	}
	else {
		[self.sessionPopover setContentViewController:navController animated:YES];
	}
	[navController release];

	CGRect sessionRect = sessionView.frame;
	if(sessionView.session.plenary == NO) {
		sessionRect.origin.y = sessionView.superview.frame.origin.y;
	}

	[self.sessionPopover presentPopoverFromRect:[self.gridView convertRect:sessionRect toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)filterView:(MLWFilterViewController *) filterViewController constructedConstraint:(MLAndConstraint *) constraint {
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
	self.filterConstraint = constraint;
	[self.filterPopover dismissPopoverAnimated:YES];
	[self fetchSessions];
}

- (void)filterResults:(UIBarButtonItem *)sender {
	if(self.filterPopover == nil) {
		self.filterPopover = [[[UIPopoverController alloc] initWithContentViewController:self.filterNavController] autorelease];
	}

	[self.filterPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)viewDidUnload {
	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	[conference.userSchedule removeObserver:self forKeyPath:@"count"];

	[self.gridView removeObserver:self forKeyPath:@"frame"];
	self.gridView = nil;
	self.view = nil;
	self.sessionBlocks = nil;
	self.sessionPopover = nil;
	self.filterPopover = nil;
	self.loadingView = nil;
	self.noResultsView = nil;
	self.scrollView = nil;

	[super viewDidUnload];
}

- (void)dealloc {
	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	[conference.userSchedule removeObserver:self forKeyPath:@"count"];

	[self.gridView removeObserver:self forKeyPath:@"frame"];
	self.filterConstraint = nil;
	self.filterController = nil;
	self.filterNavController = nil;
	self.gridView = nil;
	self.view = nil;
	self.sessionBlocks = nil;
	self.sessionPopover = nil;
	self.filterPopover = nil;
	self.loadingView = nil;
	self.noResultsView = nil;
	self.scrollView = nil;

	[super dealloc];
}

@end
