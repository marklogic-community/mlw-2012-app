/*
    MLWSponsor.m
	MarkLogic World
	Created by Ryan Grimm on 3/14/12.

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

#import "MLWSponsor.h"

@interface MLWSponsor ()
@property (nonatomic, retain) NSURL *logoURL;
@property (nonatomic, retain) UIView *cachedLogoView;
@end

@implementation MLWSponsor

@synthesize name = _name;
@synthesize level = _level;
@synthesize description = _description;
@synthesize website = _website;
@synthesize websiteURL = _websiteURL;
@synthesize logo = _logo;
@synthesize logoURL;
@synthesize cachedLogoView;

- (id)initWithData:(NSDictionary *) jsonData {
    self = [super init];
    if(self) {
		_name = [[jsonData objectForKey:@"company"] retain];
		_level = [[jsonData objectForKey:@"level"] retain];
		_description = [[jsonData objectForKey:@"info"] retain];
		_website = [[jsonData objectForKey:@"websitePretty"] retain];
		_websiteURL = [[NSURL URLWithString:[jsonData objectForKey:@"websiteFull"]] retain];
		self.logoURL = [NSURL URLWithString:[jsonData objectForKey:@"imageURL"]];
		self.cachedLogoView = nil;
    }
    return self;
}

- (UIView*)logo {
	if(logoURL == nil) {
		return nil;
	}

	if(self.cachedLogoView != nil) {
		return self.cachedLogoView;
	}

	self.cachedLogoView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 75)] autorelease];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.center = self.cachedLogoView.center;
	[spinner startAnimating];
	[self.cachedLogoView addSubview:spinner];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *logoData = [NSData dataWithContentsOfURL:logoURL];
		if(logoData == nil) {
			return;
		}

		dispatch_async(dispatch_get_main_queue(), ^ {
			[spinner removeFromSuperview];

			UIImage *logoImage = [UIImage imageWithData:logoData];
			UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
			logoImageView.frame = self.cachedLogoView.bounds;
			logoImageView.contentMode = UIViewContentModeScaleAspectFit;
			[self.cachedLogoView addSubview:logoImageView];
			[logoImageView release];
		});
	});

	[spinner release];
	return self.cachedLogoView;
}

- (void)dealloc {
	[_name release];
	[_level release];
	[_description release];
	[_website release];
	[_websiteURL release];
	self.logoURL = nil;
	self.cachedLogoView = nil;

	[super dealloc];
}

@end
