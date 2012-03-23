//
//  MLWRangeConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWRangeConstraint.h"

@implementation MLWRangeConstraint

+ (MLWRangeConstraint *) rangeNamed:(NSString *) rangeName value:(id) value {
	MLWRangeConstraint *constraint = [[[MLWRangeConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, value, nil] forKeys:[NSArray arrayWithObjects:@"range", @"value", nil]];
	return constraint;
}

+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName values:(id) firstValue, ... {
	id eachValue;
	va_list valueList;
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:20];

	if(firstValue != nil) {
		[values addObject:firstValue];

		va_start(valueList, firstValue);
		while((eachValue = va_arg(valueList, id))) {
			[values addObject:eachValue];
		}
		va_end(valueList);
	}

	MLWRangeConstraint *constraint = [[[MLWRangeConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, values, nil] forKeys:[NSArray arrayWithObjects:@"range", @"value", nil]];
	return constraint;
}

+ (MLWRangeConstraint *) rangeNamed:(NSString *) rangeName bucketLabel:(NSString *)bucketLabel {
	MLWRangeConstraint *constraint = [[[MLWRangeConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, bucketLabel, nil] forKeys:[NSArray arrayWithObjects:@"range", @"bucketLabel", nil]];
	return constraint;
}

+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName bucketLabels:(NSString *) firstLabel, ... {
	NSString *eachValue;
	va_list valueList;
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:20];

	if(firstLabel != nil) {
		[values addObject:firstLabel];

		va_start(valueList, firstLabel);
		while((eachValue = va_arg(valueList, NSString *))) {
			[values addObject:eachValue];
		}
		va_end(valueList);
	}

	MLWRangeConstraint *constraint = [[[MLWRangeConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, values, nil] forKeys:[NSArray arrayWithObjects:@"range", @"bucketLabel", nil]];
	return constraint;
}

+ (MLWRangeConstraint *) rangeNamed:(NSString *) rangeName from:(id) fromValue to:(id) toValue {
	MLWRangeConstraint *constraint = [[[MLWRangeConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, fromValue, toValue, nil] forKeys:[NSArray arrayWithObjects:@"range", @"from", @"to", nil]];
	return constraint;
}

- (NSString *)name {
	return [self.dict objectForKey:@"name"];
}

- (id)value {
	id currentValue = [self.dict objectForKey:@"value"];
	if(currentValue == nil) {
		return nil;
	}

	if([currentValue isKindOfClass:[NSMutableArray class]]) {
		NSMutableArray *arrayOfValues = (NSMutableArray *)currentValue;
		if(arrayOfValues.count > 0) {
			return [arrayOfValues objectAtIndex:0];
		}
		return nil;
	}

	if([currentValue isKindOfClass:[NSString class]] || [currentValue isKindOfClass:[NSNumber class]]) {
		return currentValue;
	}

	return  nil;
}

- (NSArray *)values {
	id currentValue = [self.dict objectForKey:@"value"];
	if(currentValue == nil) {
		return nil;
	}

	if([currentValue isKindOfClass:[NSMutableArray class]]) {
		return currentValue;
	}
	else {
		return [NSArray arrayWithObjects:currentValue, nil];
	}
}

- (NSString *)bucketLabel {
	id currentValue = [self.dict objectForKey:@"bucketLabel"];
	if(currentValue == nil) {
		return nil;
	}

	if([currentValue isKindOfClass:[NSMutableArray class]]) {
		NSMutableArray *arrayOfValues = (NSMutableArray *)currentValue;
		if(arrayOfValues.count > 0) {
			return [arrayOfValues objectAtIndex:0];
		}
		return nil;
	}

	if([currentValue isKindOfClass:[NSString class]]) {
		return currentValue;
	}

	return  nil;
}

- (NSArray *)bucketLabels {
	id currentValue = [self.dict objectForKey:@"bucketLabel"];
	if(currentValue == nil) {
		return nil;
	}

	if([currentValue isKindOfClass:[NSMutableArray class]]) {
		return currentValue;
	}
	else {
		return [NSArray arrayWithObjects:currentValue, nil];
	}
}

- (void)addValue:(id) value {
	NSMutableArray *values = (NSMutableArray *)[self values];
	[values addObject:value];
}

- (void)removeValue:(id) value {
	NSMutableArray *values = (NSMutableArray *)[self values];
	for(id aValue in values) {
		if([aValue isKindOfClass:[NSString class]] && [(NSString *)aValue isEqualToString:value]) {
			[values removeObject:aValue];
		}
		else if([aValue isKindOfClass:[NSNumber class]] && [(NSNumber *)aValue isEqualToNumber:value]) {
			[values removeObject:aValue];
		}
	}
}

- (void)addBucketLabel:(NSString *) bucketLabel {
	NSMutableArray *labels = (NSMutableArray *)[self bucketLabels];
	[labels addObject:bucketLabel];
}

- (void)removeBucketLabel:(NSString *) bucketLabel {
	NSMutableArray *labels = (NSMutableArray *)[self bucketLabels];
	for(NSString *label in labels) {
		if([label isEqualToString:bucketLabel]) {
			[labels removeObject:label];
		}
	}
}


- (NSString *)operator {
	return [self.dict objectForKey:@"operator"];
}

- (void)setOperator:(NSString *) operator {
	[self.dict setObject:operator forKey:@"operator"];
}

- (int)minimumOccurances {
	return ((NSNumber *)[self.dict objectForKey:@"minimumOccurances"]).intValue;
}

- (void)setMinimumOccurances:(int) minimumOccurances {
	[self.dict setObject:[NSNumber numberWithInt:minimumOccurances] forKey:@"minimumOccurances"];
}

- (int)maximumOccurances {
	return ((NSNumber *)[self.dict objectForKey:@"maximumOccurances"]).intValue;
}

- (void)setMaximumOccurances:(int) maximumOccurances {
	[self.dict setObject:[NSNumber numberWithInt:maximumOccurances] forKey:@"maximumOccurances"];
}

- (NSString *)language {
	return [self.dict objectForKey:@"language"];
}

- (void)setLanguage:(NSString *) language {
	[self.dict setObject:language forKey:@"language"];
}

@end
