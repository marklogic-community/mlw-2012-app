/*
    MLWTweet.m
	MarkLogic World
	Created by Ryan Grimm on 3/19/12.

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

#import "MLWTweet.h"
#import <ImageIO/ImageIO.h>

@interface MLWTweet ()
- (NSDate *)stringToDate:(NSString *) dateString;
@end

@implementation MLWTweet

@synthesize id = _id;
@synthesize name = _name;
@synthesize username = _username;
@synthesize content = _content;
@synthesize date = _date;
@synthesize profileImageURL = _profileImageURL;

- (id)initWithData:(NSDictionary *) jsonData {
	self = [super init];
	if(self) {
		_id = [[jsonData objectForKey:@"id_str"] retain];
		_name = [[jsonData objectForKey:@"from_user_name"] retain];
		_username = [[jsonData objectForKey:@"from_user"] retain];
		_content = [[jsonData objectForKey:@"text"] retain];
		_date = [[self stringToDate:[jsonData objectForKey:@"created_at"]] retain];
		NSString *profileImageString = [jsonData objectForKey:@"profile_image_url"];

		if([profileImageString isKindOfClass:[NSNull class]] || profileImageString.length == 0) {
			[_profileImageURL release];
			_profileImageURL = nil;
		}
		else {
			_profileImageURL = [[NSURL URLWithString:profileImageString] retain];
		}
	}
	return self;
}

- (NSDate *)stringToDate:(NSString *) dateString {
	// Mon, 19 Mar 2012 20:38:10 +0000
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
	return [dateFormat dateFromString:dateString];
}

- (NSString *)dateString {
	int number;
	NSString *units;

	NSInteger interval = abs((NSInteger)[self.date timeIntervalSinceDate:[NSDate date]]);
	if(interval >= 86400) {
		number = interval / 86400;
		units = @"day";
	}
	else {
		if(interval >= 3600) {
			number = interval / 3600;
			units = @"hour";
		}
		else if(interval >= 60) {
			number = interval / 60;
			units = @"minute";
		}
		else {
			number = interval;
			units = @"seconds";
		}
	}

	if(number != 1) {
		units = [NSString stringWithFormat:@"%@s", units];
	}
	return [NSString stringWithFormat:@"%i %@ ago", number, units];
}

- (void) dealloc {
	[_name release];
	[_username release];
	[_content release];
	[_date release];
	[_profileImageURL release];
	[_id release];

	[super dealloc];
}

@end
