//
//  MLWBooleanConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWConstraint.h"

@interface MLWBooleanConstraint : MLWConstraint

- (void)addConstraint:(MLWConstraint *) constraint;

- (NSArray *)constraints;
- (NSArray *)rangeConstraintsNamed:(NSString *) name;
- (NSArray *)keywordConstraints;

- (void)removeConstraint:(MLWConstraint *) constraint;
- (void)removeRangeConstraintsNamed:(NSString *) name;
- (void)removeKeywordConstraints;

@end
