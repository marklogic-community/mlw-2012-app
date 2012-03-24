//
//  MLWFacet.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCFacet.h"
#import "CCFacetResult.h"

@implementation CCFacet

@synthesize name = _name;
@synthesize results = _results;

- (id)initFacetNamed:(NSString *) name fromData:(NSArray *) data {
	self = [super init];
	if(self) {
		_name = [name retain];

		NSMutableArray *results = [NSMutableArray arrayWithCapacity:data.count];
		for(NSDictionary *result in data) {
			CCFacetResult *facetResult = [[CCFacetResult alloc] initWithLabel:[result objectForKey:@"value"] count:((NSNumber *)[result objectForKey:@"count"]).integerValue];
			[results addObject:facetResult];
			[facetResult release];
		}

		_results = [[NSArray alloc] initWithArray:results];
	}

	return self;
}

+ (CCFacet *)facetNamed:(NSString *) name fromData:(NSArray *) data {
	return [[[CCFacet alloc] initFacetNamed:name fromData:data] autorelease];
}

- (void)dealloc {
	[_name release];
	[_results release];

	[super dealloc];
}

@end
