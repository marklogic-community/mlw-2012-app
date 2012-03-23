//
//  MLWKeywordConstraint.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWKeywordConstraint.h"

@implementation MLWKeywordConstraint

+ (MLWKeywordConstraint *) key:(NSString *) keyName equals:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:keyName, value, nil] forKeys:[NSArray arrayWithObjects:@"key", @"equals", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) key:(NSString *) keyName contains:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:keyName, value, nil] forKeys:[NSArray arrayWithObjects:@"key", @"equals", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) element:(NSString *) elementName equals:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"equals", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) element:(NSString *) elementName contains:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"contains", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName equals:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, attributeName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"attribute", @"equals", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName contains:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:elementName, attributeName, value, nil] forKeys:[NSArray arrayWithObjects:@"element", @"attribute", @"contains", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) property:(NSString *) propertyName equals:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:propertyName, value, nil] forKeys:[NSArray arrayWithObjects:@"property", @"equals", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) property:(NSString *) propertyName contains:(NSString *) value {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:propertyName, value, nil] forKeys:[NSArray arrayWithObjects:@"property", @"contains", nil]];
	return constraint;
}

+ (MLWKeywordConstraint *) wordAnywhere:(NSString *) word {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
	constraint.dict = [NSMutableDictionary dictionaryWithObject:word forKey:@"wordAnywhere"];
	return constraint;
}

+ (MLWKeywordConstraint *) wordInBinary:(NSString *) word {
	MLWKeywordConstraint *constraint = [[[MLWKeywordConstraint alloc] init] autorelease];
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
