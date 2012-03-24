//
//  CCAndConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCAndConstraint.h"

@implementation CCAndConstraint

- (id)init {
	self = [super init];
	if(self) {
		self.dict = [NSMutableDictionary dictionaryWithObject:[NSMutableArray arrayWithCapacity:20] forKey:@"and"];
	}

	return self;
}

+ (CCAndConstraint *)andConstraints:(CCConstraint *) firstConstraint, ... {
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

	CCAndConstraint *constraint = [[[CCAndConstraint alloc] init] autorelease];
	[constraint.dict setObject:constraints forKey:@"and"];
	return constraint;
}

@end
