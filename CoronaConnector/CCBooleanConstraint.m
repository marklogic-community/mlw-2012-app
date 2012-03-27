//
//  CCBooleanConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCBooleanConstraint.h"
#import "CCAndConstraint.h"
#import "CCOrConstraint.h"
#import "CCRangeConstraint.h"
#import "CCKeywordConstraint.h"
#import "CCStringQueryConstraint.h"

@interface CCBooleanConstraint ()
- (NSString *)type;
@end

@implementation CCBooleanConstraint

- (void)addConstraint:(CCConstraint *) constraint {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	[constraints addObject:constraint];
}


- (NSArray *)constraints {
	return [self.dict objectForKey:[self type]];
}

- (NSArray *)rangeConstraintsNamed:(NSString *) name {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *rangeConstraints = [NSMutableArray arrayWithCapacity:10];
	for(CCConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[CCRangeConstraint class]] && [((CCRangeConstraint *)constraint).name isEqualToString:name]) {
			[rangeConstraints addObject:constraint];
		}
	}
	return rangeConstraints;
}

- (NSArray *)keywordConstraints {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *keywordConstraints = [NSMutableArray arrayWithCapacity:10];
	for(CCConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[CCKeywordConstraint class]]) {
			[keywordConstraints addObject:constraint];
		}
	}
	return keywordConstraints;
}

- (NSArray *)stringQueryConstraints {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *stringQueryConstraints = [NSMutableArray arrayWithCapacity:10];
	for(CCConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[CCStringQueryConstraint class]]) {
			[stringQueryConstraints addObject:constraint];
		}
	}
	return stringQueryConstraints;
}


- (void)removeConstraint:(CCConstraint *) constraint {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	[constraints removeObject:constraint];
}

- (void)removeRangeConstraintsNamed:(NSString *) name {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *constraintsToRemove = [NSMutableArray arrayWithCapacity:10];
	for(CCConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[CCRangeConstraint class]] && [((CCRangeConstraint *)constraint).name isEqualToString:name]) {
			[constraintsToRemove addObject:constraint];
		}
	}
	for(CCConstraint *constraint in constraintsToRemove) {
		[constraints removeObject:constraint];
	}
}

- (void)removeKeywordConstraints {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *constraintsToRemove = [NSMutableArray arrayWithCapacity:10];
	for(CCConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[CCKeywordConstraint class]]) {
			[constraintsToRemove addObject:constraint];
		}
	}
	for(CCConstraint *constraint in constraintsToRemove) {
		[constraints removeObject:constraint];
	}
}

- (void)removeStringQueryConstraints {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];
	NSMutableArray *constraintsToRemove = [NSMutableArray arrayWithCapacity:10];
	for(CCConstraint *constraint in constraints) {
		if([constraint isKindOfClass:[CCStringQueryConstraint class]]) {
			[constraintsToRemove addObject:constraint];
		}
	}
	for(CCConstraint *constraint in constraintsToRemove) {
		[constraints removeObject:constraint];
	}
}

- (NSString *)serialize {
	NSMutableArray *constraints = [self.dict objectForKey:[self type]];

	NSMutableString *serializedValue = [NSMutableString stringWithCapacity:1000];
	[serializedValue appendFormat:@"{\"%@\":", [self type]];
	[serializedValue appendString:@"["];
	int i = 0;
	for(CCConstraint *constraint in constraints) {
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
	if([self isKindOfClass:[CCAndConstraint class]]) {
		return @"and";
	}
	if([self isKindOfClass:[CCOrConstraint class]]) {
		return @"or";
	}

	return @"";
}

@end