//
//  MLWOrConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWBooleanConstraint.h"
#import "MLWConstraint.h"

@interface MLWOrConstraint : MLWBooleanConstraint

+ (MLWOrConstraint *)orConstraints:(MLWConstraint *)firstConstraint, ...;

@end
