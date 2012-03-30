//
//  MLWMySchedule.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
			self.dict = [data mutableCopy];
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
