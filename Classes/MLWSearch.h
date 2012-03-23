//
//  MLWQuery.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLWConstraint.h"

@interface MLWSearch : NSObject

- (id)initWithConstraint:(MLWConstraint *) constraint;
- (void)fetchResults:(NSUInteger) start length:(NSUInteger) length callback:(void (^)(id, NSError *)) callback;

@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) MLWConstraint *constraint;

@end
