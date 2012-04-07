/*
    CCAndConstraint.m
	Corona Connector
    Created by Ryan Grimm on 3/22/12.

	Copyright 2012 MarkLogic

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

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
