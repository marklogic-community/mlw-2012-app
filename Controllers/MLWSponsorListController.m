//
//  MLWSponsorListController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSponsorListController.h"
#import "MLWAppDelegate.h"
#import "MLWSponsorView.h"
#import "UITableView+helpers.h"
#import <QuartzCore/QuartzCore.h>

@interface MLWSponsorListController ()
- (MLWSponsorView *)sponsorViewForIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) NSArray *sponsors;
@end

@implementation MLWSponsorListController

@synthesize tableView = _tableView;
@synthesize loadingView = _loadingView;
@synthesize sponsors = _sponsors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
		self.navigationItem.title = @"Sponsors";
		self.tabBarItem.title = @"Sponsors";
		self.tabBarItem.image = [UIImage imageNamed:@"badge"];
    }
    return self;
}

- (void)loadView {
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

	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	BOOL cached = [conference fetchSponsors:^(NSArray *sponsors, NSError *error) {
		NSMutableArray *sponsorViews = [NSMutableArray arrayWithCapacity:sponsors.count];
		for(MLWSponsor *sponsor in sponsors) {
			[sponsorViews addObject:[[[MLWSponsorView alloc] initWithSponsor:sponsor] autorelease]];
		}

		NSMutableArray *groups = [NSMutableArray arrayWithCapacity:sponsorViews.count];
		NSString *lastLevel = [((MLWSponsorView *)[sponsorViews objectAtIndex:0]).sponsor.level copy];
		NSMutableArray *sponsorsInGroup = [NSMutableArray arrayWithCapacity:6];

		for(MLWSponsorView *sponsorView in sponsorViews) {
			if([sponsorView.sponsor.level isEqualToString:lastLevel] == NO) {
				[groups addObject:[NSArray arrayWithArray:sponsorsInGroup]];
				[sponsorsInGroup removeAllObjects];
				[lastLevel release];
				lastLevel = [sponsorView.sponsor.level copy];
			}

			[sponsorsInGroup addObject:sponsorView];
		}

		[groups addObject:[NSArray arrayWithArray:sponsorsInGroup]];
		[lastLevel release];
		self.sponsors = groups;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return self.sponsors.count;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	NSArray *levelSponsors = [self.sponsors objectAtIndex:section];
	return levelSponsors.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray *sponsorViews = [self.sponsors objectAtIndex:section];
	return ((MLWSponsorView *)[sponsorViews objectAtIndex:0]).sponsor.level;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	MLWSponsorView *sponsorView = [self sponsorViewForIndexPath:indexPath];
	return [sponsorView calculatedHeightWithWidth:self.view.frame.size.width];
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}

	for(UIView *view in cell.contentView.subviews) {
		[view removeFromSuperview];
	}
	MLWSponsorView *sponsorView = [self sponsorViewForIndexPath:indexPath];
	sponsorView.frame = cell.contentView.frame;
	[cell.contentView addSubview:sponsorView];

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
	cell.layer.borderWidth = 0.5f;
	cell.backgroundColor = [UIColor whiteColor];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (MLWSponsorView *)sponsorViewForIndexPath:(NSIndexPath *)indexPath {
	NSArray *groupSponsors = [self.sponsors objectAtIndex:indexPath.section];
	MLWSponsorView *view = [groupSponsors objectAtIndex:indexPath.row];
	return view;
}


- (void)viewDidUnload {
	self.tableView = nil;
	self.view = nil;
	self.sponsors = nil;

	[super viewDidUnload];
}

- (void)dealloc {
	self.tableView = nil;
	self.view = nil;
	self.sponsors = nil;

	[super dealloc];
}

@end
