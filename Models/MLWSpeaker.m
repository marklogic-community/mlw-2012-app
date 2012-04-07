/*
    MLWSpeaker.m
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

		if([_bio isKindOfClass:[NSNull class]] || _bio.length == 0) {
			[_bio release];
			_bio = nil;
		}
		if([_title isKindOfClass:[NSNull class]] || _title.length == 0) {
			[_title release];
			_title = nil;
		}
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
