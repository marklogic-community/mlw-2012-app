//
//  MLWSponsor.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWSponsor : NSObject

- (id)initWithData:(NSDictionary *) jsonData;
@property (readonly) NSString *name;
@property (readonly) NSString *level;
@property (readonly) NSString *description;
@property (readonly) NSString *website;
@property (readonly) UIView *logo;

@end
