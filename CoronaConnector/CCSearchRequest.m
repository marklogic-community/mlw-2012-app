/*
    CCSearchRequest.m
	Corona Connector
    Created by Ryan Grimm on 3/22/12.

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

#import "CCSearchRequest.h"
#import "SBJSON.h"

@implementation CCSearchRequest

@synthesize constraint = _constraint;

- (id)initWithConstraint:(CCConstraint *) constraint {
	self = [super init];
	if(self) {
		self.constraint = constraint;
	}
	return self;
}

- (void)fetchResults:(NSUInteger) start length:(NSUInteger) length callback:(void (^)(id, NSError *)) callback {
	[self.parameters setObject:[NSString stringWithFormat:@"%i", start] forKey:@"start"];
	[self.parameters setObject:[NSString stringWithFormat:@"%i", length] forKey:@"length"];

	if(self.constraint != nil) {
		[self.parameters setObject:[self.constraint serialize] forKey:@"structuredQuery"];
	}

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/search", self.baseURL.absoluteString]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [self dictionaryToPOSTData:self.parameters];
	request.URL = url;

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

		if(error != nil || data == nil) {
			NSLog(@"CCSearchRequest: could not fetch results - %@", error);
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, error);
			});
			return;
		}

		SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
		id results = [parser objectWithData:data];
		if(results == nil) {
			NSLog(@"CCSearchRequest: JSON parsing error - %@", parser.error);
			// XXX create NSError
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, nil);
			});
			return;
		}

		dispatch_async(dispatch_get_main_queue(), ^ {
			callback(results, nil);
		});
	});

	[request release];
}

- (void)dealloc {
	self.constraint = nil;

	[super dealloc];
}

@end
