/*
    MLWConference.h
	MarkLogic World
	Created by Ryan Grimm on 3/14/12.

	Copyright 2012 MarkLogic

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

#import <Foundation/Foundation.h>
#import "MLWSpeaker.h"
#import "MLWMySchedule.h"
#import "MLConstraint.h"
#import "MLFacetResponse.h"

@interface MLWConference : NSObject

- (BOOL)fetchSessionsWithConstraint:(MLConstraint *) constraint callback:(void (^)(NSArray *, NSError *)) callback;
- (BOOL)fetchFacetsWithConstraint:(MLConstraint *) constraint callback:(void (^)(MLFacetResponse *, NSError *)) callback;
- (BOOL)fetchTweets:(void (^)(NSArray *sessions, NSError *error)) callback;
- (BOOL)fetchSponsors:(void (^)(NSArray *sessions, NSError *error)) callback;
- (void)saveMySchedule:(MLWMySchedule *) schedule;
- (MLWSpeaker *)speakerWithId:(NSString *)speakerId;
- (NSArray *)sessionsToBlocks:(NSArray *)sessions;

@property (nonatomic, retain) MLWMySchedule *userSchedule;

@end
