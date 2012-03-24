//
//  MLWRequest.m
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
		NSString *encodedValue = ((NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) [parameters objectForKey:key], NULL, CFSTR("=/:"), kCFStringEncodingUTF8));
		[POSTParams appendString: key];
		[POSTParams appendString: @"="];
		[POSTParams appendString: encodedValue];
		[POSTParams appendString: @"&"];
		[encodedValue release];
	}
	return [POSTParams dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)dealloc {
	self.baseURL = nil;
	self.parameters = nil;

	[super dealloc];
}

@end
