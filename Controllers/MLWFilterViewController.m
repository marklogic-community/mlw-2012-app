/*
    MLWFilterViewController.m
	MarkLogic World
	Created by Ryan Grimm on 3/22/12.

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

#import "MLWFilterViewController.h"
#import "UITableView+helpers.h"
#import "MLWAppDelegate.h"
#import "MLFacetResponse.h"
#import "MLFacetResult.h"
#import "MLAndConstraint.h"
#import "MLRangeConstraint.h"
#import "MLStringQueryConstraint.h"

@interface MLWFilterViewController ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UISegmentedControl *tabs;
@property (nonatomic, retain) MLFacetResponse *facetResponse;
@property (nonatomic, retain) MLAndConstraint *constraint;
@property (nonatomic, retain) UITextField *searchField;
@property (nonatomic, retain) NSArray *cachedResultsForCurrentFacet;

- (void)changeTab:(UISegmentedControl *)sender;
- (void)resetFiltering:(UIBarButtonItem *)sender;
- (void)doneFiltering:(UIBarButtonItem *)sender;
- (NSString *)facetNameForCurrentFacet;
- (NSArray *)resultsForCurrentFacet;
- (MLRangeConstraint *)rangeConstraintForCurrentFacet;
@end

@implementation MLWFilterViewController

@synthesize delegate;
@synthesize tableView = _tableView;
@synthesize loadingView = _loadingView;
@synthesize tabs = _tabs;
@synthesize facetResponse = _facetResponse;
@synthesize constraint = _constraint;
@synthesize searchField = _searchField;
@synthesize cachedResultsForCurrentFacet;

- (id)init {
    self = [super init];
    if(self) {
		self.navigationItem.title = @"Filter Sessions";
		self.constraint = [[[MLAndConstraint alloc] init] autorelease];
		self.searchField = [[[UITextField alloc] init] autorelease];
		self.searchField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.searchField.clearButtonMode = UITextFieldViewModeAlways;
		self.searchField.keyboardAppearance = UIKeyboardAppearanceAlert;
		self.searchField.returnKeyType = UIReturnKeyDone;
		self.searchField.delegate = self;
    }
    return self;
}

- (void)loadView {
	UIBarButtonItem *reset = [[UIBarButtonItem alloc] initWithTitle:@"Clear Filters" style:UIBarButtonItemStylePlain target:self action:@selector(resetFiltering:)];
	self.navigationItem.leftBarButtonItem = reset;
	[reset release];
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneFiltering:)];
	self.navigationItem.rightBarButtonItem = done;
	[done release];

	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fabric"]];

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

	self.tabs = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Keyword", @"Track", @"Speaker", nil]] autorelease];
	self.tabs.tintColor = [UIColor colorWithWhite:0.5 alpha:1];
	self.tabs.segmentedControlStyle = UISegmentedControlStyleBar;
	self.tabs.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
	self.tabs.frame = CGRectMake(10, 10, 300, 32);
	[self.tabs addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventValueChanged];
	self.tabs.selectedSegmentIndex = 0;
	[self.view addSubview:self.tabs];

	self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 47, 320, 433) style:UITableViewStyleGrouped] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.tableView];

	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	BOOL cached = [conference fetchFacetsWithConstraint:nil callback:^(MLFacetResponse *response, NSError *error) {
		self.facetResponse = response;
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if(self.tabs.selectedSegmentIndex == 0) {
		return 1;
	}
	return [self resultsForCurrentFacet].count;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	NSString *cellIdentifier = @"Cell";
	if(self.tabs.selectedSegmentIndex == 0) {
		cellIdentifier = @"SearchCell";
	}

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.textLabel.minimumFontSize = 12;
	}

	cell.accessoryType = UITableViewCellAccessoryNone;

	if(self.tabs.selectedSegmentIndex != 0) {
		NSArray *results = [self resultsForCurrentFacet];
		MLFacetResult *facetResult = [results objectAtIndex:indexPath.row];
		cell.textLabel.text = facetResult.label;
		if(self.tabs.selectedSegmentIndex == 1) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", facetResult.count];
		}
		else {
			cell.detailTextLabel.text = @"";
		}

		for(NSString *selectedFacetValue in [self rangeConstraintForCurrentFacet].values) {
			if([selectedFacetValue isEqualToString:facetResult.label]) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
	}
	else {
		MLStringQueryConstraint *constraint = (MLStringQueryConstraint *)[[self.constraint stringQueryConstraints] lastObject];
		self.searchField.text = constraint.query;
		self.searchField.frame = CGRectInset(cell.contentView.bounds, 7, 9);
		[self.searchField becomeFirstResponder];
		[cell.contentView addSubview:self.searchField];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	if(indexPath.section != 2) {
		MLRangeConstraint *rangeConstraint = [self rangeConstraintForCurrentFacet];
		MLFacetResult *facetResult = [[self resultsForCurrentFacet] objectAtIndex:indexPath.row];

		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		if(cell.accessoryType == UITableViewCellAccessoryNone) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			if(rangeConstraint != nil) {
				[rangeConstraint addValue:facetResult];
			}
			else {
				[self.constraint addConstraint:[MLRangeConstraint rangeNamed:[self facetNameForCurrentFacet] value:facetResult]];
			}
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			[rangeConstraint removeValue:facetResult];
		}

		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (void)changeTab:(UISegmentedControl *)sender {
	self.cachedResultsForCurrentFacet = nil;
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)resetFiltering:(UIBarButtonItem *)sender {
	self.constraint = [[[MLAndConstraint alloc] init] autorelease];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[self doneFiltering:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self doneFiltering:nil];
	return YES;
}

- (void)doneFiltering:(UIBarButtonItem *)sender {
	MLStringQueryConstraint *constraint = (MLStringQueryConstraint *)[[self.constraint stringQueryConstraints] lastObject];
	if(self.searchField.text.length != 0) {
		if(constraint != nil) {
			constraint.query = self.searchField.text.lowercaseString;
		}
		else {
			[self.constraint addConstraint:[MLStringQueryConstraint stringQuery:self.searchField.text.lowercaseString]];
		}
	}
	else if(constraint != nil) {
		[self.constraint removeStringQueryConstraints];
	}

	NSLog(@"MLWFilterViewController: constructed constraint: %@", [self.constraint serialize]);
	if(delegate != nil && [delegate respondsToSelector:@selector(filterView:constructedConstraint:)]) {
		[delegate filterView:self constructedConstraint:self.constraint];
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (NSString *)facetNameForCurrentFacet {
	if(self.tabs.selectedSegmentIndex == 1) {
		return @"track";
	}
	if(self.tabs.selectedSegmentIndex == 2) {
		return @"speaker";
	}
	return nil;
}

- (NSArray *)resultsForCurrentFacet {
	if(cachedResultsForCurrentFacet != nil) {
		return cachedResultsForCurrentFacet;
	}

	NSString *facetName = [self facetNameForCurrentFacet];
	NSArray *results = [self.facetResponse facetNamed:facetName].results;
	if([facetName isEqualToString:@"speaker"]) {
		results = [results sortedArrayUsingComparator:^(MLFacetResult *result1, MLFacetResult *result2) {
			NSString *cleaned1 = [result1.label stringByReplacingOccurrencesOfString:@"Admiral " withString:@""];
			cleaned1 = [cleaned1 stringByReplacingOccurrencesOfString:@"Dr. " withString:@""];
			NSString *cleaned2 = [result2.label stringByReplacingOccurrencesOfString:@"Admiral " withString:@""];
			cleaned2 = [cleaned2 stringByReplacingOccurrencesOfString:@"Dr. " withString:@""];

			return [cleaned1 localizedCompare:cleaned2];
		}];
	}

	if([facetName isEqualToString:@"track"]) {
		NSMutableArray *filteredResults = [NSMutableArray arrayWithCapacity:results.count];
		for(MLFacetResult *result in results) {
			if([result.label isEqualToString:@""]) {
				continue;
			}
			[filteredResults addObject:result];
		}
		results = filteredResults;
	}

	self.cachedResultsForCurrentFacet = results;
	return results;
}

- (MLRangeConstraint *)rangeConstraintForCurrentFacet {
	return (MLRangeConstraint *)[[self.constraint rangeConstraintsNamed:[self facetNameForCurrentFacet]] lastObject];
}

- (void)viewDidUnload {
	self.tableView = nil;
	self.loadingView = nil;
	self.tabs = nil;
	self.facetResponse = nil;
	self.cachedResultsForCurrentFacet = nil;

    [super viewDidUnload];
}

- (void)dealloc {
	self.delegate = nil;
	self.tableView = nil;
	self.loadingView = nil;
	self.tabs = nil;
	self.facetResponse = nil;
	self.constraint = nil;
	self.searchField = nil;
	self.cachedResultsForCurrentFacet = nil;

	[super dealloc];
}

@end
