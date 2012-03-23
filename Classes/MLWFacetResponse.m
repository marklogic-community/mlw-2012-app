//
//  MLWFacetResponse.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWFacetResponse.h"

@implementation MLWFacetResponse

@synthesize facets = _facets;

- (MLWFacetResponse *)initFromData:(NSDictionary *) data {
	self = [super init];
	if(self) {
		NSMutableArray *facets = [NSMutableArray arrayWithCapacity:data.count];
		for(NSString *key in data) {
			[facets addObject:[MLWFacet facetNamed:key fromData:[data objectForKey:key]]];
		}
		_facets = [[NSArray alloc] initWithArray:facets];
	}


	return self;
}

+ (MLWFacetResponse *)responseFromData:(NSDictionary *) data {
	return [[[MLWFacetResponse alloc] initFromData:data] autorelease];
}

- (MLWFacet *)facetNamed:(NSString *) name {
	for(MLWFacet *facet in _facets) {
		if([facet.name isEqualToString:name]) {
			return facet;
		}
	}
	return nil;
}

- (void)dealloc {
	[_facets release];

	[super dealloc];
}

@end
