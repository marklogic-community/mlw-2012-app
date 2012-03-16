//
//  MLWConference.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLWSpeaker.h"

@interface MLWConference : NSObject

- (BOOL)fetchSessions:(void (^)(NSArray *sessions, NSError *error)) callback;
- (BOOL)fetchSponsors:(void (^)(NSArray *sessions, NSError *error)) callback;
- (BOOL)fetchTweets:(void (^)(NSArray *sessions, NSError *error)) callback;
- (MLWSpeaker *)speakerWithId:(NSString *)speakerId;

@end
