//
//  MLWFacet.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWRequest.h"
#import "MLWConstraint.h"
#import "MLWFacetResponse.h"

@interface MLWFacetRequest : MLWRequest

- (id)initWithConstraint:(MLWConstraint *) constraint;
- (void)fetchResultsForFacets:(NSArray *) facets length:(NSUInteger) length callback:(void (^)(MLWFacetResponse *, NSError *)) callback;

@property (nonatomic, retain) MLWConstraint *constraint;

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *frequency;
@property BOOL includeAllValues;
@property (nonatomic, copy) NSString *collection;
@property (nonatomic, copy) NSString *underDirectory;
@property (nonatomic, copy) NSString *inDirectory;

@end
