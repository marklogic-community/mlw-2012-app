/*
    MLWSessionSurvey.m
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

#import "MLWSessionSurvey.h"
#import "MLURLRequest.h"
#import "SBJSON.h"

@interface MLWSessionSurvey ()
@property (nonatomic, retain) NSMutableDictionary *results;
@end

@implementation MLWSessionSurvey

@synthesize results;

- (id)initWithSession:(MLWSession *)session {
	self = [super init];
	if(self) {
		self.results = [NSMutableDictionary dictionaryWithCapacity:3];
		[self.results setObject:@"survey" forKey:@"type"];
		[self.results setObject:session.id forKey:@"sessionId"];
		[self.results setObject:[NSNumber numberWithInteger:0] forKey:@"speakerRating"];
		[self.results setObject:[NSNumber numberWithInteger:0] forKey:@"contentRating"];
		[self.results setObject:@"" forKey:@"comments"];
	}

	return self;
}

- (void)setSpeakerRating:(NSInteger) rating {
	[self.results setObject:[NSNumber numberWithInteger:rating] forKey:@"speakerRating"];
}

- (NSInteger)speakerRating {
	return ((NSNumber *)[self.results objectForKey:@"speakerRating"]).integerValue;
}

- (void)setContentRating:(NSInteger) rating {
	[self.results setObject:[NSNumber numberWithInteger:rating] forKey:@"contentRating"];
}

- (NSInteger)contentRating {
	return ((NSNumber *)[self.results objectForKey:@"contentRating"]).integerValue;
}

- (void)setComments:(NSString *) comments {
	[self.results setObject:comments forKey:@"comments"];
}

- (NSString *)comments {
	return (NSString *)[self.results objectForKey:@"comments"];
}

- (void)submit:(void (^)(NSError *)) callback {
	self.baseURL = [NSURL URLWithString:APIBASE];
	NSString *uri = [NSString stringWithFormat:@"/survey/%@.json", [[NSProcessInfo processInfo] globallyUniqueString]];

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/documents?uri=%@&format=json", self.baseURL.absoluteString, [self encodeString:uri]]];
	NSMutableURLRequest *request = [[MLURLRequest alloc] init];
	request.HTTPMethod = @"PUT";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

	request.URL = url;

	SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
	NSString *jsonString = [jsonWriter stringWithObject:self.results];
	request.HTTPBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	[jsonWriter release];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURLResponse *response = nil;
		NSError *error = nil;
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

		if(error != nil) {
			NSLog(@"MLWSessionSurvey: could not submit - %@", error);
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(error);
			});
			return;
		}

		NSLog(@"MLWSessionSurvey: submitted survey to: %@", uri);
		dispatch_async(dispatch_get_main_queue(), ^ {
			callback(nil);
		});
	});

	[request release];
}

- (void)dealloc {
	self.results = nil;
	[super dealloc];
}

@end
