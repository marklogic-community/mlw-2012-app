//
//  MLWOrConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWOrConstraint.h"

@implementation MLWOrConstraint

+ (MLWOrConstraint *)orConstraints:(MLWConstraint *)firstConstraint, ... {
	MLWConstraint *eachConstraint;
	va_list constraintList;
	NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:20];

	if(firstConstraint != nil) {
		[constraints addObject:firstConstraint];

		va_start(constraintList, firstConstraint);
		while((eachConstraint = va_arg(constraintList, MLWConstraint *))) {
			[constraints addObject:eachConstraint];
		}
		va_end(constraintList);
	}

	MLWOrConstraint *constraint = [[[MLWOrConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObject:constraints forKey:@"or"];
	return constraint;
}

@end
