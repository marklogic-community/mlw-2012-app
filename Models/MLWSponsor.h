//
//  MLWSponsor.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWSponsor : NSObject {
	NSString *name;
	NSNumber *level;
	NSString *description;
	NSString *website;
	NSURL *logoURL;
}

- (id)initWithData:(NSDictionary *) jsonData;
- (NSString *)name;
- (NSNumber *)level;
- (NSString *)description;
- (NSString *)website;
- (UIView *)logo;

@end
