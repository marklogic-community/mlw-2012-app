//
//  MLWSession.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWSession : NSObject {
	NSDate *startTime;
	NSDate *endTime;
	NSNumber *plenary;
	NSNumber *selectable;
	NSString *title;
	NSString *description;
}

- (id)initWithData:(NSDictionary *) jsonData;
- (NSDate *)startTime;
- (NSDate *)endTime;
- (BOOL)plenary;
- (BOOL)selectable;
- (NSString *)title;
- (NSArray *)speakers;
- (NSString *)speakerString;
- (NSString *)description;

@end
