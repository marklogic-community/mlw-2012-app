/*
    MLWSponsorDetailViewController.m
	MarkLogic World
	Created by Ryan Grimm on 4/5/12.

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
	[[UIApplication sharedApplication] openURL:self.sponsorView.sponsor.websiteURL];
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
