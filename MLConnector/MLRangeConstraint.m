/*
    MLRangeConstraint.m
	ML Connector
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

#import "MLRangeConstraint.h"
#import "MLFacetResult.h"


@interface MLRangeConstraint ()
- (BOOL)checkValue:(id) value placeIntoArray:(NSMutableArray *)array;
@end


@implementation MLRangeConstraint

+ (MLRangeConstraint *) rangeNamed:(NSString *) rangeName value:(id) value {
	return [MLRangeConstraint rangeNamed:rangeName values:value, nil];
}

+ (MLRangeConstraint *)rangeNamed:(NSString *) rangeName values:(id) firstValue, ... {
	MLRangeConstraint *constraint = [[[MLRangeConstraint alloc] init] autorelease];
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

	// constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, values, nil] forKeys:[NSArray arrayWithObjects:@"range-constraint-query", @"value", nil]];
    constraint.dict = [NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, values, nil] forKeys:[NSArray arrayWithObjects:@"constraint-name", @"value", nil]] forKey:@"range-constraint-query"];
	return constraint;
}

/*
+ (MLRangeConstraint *) rangeNamed:(NSString *) rangeName bucketLabel:(NSString *)bucketLabel {
	return [MLRangeConstraint rangeNamed:rangeName bucketLabels:bucketLabel, nil];
}

+ (MLRangeConstraint *)rangeNamed:(NSString *) rangeName bucketLabels:(NSString *) firstLabel, ... {
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

	MLRangeConstraint *constraint = [[[MLRangeConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, values, nil] forKeys:[NSArray arrayWithObjects:@"range-constraint-query", @"bucketLabel", nil]];
	return constraint;
}

+ (MLRangeConstraint *) rangeNamed:(NSString *) rangeName from:(id) fromValue to:(id) toValue {
	MLRangeConstraint *constraint = [[[MLRangeConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rangeName, fromValue, toValue, nil] forKeys:[NSArray arrayWithObjects:@"range-constraint-query", @"from", @"to", nil]];
	return constraint;
}
*/

- (NSString *)name {
	return [[self.dict objectForKey:@"range-constraint-query"] objectForKey:@"constraint-name"];
}

- (id)value {
	NSMutableArray *currentValues = [[self.dict objectForKey:@"range-constraint-query"] objectForKey:@"value"];
	if(currentValues.count > 0) {
		return [currentValues objectAtIndex:0];
	}
	return nil;
}

- (NSArray *)values {
	NSMutableArray *currentValues = [[self.dict objectForKey:@"range-constraint-query"] objectForKey:@"value"];
	return [NSArray arrayWithArray:currentValues];
}

/*
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
*/

- (void)addValue:(id) value {
	NSMutableArray *currentValues = [[self.dict objectForKey:@"range-constraint-query"] objectForKey:@"value"];
	if(currentValues == nil) {
		currentValues = [NSMutableArray arrayWithCapacity:20];
		[self.dict setObject:currentValues forKey:@"value"];
	}

	[self checkValue:value placeIntoArray:currentValues];
}

- (void)removeValue:(id) value {
	if([value isKindOfClass:[MLFacetResult class]]) {
		value = ((MLFacetResult *)value).label;
	}

	NSMutableArray *currentValues = [[self.dict objectForKey:@"range-constraint-query"] objectForKey:@"value"];
	NSMutableArray *itemsToRemove = [NSMutableArray arrayWithCapacity:2];
	for(id aValue in currentValues) {
		if([aValue isKindOfClass:[value class]] == NO) {
			continue;
		}

		if([aValue isKindOfClass:[NSString class]] && [(NSString *)aValue isEqualToString:value]) {
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

/*
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
*/

- (BOOL)checkValue:(id) value placeIntoArray:(NSMutableArray *)array {
	if([value isKindOfClass:[MLFacetResult class]]) {
		[array addObject:((MLFacetResult *)value).label];
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

- (NSString *)serialize {
	if(self.values.count == 0 /*&& self.bucketLabels.count == 0*/) {
		return @"{}";
	}
	return [super serialize];
}

@end
