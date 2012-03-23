//
//  MLWFacet.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWFacetRequest.h"
#import "SBJSON.h"

@implementation MLWFacetRequest

@synthesize constraint = _constraint;

- (id)initWithConstraint:(MLWConstraint *) constraint {
	self = [super init];
	if(self) {
		self.constraint = constraint;
	}
	return self;
}

- (void)fetchResultsForFacets:(NSArray *) facets length:(NSUInteger) length callback:(void (^)(MLWFacetResponse *, NSError *)) callback {
	[self.parameters setObject:[NSString stringWithFormat:@"%i", length] forKey:@"limit"];

	if(self.constraint != nil) {
		[self.parameters setObject:[self.constraint serialize] forKey:@"structuredQuery"];
	}

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/facet/%@", self.baseURL.absoluteString, [facets componentsJoinedByString:@","]]];
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
			NSLog(@"MLWQuery: could not fetch facet results - %@", error);
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, error);
			});
			return;
		}

		SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
		NSDictionary *results = [parser objectWithData:data];
		if(results == nil) {
			NSLog(@"MLWConference: JSON parsing error - %@", parser.error);
			// XXX create NSError
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, nil);
			});
			return;
		}

		dispatch_async(dispatch_get_main_queue(), ^ {
			callback([MLWFacetResponse responseFromData:results], nil);
		});
	});

	[request release];
}

- (void)dealloc {
	self.constraint = nil;

	[super dealloc];
}

@end
