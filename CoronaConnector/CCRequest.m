/*
    CCRequest.m
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
