/*
    CCFacet.m
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
