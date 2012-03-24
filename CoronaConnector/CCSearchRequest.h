//
//  CCQuery.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCRequest.h"
#import "CCConstraint.h"

@interface CCSearchRequest : CCRequest

- (id)initWithConstraint:(CCConstraint *) constraint;
- (void)fetchResults:(NSUInteger) start length:(NSUInteger) length callback:(void (^)(id, NSError *)) callback;

@property (nonatomic, retain) CCConstraint *constraint;

@end
