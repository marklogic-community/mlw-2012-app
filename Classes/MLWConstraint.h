//
//  MLWConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWConstraint : NSObject

@property (nonatomic, retain) NSMutableDictionary *dict;
- (NSString *)serialize;

@end
