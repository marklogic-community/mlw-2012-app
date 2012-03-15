//
//  MLWSponsor.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSponsor.h"

@implementation MLWSponsor

- (id)initWithData:(NSDictionary *) jsonData {
    self = [super init];
    if(self) {
		name = [[jsonData objectForKey:@"name"] copy];
		level = [[jsonData objectForKey:@"level"] copy];
		description = [[jsonData objectForKey:@"description"] copy];
		website = [[jsonData objectForKey:@"website"] copy];
		logoURL = [[NSURL alloc] initWithString:[jsonData objectForKey:@"logoURL"]];
    }
    return self;
}

- (NSString *)name {
	return name;
}

- (NSNumber *)level {
	return level;
}

- (NSString *)description {
	return description;
}

- (NSString *)website {
	return website;
}

- (UIView*)logo {
	if(logoURL == nil) {
		return nil;
	}

	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)] autorelease];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner startAnimating];
	[view addSubview:spinner];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *logoData = [NSData dataWithContentsOfURL:logoURL];
		if(logoData == nil) {
			return;
		}

		dispatch_async(dispatch_get_main_queue(), ^ {
			[spinner removeFromSuperview];

			UIImage *logoImage = [UIImage imageWithData:logoData];
			UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
			[view addSubview:logoImageView];
			[logoImageView release];
		});
	});

	[spinner release];
	return view;
}

- (void)dealloc {
	[name release];
	[level release];
	[description release];
	[website release];
	[logoURL release];

	[super dealloc];
}

@end
