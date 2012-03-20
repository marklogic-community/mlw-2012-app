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
#import "MLWAppDelegate.h"
#import "MLWScheduleGridView.h"


@interface MLWScheduleGridController ()
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) MLWScheduleGridView *gridView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) NSArray *sessionBlocks;
@property (nonatomic, retain) UIPopoverController *popover;
@end

@implementation MLWScheduleGridController

@synthesize scrollView = _scrollView;
@synthesize gridView = _gridView;
@synthesize loadingView = _loadingView;
@synthesize sessionBlocks = _sessionsInBlocks;
@synthesize popover = _popover;

- (id)init {
    self = [super init];
    if(self) {
		self.navigationItem.title = @"Schedule";
		self.tabBarItem.title = @"Schedule";
		self.tabBarItem.image = [UIImage imageNamed:@"calendar"];
    }
    return self;
}

- (void)loadView {
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

	self.gridView = [[[MLWScheduleGridView alloc] initWithFrame:self.view.bounds] autorelease];
	self.gridView.backgroundColor = [UIColor whiteColor];
	self.gridView.delegate = self;
	[self.gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addSubview:self.gridView];

	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	BOOL cached = [conference fetchSessions:^(NSArray *sessions, NSError *error) {
		self.sessionBlocks = [conference sessionsToBlocks:sessions];
		self.gridView.sessions = self.sessionBlocks;
		[self.gridView setNeedsLayout];

		[UIView transitionWithView:self.loadingView duration:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
			self.loadingView.alpha = 0.0f;
		}
		completion:^(BOOL finished) {
			[self.loadingView removeFromSuperview];
		}];
	}];

	if(!cached) {
		[self.view addSubview:self.loadingView];
		self.loadingView.alpha = 1.0f;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"frame"]) {
		[self.scrollView setContentSize:self.gridView.frame.size];
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
	if(self.popover == nil) {
		self.popover = [[[UIPopoverController alloc] initWithContentViewController:viewShowController] autorelease];
	}
	else {
		[self.popover setContentViewController:viewShowController animated:YES];
	}
	[viewShowController release];

	CGRect sessionRect = sessionView.frame;
	if(sessionView.session.plenary == NO) {
		sessionRect.origin.y = sessionView.superview.frame.origin.y;
	}

	[self.popover presentPopoverFromRect:[self.gridView convertRect:sessionRect toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)viewDidUnload {
	[super viewDidUnload];
	self.gridView = nil;
	self.view = nil;
	self.sessionBlocks = nil;
	self.popover = nil;
	self.loadingView = nil;
	self.scrollView = nil;
}

- (void)dealloc {
	[super dealloc];
	self.gridView = nil;
	self.view = nil;
	self.sessionBlocks = nil;
	self.popover = nil;
	self.loadingView = nil;
	self.scrollView = nil;
}

@end
