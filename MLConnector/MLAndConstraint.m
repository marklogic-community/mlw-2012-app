/*
    MLAndConstraint.m
	ML Connector
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

#import "MLAndConstraint.h"

@implementation MLAndConstraint

- (id)init {
	self = [super init];
	if(self) {
		self.dict = [NSMutableDictionary dictionaryWithObject:[NSMutableArray arrayWithCapacity:20] forKey:@"and-query"];
	}

	return self;
}

+ (MLAndConstraint *)andConstraints:(MLConstraint *) firstConstraint, ... {
	MLConstraint *eachConstraint;
	va_list constraintList;
	NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:20];

	if(firstConstraint != nil) {
		[constraints addObject:firstConstraint];

		va_start(constraintList, firstConstraint);
		while((eachConstraint = va_arg(constraintList, MLConstraint *))) {
			[constraints addObject:eachConstraint];
		}
		va_end(constraintList);
	}

	MLAndConstraint *constraint = [[[MLAndConstraint alloc] init] autorelease];
    
    [constraint.dict setObject:constraints forKey:@"and-query"];

	return constraint;
}

@end
