//
//  MLWSponsor.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

	self.cachedLogoView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)] autorelease];
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
	self.logoURL = nil;
	self.cachedLogoView = nil;

	[super dealloc];
}

@end
