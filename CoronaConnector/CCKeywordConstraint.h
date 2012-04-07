/*
    CCKeywordConstraint.h
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

@interface CCKeywordConstraint : CCConstraint

+ (CCKeywordConstraint *) key:(NSString *) keyName equals:(NSString *) value;
+ (CCKeywordConstraint *) key:(NSString *) keyName contains:(NSString *) value;
+ (CCKeywordConstraint *) element:(NSString *) elementName equals:(NSString *) value;
+ (CCKeywordConstraint *) element:(NSString *) elementName contains:(NSString *) value;
+ (CCKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName equals:(NSString *) value;
+ (CCKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName contains:(NSString *) value;
+ (CCKeywordConstraint *) property:(NSString *) propertyName equals:(NSString *) value;
+ (CCKeywordConstraint *) property:(NSString *) propertyName contains:(NSString *) value;
+ (CCKeywordConstraint *) wordAnywhere:(NSString *) word;
+ (CCKeywordConstraint *) wordInBinary:(NSString *) word;

@property BOOL caseSensitive;
@property BOOL diacriticSensitive;
@property BOOL punctuationSensitve;
@property BOOL whitespaceSensitive;
@property BOOL stemmed;
@property BOOL wildcarded;
@property float weight;
@property (nonatomic, copy) NSString *language;

@end
