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


- (NSString *)language {
	return [self.parameters objectForKey:@"language"];
}

- (void)setLanguage:(NSString *) language {
	[self.parameters setObject:language forKey:@"language"];
}

- (NSString *)order {
	return [self.parameters objectForKey:@"order"];
}

- (void)setOrder:(NSString *) order {
	[self.parameters setObject:order forKey:@"order"];
}

- (NSString *)frequency {
	return [self.parameters objectForKey:@"frequency"];
}

- (void)setFrequency:(NSString *) frequency {
	[self.parameters setObject:frequency forKey:@"frequency"];
}

- (BOOL)includeAllValues {
	return ((NSNumber *)[self.parameters objectForKey:@"includeAllValues"]).boolValue;
}

- (void)setIncludeAllValues:(BOOL) includeAllValues {
	[self.parameters setObject:[NSNumber numberWithBool:includeAllValues] forKey:@"includeAllValues"];
}

- (NSString *)collection {
	return [self.parameters objectForKey:@"collection"];
}

- (void)setCollection:(NSString *) collection {
	[self.parameters setObject:collection forKey:@"collection"];
}

- (NSString *)underDirectory {
	return [self.parameters objectForKey:@"underDirectory"];
}

- (void)setUnderDirectory:(NSString *) underDirectory {
	[self.parameters setObject:underDirectory forKey:@"underDirectory"];
}

- (NSString *)inDirectory {
	return [self.parameters objectForKey:@"inDirectory"];
}

- (void)setInDirectory:(NSString *) inDirectory {
	[self.parameters setObject:inDirectory forKey:@"inDirectory"];
}

- (void)dealloc {
	self.constraint = nil;

	[super dealloc];
}

@end
