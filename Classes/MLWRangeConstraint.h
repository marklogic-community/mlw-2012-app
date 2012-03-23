//
//  MLWRangeConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWConstraint.h"

@interface MLWRangeConstraint : MLWConstraint

+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName value:(id) value;
+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName values:(id) value, ...;
+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName bucketLabel:(NSString *)bucketLabel;
+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName bucketLabels:(NSString *) firstLabel, ...;
+ (MLWRangeConstraint *)rangeNamed:(NSString *) rangeName from:(id) fromValue to:(id) toValue;

- (NSString *)name;
- (id)value;
- (NSArray *)values;
- (NSString *)bucketLabel;
- (NSArray *)bucketLabels;

- (void)addValue:(id) value;
- (void)removeValue:(id) value;

- (void)addBucketLabel:(id) bucketLabel;
- (void)removeBucketLabel:(id) bucketLabel;

@property (nonatomic, copy) NSString *operator;
@property int minimumOccurances;
@property int maximumOccurances;
@property (nonatomic, copy) NSString *language;

@end
