//
//  MLWQuery.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSearch.h"
#import "SBJSON.h"

@interface MLWSearch ()
@property (nonatomic, retain) NSMutableDictionary *parameters;
- (NSData *)dictionaryToPOSTData:(NSDictionary *) parameters;
@end

@implementation MLWSearch

@synthesize constraint = _constraint;
@synthesize baseURL;
@synthesize parameters = _parameters;

- (id)initWithConstraint:(MLWConstraint *) constraint {
	self = [super init];
	if(self) {
		self.constraint = constraint;
		self.parameters = [NSMutableDictionary dictionaryWithCapacity:20];
		[self.parameters setObject:@"json" forKey:@"outputFormat"];
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
			NSLog(@"MLWQuery: could not fetch results - %@", error);
			dispatch_async(dispatch_get_main_queue(), ^ {
				callback(nil, error);
			});
			return;
		}

		SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
		id results = [parser objectWithData:data];
		if(results == nil) {
			NSLog(@"MLWConference: JSON parsing error - %@", parser.error);
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

- (NSData *)dictionaryToPOSTData:(NSDictionary *) parameters {
	NSMutableString *POSTParams = [[[NSMutableString alloc] init] autorelease];
	for(NSString *key in parameters) {
		NSString *encodedValue = ((NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) [parameters objectForKey:key], NULL, CFSTR("=/:"), kCFStringEncodingUTF8));
		[POSTParams appendString: key];
		[POSTParams appendString: @"="];
		[POSTParams appendString: encodedValue];
		[POSTParams appendString: @"&"];
		[encodedValue release];
	}
	return [POSTParams dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)dealloc {
	self.constraint = nil;
	self.baseURL = nil;
	[super dealloc];
}

@end
