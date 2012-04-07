/*
    CCRangeConstraint.h
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
