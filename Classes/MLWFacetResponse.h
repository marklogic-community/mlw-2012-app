//
//  MLWFacetResponse.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWFacet.h"

@interface MLWFacetResponse : NSObject

+ (MLWFacetResponse *)responseFromData:(NSDictionary *) data;

- (MLWFacet *)facetNamed:(NSString *) name;

@property (readonly) NSArray *facets;

@end
