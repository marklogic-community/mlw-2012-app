/*
    MLWMySchedule.m
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

#import "MLWMySchedule.h"
#import "MLWAppDelegate.h"

@interface MLWMySchedule ()
@property (nonatomic, retain) NSMutableDictionary *dict;
- (void)save;
@end


@implementation MLWMySchedule

@synthesize dict;

- (id)initWithData:(NSDictionary *)data {
	self = [super init];
	if(self) {
		if(data == nil) {
			self.dict = [NSMutableDictionary dictionaryWithCapacity:10];
		}
		else {
			self.dict = [[data mutableCopy] autorelease];
		}
		[self.dict setObject:[NSMutableArray arrayWithArray:[self.dict objectForKey:@"sessions"]] forKey:@"sessions"];
	}

	return self;
}

+ (MLWMySchedule *)scheduleWithData:(NSDictionary *)data {
	return [[[MLWMySchedule alloc] initWithData:data] autorelease];
}

- (NSDictionary *)serialize {
	return self.dict;
}

- (BOOL)hasSession:(MLWSession *)session {
	NSMutableArray *sessionIds = [dict objectForKey:@"sessions"];
	for(NSString *sessionId in sessionIds) {
		if([sessionId isEqualToString:session.id]) {
			return YES;
		}
	}
	return NO;
}

- (void)addSession:(MLWSession *)session {
	if([self hasSession:session]) {
		return;
	}

	[self willChangeValueForKey:@"count"];
	NSMutableArray *sessionIds = [dict objectForKey:@"sessions"];
	[sessionIds addObject:session.id];
	[self save];
	[self didChangeValueForKey:@"count"];
}

- (void)removeSession:(MLWSession *)session {
	if([self hasSession:session] == NO) {
		return;
	}

	NSMutableArray *sessionIds = [dict objectForKey:@"sessions"];
	NSMutableArray *sessionsToDelete = [NSMutableArray arrayWithCapacity:1];
	for(NSString *sessionId in sessionIds) {
		if([sessionId isEqualToString:session.id]) {
			[sessionsToDelete addObject:sessionId];
		}
	}

	[self willChangeValueForKey:@"count"];
	for(NSString *sessionId in sessionsToDelete) {
		[sessionIds removeObject:sessionId];
	}
	[self save];
	[self didChangeValueForKey:@"count"];
}

- (NSUInteger)count {
	NSMutableArray *sessionIds = [dict objectForKey:@"sessions"];
	return sessionIds.count;
}

- (void)save {
	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWConference *conference = appDelegate.conference;
	[conference saveMySchedule:self];
}


- (void)dealloc {
	self.dict = nil;

	[super dealloc];
}

@end
