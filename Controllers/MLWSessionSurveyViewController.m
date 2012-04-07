/*
    MLWSessionSurveyViewController.m
	MarkLogic World
	Created by Ryan Grimm on 4/6/12.

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

#import "MLWSessionSurveyViewController.h"
#import "MLWSessionSurvey.h"
#import "UITableView+helpers.h"

@interface MLWSessionSurveyViewController ()
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) MLWSession *session;
@property (nonatomic, retain) UISegmentedControl *speakerTabs;
@property (nonatomic, retain) UISegmentedControl *qualityTabs;
@property (nonatomic, retain) UITextView *comments;
- (void)submit:(UIBarButtonItem *)sender;
@end

@implementation MLWSessionSurveyViewController

@synthesize loadingView = _loadingView;
@synthesize session = _session;
@synthesize speakerTabs = _speakerTabs;
@synthesize qualityTabs = _qualityTabs;
@synthesize comments = _comments;

- (id)initWithSession:(MLWSession *)session {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
		self.session = session;
		self.navigationItem.title = session.title;
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submit:)] autorelease];
    }
    return self;
}

- (void)loadView {
	[super loadView];

	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView applyBackground];

	self.speakerTabs = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Poor", @"Fair", @"Avg", @"Good", @"Great", nil]] autorelease];
	self.speakerTabs.tintColor = [UIColor colorWithWhite:0.5 alpha:1];
	self.speakerTabs.segmentedControlStyle = UISegmentedControlStyleBar;

	self.qualityTabs = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Poor", @"Fair", @"Avg", @"Good", @"Great", nil]] autorelease];
	self.qualityTabs.tintColor = [UIColor colorWithWhite:0.5 alpha:1];
	self.qualityTabs.segmentedControlStyle = UISegmentedControlStyleBar;

	self.comments = [[[UITextView alloc] init] autorelease];

	self.loadingView = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
	self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.loadingView.backgroundColor = [UIColor blackColor];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = self.loadingView.center;
	spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[spinner startAnimating];
	[self.loadingView addSubview:spinner];
    [spinner release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return @"Effectiveness of speaker";
	}
	if(section == 1) {
		return @"Quality of content";
	}
	if(section == 2) {
		return @"Comments";
	}
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
	if(sectionTitle == nil) {
		return nil;
	}

	UILabel *label = [[UILabel alloc] init];
	label.frame = CGRectMake(20, 6, 300, 30);
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(0.0, 2.0);
	label.font = [UIFont boldSystemFontOfSize:16];
	label.text = sectionTitle;

	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	[view addSubview:label];
	[label release];

	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 2) {
		return 175;
	}
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	CGRect frame = cell.contentView.bounds;
	frame.size.height = frame.size.height + 2;

	if(indexPath.section == 0) {
		self.speakerTabs.frame = frame;
		[cell.contentView addSubview:self.speakerTabs];
	}
	else if(indexPath.section == 1) {
		self.qualityTabs.frame = frame;
		[cell.contentView addSubview:self.qualityTabs];
	}
	else if(indexPath.section == 2) {
		self.comments.frame = CGRectInset(frame, 5, 5);
		[cell.contentView addSubview:self.comments];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)submit:(UIBarButtonItem *)sender {
	self.loadingView.frame = self.view.frame;
	[self.view addSubview:self.loadingView];

	MLWSessionSurvey *survey = [[MLWSessionSurvey alloc] initWithSession:self.session];
	if(self.speakerTabs.selectedSegmentIndex != UISegmentedControlNoSegment) {
		survey.speakerRating = self.speakerTabs.selectedSegmentIndex + 1;
	}
	if(self.qualityTabs.selectedSegmentIndex != UISegmentedControlNoSegment) {
		survey.contentRating = self.qualityTabs.selectedSegmentIndex + 1;
	}
	survey.comments = self.comments.text;

	[survey submit:^(NSError *error) {
		if(error == nil) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
	[survey release];
}

- (void)viewDidUnload {
	self.loadingView = nil;
	self.speakerTabs = nil;
	self.qualityTabs = nil;
	self.comments = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	self.loadingView = nil;
	self.session = nil;
	self.speakerTabs = nil;
	self.qualityTabs = nil;
	self.comments = nil;
    [super dealloc];
}

@end
