//
//  MLWFilterViewController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWFilterViewController.h"
#import "UITableView+helpers.h"

@interface MLWFilterViewController ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *loadingView;

- (void)doneFiltering:(UIBarButtonItem *)sender;
@end

@implementation MLWFilterViewController

@synthesize tableView = _tableView;
@synthesize loadingView = _loadingView;

- (id)init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (void)loadView {
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneFiltering:)];
	self.navigationItem.rightBarButtonItem = done;
	[done release];

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

	return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.textLabel.minimumFontSize = 12;
	}

	cell.accessoryType = UITableViewCellAccessoryNone;

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
}

- (void)doneFiltering:(UIBarButtonItem *)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
	self.tableView = nil;
	self.loadingView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	self.tableView = nil;
	self.loadingView = nil;
	[super dealloc];
}

@end
