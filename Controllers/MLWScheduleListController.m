//
//  MLWScheduleListController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWScheduleListController.h"
#import "MLWSessionDetailController.h"
#import "MLWAppDelegate.h"
#import "MLWSession.h"
#import "UITableView+helpers.h"
#import "MLWFilterViewController.h"
#import "MLWAndConstraint.h"
#import <QuartzCore/QuartzCore.h>

@interface MLWScheduleListController ()
@property (nonatomic, retain) MLWFilterViewController *filterController;
@property (nonatomic, retain) UINavigationController *filterNavController;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) NSArray *sessionBlocks;
@property (nonatomic, retain) MLWAndConstraint *filterConstraint;

- (void)fetchSessions;
- (void)filterResults:(UIBarButtonItem *)sender;
- (MLWSession *)sessionForIndexPath:(NSIndexPath *) indexPath;
@end


@implementation MLWScheduleListController

@synthesize filterController = _filterController;
@synthesize filterNavController = _filterNavController;
@synthesize tableView = _tableView;
@synthesize loadingView = _loadingView;
@synthesize sessionBlocks = _sessionsInBlocks;
@synthesize filterConstraint = _filterConstraint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
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

#pragma mark - View lifecycle

- (void)loadView {
	UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterResults:)];
	self.navigationItem.rightBarButtonItem = filter;
	[filter release];

	self.view = [[[UIView alloc] init] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	self.loadingView = [[[UIView alloc] init] autorelease];
	self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.loadingView.backgroundColor = [UIColor blackColor];
	self.loadingView.alpha = 1.0f;
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[spinner startAnimating];
	[self.loadingView addSubview:spinner];
    [spinner release];

	self.tableView = [[[UITableView alloc] init] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView applyBackground];
	[self.view addSubview:self.tableView];

	[self fetchSessions];
}

- (void)fetchSessions {
	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	BOOL cached = [conference fetchSessionsWithConstraint:self.filterConstraint callback:^(NSArray *sessions, NSError *error) {
		self.sessionBlocks = [conference sessionsToBlocks:sessions];

		[self.tableView reloadData];
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

- (void)viewDidAppear:(BOOL)animated {
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

	return YES;
}

#pragma mark - View lifecycle

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return self.sessionBlocks.count;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	NSArray *sessionsInBlock = [self.sessionBlocks objectAtIndex:section];
	return sessionsInBlock.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray *sessionsInBlock = [self.sessionBlocks objectAtIndex:section];
	return ((MLWSession *)[sessionsInBlock objectAtIndex:0]).formattedDate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [tableView createHeaderForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.textLabel.minimumFontSize = 14;
	}

	MLWSession *session = [self sessionForIndexPath:indexPath];
	if(session.selectable) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.textLabel.text = session.title;
	if(session.track != nil && session.location != nil) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", session.track, session.location];
	}
	else if(session.location != nil) {
		cell.detailTextLabel.text = session.location;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
	cell.layer.borderWidth = 0.5f;
	cell.backgroundColor = [UIColor whiteColor];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([self sessionForIndexPath:indexPath].selectable == NO) {
		return nil;
	}
	return indexPath;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	MLWSessionDetailController *viewShowController = [[MLWSessionDetailController alloc] initWithSession:[self sessionForIndexPath:indexPath]];
	[self.navigationController pushViewController:viewShowController animated:YES];
	[viewShowController release];
}

- (void)filterView:(MLWFilterViewController *) filterViewController constructedConstraint:(MLWAndConstraint *) constraint {
	self.filterConstraint = constraint;
	[self fetchSessions];
}

- (void)filterResults:(UIBarButtonItem *)sender {
	[self presentModalViewController:self.filterNavController animated:YES];
}

- (MLWSession *)sessionForIndexPath:(NSIndexPath *) indexPath {
	NSArray *sessionsInBlock = [self.sessionBlocks objectAtIndex:indexPath.section];
	return [sessionsInBlock objectAtIndex:indexPath.row];
}


- (void)viewDidUnload {
	[super viewDidUnload];
	self.tableView = nil;
	self.view = nil;
	self.sessionBlocks = nil;
	self.loadingView = nil;
}

- (void)dealloc {
	[super dealloc];
	self.filterConstraint = nil;
	self.filterController = nil;
	self.filterNavController = nil;
	self.tableView = nil;
	self.view = nil;
	self.sessionBlocks = nil;
	self.loadingView = nil;
}

@end
