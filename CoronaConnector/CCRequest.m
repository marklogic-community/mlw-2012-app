//
//  CCRequest.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCRequest.h"

@implementation CCRequest

@synthesize baseURL;
@synthesize parameters = _parameters;

- (id)init {
	self = [super init];
	if(self) {
		self.parameters = [NSMutableDictionary dictionaryWithCapacity:20];
		[self.parameters setObject:@"json" forKey:@"outputFormat"];
	}
	return self;
}

- (NSData *)dictionaryToPOSTData:(NSDictionary *) parameters {
	NSMutableString *POSTParams = [[[NSMutableString alloc] init] autorelease];
	for(NSString *key in parameters) {
		[POSTParams appendString: key];
		[POSTParams appendString: @"="];
		[POSTParams appendString: [self encodeString:[parameters objectForKey:key]]];
		[POSTParams appendString: @"&"];
	}
	return [POSTParams dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeString:(NSString *)string {
	NSString *encodeString = ((NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) string, NULL, CFSTR("=/:"), kCFStringEncodingUTF8));
	[encodeString autorelease];
	return encodeString;
}

- (void)dealloc {
	self.baseURL = nil;
	self.parameters = nil;

	[super dealloc];
}

@end
