//
//  MLWRangeConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCConstraint.h"

@interface CCRangeConstraint : CCConstraint

+ (CCRangeConstraint *)rangeNamed:(NSString *) rangeName value:(id) value;
+ (CCRangeConstraint *)rangeNamed:(NSString *) rangeName values:(id) value, ...;
+ (CCRangeConstraint *)rangeNamed:(NSString *) rangeName bucketLabel:(NSString *)bucketLabel;
+ (CCRangeConstraint *)rangeNamed:(NSString *) rangeName bucketLabels:(NSString *) firstLabel, ...;
+ (CCRangeConstraint *)rangeNamed:(NSString *) rangeName from:(id) fromValue to:(id) toValue;

- (NSString *)name;
- (id)value;
- (NSArray *)values;
- (NSString *)bucketLabel;
- (NSArray *)bucketLabels;

- (void)addValue:(id) value;
- (void)removeValue:(id) value;

@property (nonatomic, copy) NSString *operator;
@property int minimumOccurances;
@property int maximumOccurances;
@property (nonatomic, copy) NSString *language;

@end
