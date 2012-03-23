//
//  MLWKeywordConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWConstraint.h"

@interface MLWKeywordConstraint : MLWConstraint

+ (MLWKeywordConstraint *) key:(NSString *) keyName equals:(NSString *) value;
+ (MLWKeywordConstraint *) key:(NSString *) keyName contains:(NSString *) value;
+ (MLWKeywordConstraint *) element:(NSString *) elementName equals:(NSString *) value;
+ (MLWKeywordConstraint *) element:(NSString *) elementName contains:(NSString *) value;
+ (MLWKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName equals:(NSString *) value;
+ (MLWKeywordConstraint *) attribute:(NSString *) attributeName onElement:(NSString *) elementName contains:(NSString *) value;
+ (MLWKeywordConstraint *) property:(NSString *) propertyName equals:(NSString *) value;
+ (MLWKeywordConstraint *) property:(NSString *) propertyName contains:(NSString *) value;
+ (MLWKeywordConstraint *) wordAnywhere:(NSString *) word;
+ (MLWKeywordConstraint *) wordInBinary:(NSString *) word;

@property BOOL caseSensitive;
@property BOOL diacriticSensitive;
@property BOOL punctuationSensitve;
@property BOOL whitespaceSensitive;
@property BOOL stemmed;
@property BOOL wildcarded;
@property float weight;
@property (nonatomic, copy) NSString *language;

@end
