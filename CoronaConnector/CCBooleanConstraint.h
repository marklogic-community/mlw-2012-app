//
//  CCBooleanConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCConstraint.h"

@interface CCBooleanConstraint : CCConstraint

- (void)addConstraint:(CCConstraint *) constraint;

- (NSArray *)constraints;
- (NSArray *)rangeConstraintsNamed:(NSString *) name;
- (NSArray *)keywordConstraints;
- (NSArray *)stringQueryConstraints;

- (void)removeConstraint:(CCConstraint *) constraint;
- (void)removeRangeConstraintsNamed:(NSString *) name;
- (void)removeKeywordConstraints;
- (void)removeStringQueryConstraints;

@end
