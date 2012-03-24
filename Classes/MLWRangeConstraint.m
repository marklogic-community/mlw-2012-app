//
//  MLWRangeConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWRangeConstraint.h"
#import "MLWFacetResult.h"


@interface MLWRangeConstraint ()
- (BOOL)checkValue:(id) value placeIntoArray:(NSMutableArray *)array;
@end


@implementation MLWRangeConstraint

+ (MLWRangeConstraint *) rangeNamed:(NSString *) rangeName value:(id) value {
	return [MLWRangeConstraint rangeNamed:rangeName values:value, nil];
}

+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName values:(id) firstValue, ... {
	MLWRangeConstraint *constraint = [[[MLWRangeConstraint alloc] init] autorelease];
	id eachValue;
	va_list valueList;
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:20];

	if(firstValue != nil) {
		[constraint checkValue:firstValue placeIntoArray:values];

		va_start(valueList, firstValue);
		while((eachValue = va_arg(valueList, id))) {
			[constraint checkValue:eachValue placeIntoArray:values];
		}
		va_end(valueList);
	}

	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, values, nil] forKeys:[NSArray arrayWithObjects:@"range", @"value", nil]];
	return constraint;
}

+ (MLWRangeConstraint *) rangeNamed:(NSString *) rangeName bucketLabel:(NSString *)bucketLabel {
	return [MLWRangeConstraint rangeNamed:rangeName bucketLabels:bucketLabel, nil];
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
	return [self.dict objectForKey:@"range"];
}

- (id)value {
	NSMutableArray *currentValues = [self.dict objectForKey:@"value"];
	if(currentValues.count > 0) {
		return [currentValues objectAtIndex:0];
	}
	return nil;
}

- (NSArray *)values {
	NSMutableArray *currentValues = [self.dict objectForKey:@"value"];
	return [NSArray arrayWithArray:currentValues];
}

- (NSString *)bucketLabel {
	NSMutableArray *currentValues = [self.dict objectForKey:@"bucketLabel"];
	if(currentValues.count > 0) {
		return [currentValues objectAtIndex:0];
	}
	return nil;
}

- (NSArray *)bucketLabels {
	NSMutableArray *currentValues = [self.dict objectForKey:@"bucketLabel"];
	return [NSArray arrayWithArray:currentValues];
}

- (void)addValue:(id) value {
	NSMutableArray *currentValues = [self.dict objectForKey:@"value"];
	if(currentValues == nil) {
		currentValues = [NSMutableArray arrayWithCapacity:20];
		[self.dict setObject:currentValues forKey:@"value"];
	}

	[self checkValue:value placeIntoArray:currentValues];
}

- (void)removeValue:(id) value {
	NSMutableArray *currentValues = [self.dict objectForKey:@"value"];
	NSMutableArray *itemsToRemove = [NSMutableArray arrayWithCapacity:2];
	for(id aValue in currentValues) {
		if([aValue isKindOfClass:[MLWFacetResult class]] && [((MLWFacetResult *)aValue).label isEqualToString:value]) {
			[itemsToRemove addObject:((MLWFacetResult *)aValue).label];
		}
		else if([aValue isKindOfClass:[NSString class]] && [(NSString *)aValue isEqualToString:value]) {
			[itemsToRemove addObject:aValue];
		}
		else if([aValue isKindOfClass:[NSNumber class]] && [(NSNumber *)aValue isEqualToNumber:value]) {
			[itemsToRemove addObject:aValue];
		}
	}
	for(id itemToRemove in itemsToRemove) {
		[currentValues removeObject:itemToRemove];
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


- (BOOL)checkValue:(id) value placeIntoArray:(NSMutableArray *)array {
	if([value isKindOfClass:[MLWFacetResult class]]) {
		[array addObject:((MLWFacetResult *)value).label];
		return YES;
	}
	else if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
		[array addObject:value];
		return YES;
	}
	else if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSMutableArray class]]) {
		for(id arrayValue in (NSArray *)value) {
			BOOL valid = [self checkValue:arrayValue placeIntoArray:array];
			if(valid == NO) {
				return NO;
			}
		}
		return YES;
	}

	return NO;
}

@end
