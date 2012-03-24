//
//  CCKeywordConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
