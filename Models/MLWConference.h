//
//  MLWConference.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLWSpeaker.h"
#import "CCConstraint.h"
#import "CCFacetResponse.h"

@interface MLWConference : NSObject

- (BOOL)fetchSessionsWithConstraint:(CCConstraint *) constraint callback:(void (^)(NSArray *, NSError *)) callback;
- (BOOL)fetchFacetsWithConstraint:(CCConstraint *) constraint callback:(void (^)(CCFacetResponse *, NSError *)) callback;
- (BOOL)fetchSponsors:(void (^)(NSArray *sessions, NSError *error)) callback;
- (BOOL)fetchTweets:(void (^)(NSArray *sessions, NSError *error)) callback;
- (MLWSpeaker *)speakerWithId:(NSString *)speakerId;
- (NSArray *)sessionsToBlocks:(NSArray *)sessions;

@end
