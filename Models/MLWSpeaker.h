//
//  MLWSpeaker.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWSpeaker : NSObject
 
- (id)initWithData:(NSDictionary *) jsonData;
@property (readonly) NSString *id;
@property (readonly) NSString *name;
@property (readonly) NSString *title;
@property (readonly) NSString *organization;
@property (readonly) NSString *email;
@property (readonly) NSString *bio;

@end
