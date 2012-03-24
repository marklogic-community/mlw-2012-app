//
//  CCSearchRequest.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
