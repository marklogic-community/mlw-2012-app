/*
    MLWConference.m
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

#import "MLWConference.h"
#import "MLWSpeaker.h"
#import "MLWSession.h"
#import "MLWSponsor.h"
#import "MLWTweet.h"
#import "SBJson.h"
#import "MLSearchRequest.h"
#import "MLAndConstraint.h"
#import "MLKeywordConstraint.h"
#import "MLFacetRequest.h"
#import "MLURLRequest.h"

@interface MLWConference ()
@property (nonatomic, retain) NSArray *sessions;
@property (nonatomic, retain) NSArray *speakers;
@property (nonatomic, retain) NSArray *sponsors;

- (void)populateSpeakers:(void (^)(NSError *)) callback;
- (void)populateUserSchedule:(void (^)(NSError *)) callback;
@end

@implementation MLWConference

@synthesize sessions = _sessions;
@synthesize speakers = _speakers;
@synthesize sponsors = _sponsors;
@synthesize userSchedule;

- (id)init {
	self = [super init];
	if(self) {
		self.sessions = nil;
		self.speakers = nil;
	}
	return self;
}

- (BOOL)fetchSessionsWithConstraint:(MLConstraint *) constraint callback:(void (^)(NSArray *, NSError *)) callback {
	/*
	if(_sessions != nil && _speakers != nil) {
		callback(_sessions, nil);
		return YES;
	}
	*/

	MLAndConstraint *sessionConstraint = [MLAndConstraint andConstraints:[MLKeywordConstraint key:@"type" equals:@"session"], constraint, nil];
    // MLConstraint *sessionConstraint = [MLKeywordConstraint key:@"type" equals:@"session"]; 

    if(self.userSchedule == nil) {
		[self populateUserSchedule:^(NSError *error) {
			if(self.speakers == nil) {
				[self populateSpeakers:^(NSError *error) {
					if(error != nil) {
						callback(nil, error);
						return;
					}
					[self populateSessionsWithConstraint:sessionConstraint callback:^(NSError *error) {
						callback(_sessions, error);
					}];
				}];
			}
			else {
				[self populateSessionsWithConstraint:sessionConstraint callback:^(NSError *error) {
					callback(_sessions, error);
				}];
			}
		}];
	}
	else {
		if(self.speakers == nil) {
			[self populateSpeakers:^(NSError *error) {
				if(error != nil) {
					callback(nil, error);
					return;
				}
				[self populateSessionsWithConstraint:sessionConstraint callback:^(NSError *error) {
					callback(_sessions, error);
				}];
			}];
		}
		else {
			[self populateSessionsWithConstraint:sessionConstraint callback:^(NSError *error) {
				callback(_sessions, error);
			}];
		}
	}

	return NO;
}

- (BOOL)fetchFacetsWithConstraint:(MLConstraint *) constraint callback:(void (^)(MLFacetResponse *, NSError *)) callback {
	MLAndConstraint *sessionConstraint = [MLAndConstraint andConstraints:[MLKeywordConstraint key:@"type" equals:@"session"], constraint, nil];
    // MLConstraint *sessionConstraint = [MLKeywordConstraint key:@"type" equals:@"session"];
    
	MLFacetRequest *request = [[MLFacetRequest alloc] initWithConstraint:sessionConstraint];
	request.baseURL = [NSURL URLWithString:APIBASE];
	request.order = @"ascending";
	[request fetchResultsForFacets:[NSArray arrayWithObjects:@"speaker", @"track", nil] length:10000 callback:callback];
	[request release];
	return NO;
}

- (void)populateSpeakers:(void (^)(NSError *)) callback {
	MLKeywordConstraint *speakerConstraint = [MLKeywordConstraint key:@"type" equals:@"speaker"];
	MLSearchRequest *speakerSearch = [[MLSearchRequest alloc] initWithConstraint:speakerConstraint];
	speakerSearch.baseURL = [NSURL URLWithString:APIBASE];
	[speakerSearch fetchResults:1 length:1000 callback:^(NSDictionary *results, NSError *error) {
		NSMutableArray *speakerObjects = [NSMutableArray arrayWithCapacity:100];
		for(NSDictionary *rawSpeaker in [results objectForKey:@"results"]) {
			MLWSpeaker *speaker = [[MLWSpeaker alloc] initWithData:[rawSpeaker objectForKey:@"content"]];
			[speakerObjects addObject:speaker];
			[speaker release];
		}

		self.speakers = [NSArray arrayWithArray:speakerObjects];
		callback(error);
	}];
	[speakerSearch release];
};

