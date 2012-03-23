//
//  MLWBooleanConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWBooleanConstraint.h"
#import "MLWAndConstraint.h"
#import "MLWOrConstraint.h"
#import "MLWRangeConstraint.h"
#import "MLWKeywordConstraint.h"

@interface MLWBooleanConstraint ()
- (NSString *)type;
@end

@implementation MLWBooleanConstraint

- (void)addConstraint:(MLWConstraint *) constraint {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	[constraints addObject:constraint];
}


- (NSArray *)constraints {
	return [self.dict objectForKey:[self type]];
}

- (NSArray *)rangeConstraintsNamed:(NSString *) name {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *rangeConstraints = [NSMutableArray arrayWithCapacity:10];
	for(MLWConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[MLWRangeConstraint class]] && [((MLWRangeConstraint *)constraint).name isEqualToString:name]) {
			[rangeConstraints addObject:constraint];
		}
	}
	return rangeConstraints;
}

- (NSArray *)keywordConstraints {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *keywordConstraints = [NSMutableArray arrayWithCapacity:10];
	for(MLWConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[MLWKeywordConstraint class]]) {
			[keywordConstraints addObject:constraint];
		}
	}
	return keywordConstraints;
}


- (void)removeConstraint:(MLWConstraint *) constraint {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	[constraints removeObject:constraint];
}

- (void)removeRangeConstraintsNamed:(NSString *) name {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	for(MLWConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[MLWRangeConstraint class]] && [((MLWRangeConstraint *)constraint).name isEqualToString:name]) {
			[constraints addObject:constraint];
		}
	}
}

- (void)removeKeywordConstraints {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	for(MLWConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[MLWKeywordConstraint class]]) {
			[constraints removeObject:constraint];
		}
	}
}

- (NSString *)serialize {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];

	NSMutableString *serializedValue = [NSMutableString stringWithCapacity:1000];
	[serializedValue appendFormat:@"{\"%@\":", [self type]];
	[serializedValue appendString:@"["];
	int i = 0;
	for(MLWConstraint *constraint in constraints) {
		[serializedValue appendString:[constraint serialize]];
		i++;

		if(i < constraints.count) {
			[serializedValue appendString:@","];
		}
	}
	[serializedValue appendString:@"]}"];

	return serializedValue;
}


- (NSString *)type {
	if([self isKindOfClass:[MLWAndConstraint class]]) {
		return @"and";
	}
	if([self isKindOfClass:[MLWOrConstraint class]]) {
		return @"or";
	}

	return @"";
}

@end
