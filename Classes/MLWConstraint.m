//
//  MLWConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWConstraint.h"
#import "SBJSON.h"

@implementation MLWConstraint

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