- (void)populateSessionsWithConstraint:(MLConstraint *) constraint callback:(void (^)(NSError *)) callback {
	MLSearchRequest *sessionSearch = [[MLSearchRequest alloc] initWithConstraint:constraint];
	sessionSearch.baseURL = [NSURL URLWithString:APIBASE];
	[sessionSearch fetchResults:1 length:1000 callback:^(NSDictionary *results, NSError *error) {
		NSMutableArray *sessionObjects = [NSMutableArray arrayWithCapacity:100];
		for(NSDictionary *rawSession in [results objectForKey:@"results"]) {
			MLWSession *session = [[MLWSession alloc] initWithData:[rawSession objectForKey:@"content"]];
			[sessionObjects addObject:session];
			[session release];
		}

		self.sessions = [sessionObjects sortedArrayUsingComparator:^(MLWSession *session1, MLWSession *session2) {
			return [session1.startTime compare:session2.startTime];
		}];

		callback(error);
	}];
	[sessionSearch release];
}

- (void)populateUserSchedule:(void (^)(NSError *)) callback {
	NSDictionary *scheduleDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"mlw2012.mySchedule"];
	self.userSchedule = [MLWMySchedule scheduleWithData:scheduleDict];
	callback(nil);
}

- (BOOL)fetchTweets:(void (^)(NSArray *sessions, NSError *error)) callback {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];

		NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=mlw12+OR+marklogic&rpp=50&include_entities=true&result_type=recent"];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		request.URL = url;

		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		[request release];

		if(error != nil || data == nil) {
			NSLog(@"MLWConference: could not fetch latest tweets - %@", error);
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

		NSMutableArray *tweetObjects = [NSMutableArray arrayWithCapacity:100];
		MLWTweet *tweet;
		for(NSDictionary *rawTweet in [results objectForKey:@"results"]) {
			tweet = [[MLWTweet alloc] initWithData:rawTweet];
			[tweetObjects addObject:tweet];
			[tweet release];
		}

		dispatch_async(dispatch_get_main_queue(), ^ {
			callback(tweetObjects, nil);
		});
	});

	return NO;
}

- (BOOL)fetchSponsors:(void (^)(NSArray *sessions, NSError *error)) callback {
	if(_sponsors.count > 0) {
		callback(_sponsors, nil);
		return YES;
	}

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];

		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/documents?uri=/sponsors.json&format=json", APIBASE]];
		NSMutableURLRequest *request = [[MLURLRequest alloc] init];
		request.URL = url;
  

		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		[request release];

		if(error != nil || data == nil) {
			NSLog(@"MLWConference: could not fetch sponsors - %@", error);
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, error);
			});
			return;
		}

		NSArray *results = [parser objectWithData:data];
		if(results == nil) {
			NSLog(@"MLWConference: JSON parsing error - %@", parser.error);
			// XXX create NSError
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, nil);
			});
			return;
		}

		NSMutableArray *sponsorObjects = [NSMutableArray arrayWithCapacity:20];
		MLWSponsor *sponsor;
		for(NSDictionary *rawSponsor in results) {
			sponsor = [[MLWSponsor alloc] initWithData:rawSponsor];
			[sponsorObjects addObject:sponsor];
			[sponsor release];
		}

		dispatch_async(dispatch_get_main_queue(), ^ {
			callback(sponsorObjects, nil);
		});
	});

	return NO;
}

- (void)saveMySchedule:(MLWMySchedule *) schedule {
	[[NSUserDefaults standardUserDefaults] setObject:[schedule serialize] forKey:@"mlw2012.mySchedule"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (MLWSpeaker *)speakerWithId:(NSString *)speakerId {
	for(MLWSpeaker *speaker in self.speakers) {
		if([speaker.id isEqualToString:speakerId]) {
			return speaker;
		}
	}
	return nil;
}

- (NSArray *)sessionsToBlocks:(NSArray *)sessions {
	if(sessions.count == 0) {
		return sessions;
	}

	NSMutableArray *blocks = [NSMutableArray arrayWithCapacity:25];
	NSString *lastHeader = [((MLWSession *)[sessions objectAtIndex:0]).formattedDate copy];
	NSMutableArray *sessionsInBlock = [NSMutableArray arrayWithCapacity:6];

	for(MLWSession *session in sessions) {
		if([session.formattedDate isEqualToString:lastHeader] == NO) {
			[blocks addObject:[NSArray arrayWithArray:sessionsInBlock]];
			[sessionsInBlock removeAllObjects];
			[lastHeader release];
			lastHeader = [session.formattedDate copy];
		}

		[sessionsInBlock addObject:session];
	}

	[blocks addObject:[NSArray arrayWithArray:sessionsInBlock]];
	[lastHeader release];

	return blocks;
}

- (void) dealloc {
	self.sessions = nil;
	self.speakers = nil;
	self.sponsors = nil;
	self.userSchedule = nil;
	[super dealloc];
}

@end
