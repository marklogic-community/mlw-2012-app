/*
    UITableView+helpers.m
	MarkLogic World
	Created by Ryan Grimm on 3/18/12.

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

#import "UITableView+helpers.h"

@implementation UITableView (helpers)

- (void)applyBackground {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fabric"]];
    self.backgroundView = bgView;
    [bgView release];
}

- (UIView *)createHeaderForSection:(NSInteger) section {
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)] autorelease];
	headerView.backgroundColor = [UIColor whiteColor];

	UIView *colorView = [[UIView alloc] initWithFrame:headerView.frame];
	colorView.backgroundColor = [UIColor colorWithRed:(236.0f/255.0f) green:(125.0f/255.0f) blue:(30.0f/255.0f) alpha:0.5f];
	[headerView addSubview:colorView];

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(headerView.frame, 10, 0)];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16];
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0.0, 1.0);
	label.text = [self.dataSource tableView:self titleForHeaderInSection:section];

	[colorView addSubview:label];
    [label release];
	[colorView release];

	return headerView;
}

@end
