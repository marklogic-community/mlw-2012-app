//
//  CCStringQueryConstraint.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCConstraint.h"

@interface CCStringQueryConstraint : CCConstraint

+ (CCStringQueryConstraint *) stringQuery:(NSString *)query;

@property (nonatomic, copy) NSString *query;

@end
