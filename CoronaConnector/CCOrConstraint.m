//
//  MLWOrConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCOrConstraint.h"

@implementation CCOrConstraint

- (id)init {
	self = [super init];
	if(self) {
		self.dict = [NSMutableDictionary dictionaryWithObject:[NSMutableArray arrayWithCapacity:20] forKey:@"or"];
	}

	return self;
}

+ (CCOrConstraint *)orConstraints:(CCConstraint *)firstConstraint, ... {
	CCConstraint *eachConstraint;
	va_list constraintList;
	NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:20];

	if(firstConstraint != nil) {
		[constraints addObject:firstConstraint];

		va_start(constraintList, firstConstraint);
		while((eachConstraint = va_arg(constraintList, CCConstraint *))) {
			[constraints addObject:eachConstraint];
		}
		va_end(constraintList);
	}

	CCOrConstraint *constraint = [[[CCOrConstraint alloc] init] autorelease];
	[constraint.dict setObject:constraints forKey:@"or"];
	return constraint;
}

@end
