//
//  MLWSponsorDetailViewController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSponsorDetailViewController.h"
#import "UITableView+helpers.h"

@interface MLWSponsorDetailViewController ()
@property (nonatomic, retain) MLWSponsorView *sponsorView;
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation MLWSponsorDetailViewController

@synthesize sponsorView = _sponsorView;
@synthesize tableView = _tableView;

- (id)initWithSponsorView:(MLWSponsorView *)sponsorView {
    self = [super init];
    if(self) {
        // Custom initialization
		self.sponsorView = sponsorView;
		self.navigationItem.title = sponsorView.sponsor.name;
    }
    return self;
}

- (void)loadView {
	self.view = [[[UIView alloc] init] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	self.tableView = [[[UITableView alloc] init] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView applyBackground];
	[self.view addSubview:self.tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.sponsorView calculatedHeightWithWidth:self.view.frame.size.width];
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	for(UIView *view in cell.contentView.subviews) {
		[view removeFromSuperview];
	}
	self.sponsorView.frame = cell.contentView.frame;
	[cell.contentView addSubview:self.sponsorView];

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor whiteColor];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)viewDidUnload {
	self.tableView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	self.sponsorView = nil;
	self.tableView = nil;
	[super dealloc];
}

@end
