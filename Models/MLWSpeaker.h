//
//  MLWSpeaker.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWSpeaker : NSObject {
	NSString *name;
	NSString *title;
	NSString *organization;
	NSString *email;
	NSString *bio;
}
 
- (id)initWithData:(NSDictionary *) jsonData;
- (NSString *)name;
- (NSString *)title;
- (NSString *)organization;
- (NSString *)contact;
- (NSString *)bio;
- (NSArray *)sessions;

@end
