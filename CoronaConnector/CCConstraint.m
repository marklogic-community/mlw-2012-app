/*
    CCConstraint.m
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

#import "CCConstraint.h"
#import "SBJSON.h"

@implementation CCConstraint

@synthesize dict;

- (id)init {
	self = [super init];
	if(self != nil) {
		self.dict = [NSMutableDictionary dictionaryWithCapacity:20];
	}
	return self;
}

- (NSString *)serialize {
	SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
	NSString *jsonString = [jsonWriter stringWithObject:[NSDictionary dictionaryWithDictionary:self.dict]];  
	[jsonWriter release];
	return jsonString;
}

- (void)dealloc {
	self.dict = nil;
	[super dealloc];
}

@end
