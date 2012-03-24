//
//  CCFacetResult.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCFacetResult.h"

@implementation CCFacetResult

@synthesize label = _label;
@synthesize count = _count;

- (id)initWithLabel:(NSString *) label count:(NSUInteger ) count {
	self = [super init];
	if(self) {
		_label = [label copy];
		_count = count;
	}
	return self;
}

- (void)dealloc {
	[_label release];

	[super dealloc];
}

@end
