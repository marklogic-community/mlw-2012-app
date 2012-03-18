//
//  MLWSessionDetailController.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSessionDetailController.h"
#import "UITableView+helpers.h"

@interface MLWSessionDetailController ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) MLWSession *session;
@end

@implementation MLWSessionDetailController

@synthesize tableView = _tableView;
@synthesize session = _session;

- (id)initWithSession:(MLWSession *)session {
    self = [super init];
    if(self) {
		self.session = session;
		self.navigationItem.title = session.title;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
	self.view = [[[UIView alloc] init] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
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
	return 3;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if(section == 0) {
		if(self.session.track != nil) {
			return 5;
		}
		else {
			return 4;
		}
	}
	if(section == 1) {
		return 1;
	}
	if(section == 2) {
		return self.session.speakers.count;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return @"Session Information";
	}
	if(section == 1) {
		return @"Abstract";
	}
	if(section == 2) {
		if(self.session.speakers.count == 1) {
			return @"Presenter";
		}
		else {
			return @"Presenters";
		}
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
	if(indexPath.section == 1) {
		return [self.session.abstract sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width - 40, 10000)].height + 10;
	}
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	NSString *cellIdentifier;
	if(indexPath.section == 0) {
		if(indexPath.row == 0) {
			cellIdentifier = @"DefaultCell";
		}
		else {
			cellIdentifier = @"Value2Cell";
		}
	}
	else if(indexPath.section == 1) {
		cellIdentifier = @"DefaultCell";
	}
	else if(indexPath.section == 2) {
		cellIdentifier = @"PresenterCell";
	}

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil) {
		if([cellIdentifier isEqualToString:@"DefaultCell"]) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		}
		else if([cellIdentifier isEqualToString:@"Value2Cell"]) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier] autorelease];
		}
		else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		}
	}

	if(indexPath.section == 0) {
		if(indexPath.row != 0) {
			cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
		}

		switch (indexPath.row) {
			case 0:
				cell.textLabel.adjustsFontSizeToFitWidth = YES;
				cell.textLabel.minimumFontSize = 10;
				cell.textLabel.numberOfLines = 0;
				cell.textLabel.text = self.session.title;
				break;
			case 1:
				cell.textLabel.text = @"Day";
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:@"EEEE"];
				cell.detailTextLabel.text = [formatter stringFromDate:self.session.startTime];
				[formatter release];
				break;
			case 2:
				cell.textLabel.text = @"Time";
				cell.detailTextLabel.text = self.session.formattedTime;
				break;
			case 3:
				cell.textLabel.text = @"Room";
				cell.detailTextLabel.text = self.session.location;
				break;
			case 4:
				cell.textLabel.text = @"Track";
				cell.detailTextLabel.text = self.session.track;
				break;
		}
	}
	else if(indexPath.section == 1) {
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.textLabel.text = self.session.abstract;
	}
	else if(indexPath.section == 2) {
		cellIdentifier = @"PresenterCell";
	}

	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)viewDidUnload {
	self.view = nil;
	self.tableView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	self.view = nil;
	self.tableView = nil;
	self.session = nil;
    [super dealloc];
}

@end
