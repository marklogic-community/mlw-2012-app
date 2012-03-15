//
//  MLWSession.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSession.h"

@implementation MLWSession

- (id)initWithData:(NSDictionary *) jsonData {
    self = [super init];
    if(self) {
		// startTime = [[jsonData objectForKey:@"name"] copy];
		// endTime = [[jsonData objectForKey:@"title"] copy];
		plenary = [[jsonData objectForKey:@"plenary"] copy];
		selectable = [[jsonData objectForKey:@"selectable"] copy];
		title = [[jsonData objectForKey:@"title"] copy];
		description = [[jsonData objectForKey:@"description"] copy];
    }
    return self;
}

- (NSDate *)startTime {
	return [NSDate date];
}

- (NSDate *)endTime {
	return [NSDate date];
}

- (BOOL)plenary {
	return [plenary boolValue];
}

- (BOOL)selectable {
	return [selectable boolValue];
}

- (NSString *)title {
	return title;
}

- (NSArray *)speakers {
	return [NSArray arrayWithObjects:nil];
}

- (NSString *)speakerString {
	return @"Matt Carroll – Berico Technologies";
}

- (NSString *)description {
	return description;
}

- (void) dealloc {
	[startTime release];
	[endTime release];
	[plenary release];
	[selectable release];
	[title release];
	[description release];

	[super dealloc];
}


@end
