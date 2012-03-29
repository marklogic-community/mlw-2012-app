//
//  MLWMySchedule.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSession.h"

@interface MLWMySchedule : NSObject

- (id) initWithData:(NSDictionary *)data;
+ (MLWMySchedule *) scheduleWithData:(NSDictionary *)data;
- (NSDictionary *)serialize;

- (BOOL)hasSession:(MLWSession *)session;
- (void)addSession:(MLWSession *)session;
- (void)removeSession:(MLWSession *)session;

@end
