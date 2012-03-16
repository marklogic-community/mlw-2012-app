//
//  MLWConference.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWConference.h"
#import "MLWSpeaker.h"
#import "MLWSession.h"
#import "MLWSponsor.h"
#import "SBJson.h"

@interface MLWConference ()
@property (nonatomic, retain) NSArray *sessions;
@property (nonatomic, retain) NSArray *speakers;
@end

@implementation MLWConference

@synthesize sessions = _sessions;
@synthesize speakers = _speakers;

- (id)init {
    self = [super init];
    if(self) {
		self.sessions = nil;
		self.speakers = nil;
    }
    return self;
}

- (BOOL)fetchSessions:(void (^)(NSArray *, NSError *)) callback {
	if(_sessions != nil && _speakers != nil) {
		callback(_sessions, nil);
		return YES;
	}

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		SBJsonParser *parser = [[SBJsonParser alloc] init];

		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/kvquery?key=type&value=speaker&length=1000&&outputFormat=json", CORONABASE]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		request.URL = url;

		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		[request release];

		if(error != nil || data == nil) {
			NSLog(@"MLWConference: could not fetch list of speakers - %@", error);
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, error);
			});
			return;
		}

		NSDictionary *results = [parser objectWithData:data];
		if(results == nil) {
			NSLog(@"MLWConference: JSON parsing error - %@", parser.error);
			// XXX create NSError
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, nil);
			});
			return;
		}

		NSMutableArray *speakerObjects = [NSMutableArray arrayWithCapacity:100];
		MLWSpeaker *speaker;
		for(NSDictionary *rawSpeaker in [results objectForKey:@"results"]) {
			speaker = [[MLWSpeaker alloc] initWithData:[rawSpeaker objectForKey:@"content"]];
			[speakerObjects addObject:speaker];
			[speaker release];
		}

		self.speakers = [NSArray arrayWithArray:speakerObjects];


		url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/kvquery?key=type&value=session&length=1000&&outputFormat=json", CORONABASE]];
		request = [[NSMutableURLRequest alloc] init];
		request.URL = url;

		response = nil;
		error = nil;
		data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		[request release];

		if(error != nil || data == nil) {
			NSLog(@"MLWConference: could not fetch list of sessions - %@", error);
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, error);
			});
			return;
		}

		results = [parser objectWithData:data];
		if(results == nil) {
			NSLog(@"MLWConference: JSON parsing error - %@", parser.error);
			// XXX create NSError
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, nil);
			});
			return;
		}

		NSMutableArray *sessionObjects = [NSMutableArray arrayWithCapacity:100];
		MLWSession *session;
		for(NSDictionary *rawSession in [results objectForKey:@"results"]) {
			session = [[MLWSession alloc] initWithData:[rawSession objectForKey:@"content"]];
			[sessionObjects addObject:session];
			[session release];
		}

		self.sessions = [sessionObjects sortedArrayUsingComparator:^(MLWSession *session1, MLWSession *session2) {
			return [session1.startTime compare:session2.startTime];
		}];

		dispatch_async(dispatch_get_main_queue(), ^ {
			callback(_sessions, nil);
		});
	});

	return NO;
}

- (BOOL)fetchSponsors:(void (^)(NSArray *sessions, NSError *error)) callback {
	return YES;
}

- (BOOL)fetchTweets:(void (^)(NSArray *sessions, NSError *error)) callback {
	return YES;
}

- (MLWSpeaker *)speakerWithId:(NSString *)speakerId {
	for(MLWSpeaker *speaker in self.speakers) {
		if([speaker.id isEqualToString:speakerId]) {
			return speaker;
		}
	}
	return nil;
}

- (void) dealloc {
	self.sessions = nil;
	self.speakers = nil;
	[super dealloc];
}

@end
