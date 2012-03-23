//
//  MLWFacetResult.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLWFacetResult : NSObject

- (id)initWithLabel:(NSString *) label count:(NSUInteger ) count;

@property (readonly) NSString *label;
@property (readonly) NSUInteger count;

@end
