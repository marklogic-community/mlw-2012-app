//
//  MLWSession.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWSession : NSObject

- (id)initWithData:(NSDictionary *) jsonData;
- (NSString *)dayOfWeek;
- (NSString *)formattedDate;
- (NSString *)formattedTime;

@property (readonly) NSString *id;
@property (readonly) NSDate *startTime;
@property (readonly) NSDate *endTime;
@property (readonly) BOOL plenary;
@property (readonly) BOOL selectable;
@property (readonly) NSString *title;
@property (readonly) NSMutableArray *speakers;
@property (readonly) NSString *abstract;
@property (readonly) NSString *track;
@property (readonly) NSString *location;

@end
