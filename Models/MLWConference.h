//
//  MLWConference.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLWSpeaker.h"
#import "MLWConstraint.h"

@interface MLWConference : NSObject

- (BOOL)fetchSessionsWithConstraint:(MLWConstraint *) constraint callback:(void (^)(NSArray *, NSError *)) callback;
- (BOOL)fetchSponsors:(void (^)(NSArray *sessions, NSError *error)) callback;
- (BOOL)fetchTweets:(void (^)(NSArray *sessions, NSError *error)) callback;
- (MLWSpeaker *)speakerWithId:(NSString *)speakerId;
- (NSArray *)sessionsToBlocks:(NSArray *)sessions;

@end
