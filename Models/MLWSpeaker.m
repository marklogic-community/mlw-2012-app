//
//  MLWSpeaker.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSpeaker.h"

@implementation MLWSpeaker

@synthesize id = _id;
@synthesize name = _name;
@synthesize title = _title;
@synthesize organization = _organization;
@synthesize email = _email;
@synthesize bio = _bio;

- (id)initWithData:(NSDictionary *) jsonData {
    self = [super init];
    if(self) {
		_id = [[jsonData objectForKey:@"id"] retain];
		_name = [[jsonData objectForKey:@"name"] retain];
		_title = [[jsonData objectForKey:@"title"] retain];
		_organization = [[jsonData objectForKey:@"affiliation"] retain];
		_email = [[jsonData objectForKey:@"email"] retain];
		_bio = [[jsonData objectForKey:@"bio"] retain];

		if([_email isKindOfClass:[NSNull class]] || _email.length == 0) {
			[_email release];
			_email = nil;
		}
    }
    return self;
}

- (void) dealloc {
	[_id release];
	[_name release];
	[_title release];
	[_organization release];
	[_email release];
	[_bio release];

	[super dealloc];
}


@end
