/*
    CCKeywordConstraint.m
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

#import "CCKeywordConstraint.h"

@implementation CCKeywordConstraint

+ (CCKeywordConstraint *) key:(NSString *) keyName equals:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:keyName, value, nil] forKeys:[NSArray arrayWithObjects:@"key", @"equals", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) key:(NSString *) keyName contains:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:keyName, value, nil] forKeys:[NSArray arrayWithObjects:@"key", @"equals", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) element:(NSString *) elementName equals:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"equals", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) element:(NSString *) elementName contains:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"contains", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName equals:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, attributeName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"attribute", @"equals", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName contains:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, attributeName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"attribute", @"contains", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) property:(NSString *) propertyName equals:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:propertyName, value, nil] forKeys:[NSArray arrayWithObjects:@"property", @"equals", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) property:(NSString *) propertyName contains:(NSString *) value {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:propertyName, value, nil] forKeys:[NSArray arrayWithObjects:@"property", @"contains", nil]];
	return constraint;
}

+ (CCKeywordConstraint *) wordAnywhere:(NSString *) word {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObject:word forKey:@"wordAnywhere"];
	return constraint;
}

+ (CCKeywordConstraint *) wordInBinary:(NSString *) word {
	CCKeywordConstraint *constraint = [[[CCKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObject:word forKey:@"wordInBinary"];
	return constraint;
}

- (BOOL)caseSensitive {
	return ((NSNumber *)[self.dict objectForKey:@"caseSensitive"]).boolValue;
}

- (void)setCaseSensitive:(BOOL) sensitive {
	[self.dict setObject:[NSNumber numberWithBool:sensitive] forKey:@"caseSensitive"];
}

- (BOOL)diacriticSensitive {
	return ((NSNumber *)[self.dict objectForKey:@"diacriticSensitive"]).boolValue;
}

- (void)setDiacriticSensitive:(BOOL) sensitive {
	[self.dict setObject:[NSNumber numberWithBool:sensitive] forKey:@"diacriticSensitive"];
}

- (BOOL)punctuationSensitve {
	return ((NSNumber *)[self.dict objectForKey:@"punctuationSensitve"]).boolValue;
}

- (void)setPunctuationSensitve:(BOOL) sensitive {
	[self.dict setObject:[NSNumber numberWithBool:sensitive] forKey:@"punctuationSensitve"];
}

- (BOOL)whitespaceSensitive {
	return ((NSNumber *)[self.dict objectForKey:@"whitespaceSensitive"]).boolValue;
}

- (void)setWhitespaceSensitive:(BOOL) sensitive {
	[self.dict setObject:[NSNumber numberWithBool:sensitive] forKey:@"whitespaceSensitive"];
}

- (BOOL)stemmed {
	return ((NSNumber *)[self.dict objectForKey:@"stemmed"]).boolValue;
}

- (void)setStemmed:(BOOL) stemmed {
	[self.dict setObject:[NSNumber numberWithBool:stemmed] forKey:@"stemmed"];
}

- (BOOL)wildcarded {
	return ((NSNumber *)[self.dict objectForKey:@"wildcarded"]).boolValue;
}

- (void)setWildcarded:(BOOL) wildcarded {
	[self.dict setObject:[NSNumber numberWithBool:wildcarded] forKey:@"wildcarded"];
}

- (float)weight {
	return ((NSNumber *)[self.dict objectForKey:@"weight"]).floatValue;
}

- (void)setWeight:(float) weight {
	[self.dict setObject:[NSNumber numberWithFloat:weight] forKey:@"weight"];
}

- (NSString *)language {
	return [self.dict objectForKey:@"language"];
}

- (void)setLanguage:(NSString *) language {
	[self.dict setObject:language forKey:@"language"];
}

@end
