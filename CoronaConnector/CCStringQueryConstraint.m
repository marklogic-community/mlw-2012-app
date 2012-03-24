//
//  CCStringQueryConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCStringQueryConstraint.h"

@implementation CCStringQueryConstraint

+ (CCStringQueryConstraint *) stringQuery:(NSString *)query {
	CCStringQueryConstraint *constraint = [[[CCStringQueryConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObject:query forKey:@"stringQuery"];
	return constraint;
}

- (NSString *)query {
	return [self.dict objectForKey:@"stringQuery"];
}

- (void)setQuery:(NSString *) query {
	[self.dict setObject:query forKey:@"stringQuery"];
}

@end
