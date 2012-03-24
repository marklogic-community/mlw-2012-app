//
//  MLWFacet.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCRequest.h"
#import "CCConstraint.h"
#import "CCFacetResponse.h"

@interface CCFacetRequest : CCRequest

- (id)initWithConstraint:(CCConstraint *) constraint;
- (void)fetchResultsForFacets:(NSArray *) facets length:(NSUInteger) length callback:(void (^)(CCFacetResponse *, NSError *)) callback;

@property (nonatomic, retain) CCConstraint *constraint;

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *frequency;
@property BOOL includeAllValues;
@property (nonatomic, copy) NSString *collection;
@property (nonatomic, copy) NSString *underDirectory;
@property (nonatomic, copy) NSString *inDirectory;

@end
