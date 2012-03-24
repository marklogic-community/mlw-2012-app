//
//  MLWFacetResponse.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCFacetResponse.h"

@implementation CCFacetResponse

@synthesize facets = _facets;

- (CCFacetResponse *)initFromData:(NSDictionary *) data {
	self = [super init];
	if(self) {
		NSMutableArray *facets = [NSMutableArray arrayWithCapacity:data.count];
		for(NSString *key in data) {
			[facets addObject:[CCFacet facetNamed:key fromData:[data objectForKey:key]]];
		}
		_facets = [[NSArray alloc] initWithArray:facets];
	}


	return self;
}

+ (CCFacetResponse *)responseFromData:(NSDictionary *) data {
	return [[[CCFacetResponse alloc] initFromData:data] autorelease];
}

- (CCFacet *)facetNamed:(NSString *) name {
	for(CCFacet *facet in _facets) {
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
