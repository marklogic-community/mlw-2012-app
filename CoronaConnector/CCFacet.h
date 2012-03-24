//
//  MLWFacet.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCFacet : NSObject

- (id)initFacetNamed:(NSString *) name fromData:(NSArray *) data;
+ (CCFacet *)facetNamed:(NSString *) name fromData:(NSArray *) data;

@property (readonly) NSString *name;
@property (readonly) NSArray *results;

@end
