//
//  MLWSpeaker.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSpeaker.h"

@implementation MLWSpeaker

- (id)initWithData:(NSDictionary *) jsonData {
    self = [super init];
    if(self) {
		name = [[jsonData objectForKey:@"name"] copy];
		title = [[jsonData objectForKey:@"title"] copy];
		organization = [[jsonData objectForKey:@"organization"] copy];
		email = [[jsonData objectForKey:@"email"] copy];
		bio = [[jsonData objectForKey:@"bio"] copy];
    }
    return self;
}

- (NSString *)name {
	return name;
}

- (NSString *)title {
	return title;
}

- (NSString *)organization {
	return organization;
}

- (NSString *)contact {
	return email;
}

- (NSString *)bio {
	return bio;
}

- (NSArray *)sessions {
	return [NSArray arrayWithObjects:nil];
}

- (void) dealloc {
	[name release];
	[title release];
	[organization release];
	[email release];
	[bio release];

	[super dealloc];
}


@end
