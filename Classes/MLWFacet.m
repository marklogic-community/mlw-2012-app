//
//  MLWFacet.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWFacet.h"
#import "MLWFacetResult.h"

@implementation MLWFacet

@synthesize name = _name;
@synthesize results = _results;

- (id)initFacetNamed:(NSString *) name fromData:(NSArray *) data {
	self = [super init];
	if(self) {
		_name = [name retain];

		NSMutableArray *results = [NSMutableArray arrayWithCapacity:data.count];
		for(NSDictionary *result in data) {
			MLWFacetResult *facetResult = [[MLWFacetResult alloc] initWithLabel:[result objectForKey:@"value"] count:((NSNumber *)[result objectForKey:@"count"]).integerValue];
			[results addObject:facetResult];
			[facetResult release];
		}

		_results = [[NSArray alloc] initWithArray:results];
	}

	return self;
}

+ (MLWFacet *)facetNamed:(NSString *) name fromData:(NSArray *) data {
	return [[[MLWFacet alloc] initFacetNamed:name fromData:data] autorelease];
}

- (void)dealloc {
	[_name release];
	[_results release];

	[super dealloc];
}

@end
