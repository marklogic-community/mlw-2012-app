/*
    MLStringQueryConstraint.m
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

#import "MLStringQueryConstraint.h"

@implementation MLStringQueryConstraint

+ (MLStringQueryConstraint *) stringQuery:(NSString *)query {
	MLStringQueryConstraint *constraint = [[[MLStringQueryConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObject:
                       [NSMutableDictionary dictionaryWithObject:query forKey:@"text"] forKey:@"term-query"];
       
	return constraint;
}

- (NSString *)query {
	return [[self.dict objectForKey:@"term-query"] objectForKey:@"text"];
}

- (void)setQuery:(NSString *) query {
	[[self.dict objectForKey:@"term-query"] setObject:query forKey:@"text"];
}

@end
