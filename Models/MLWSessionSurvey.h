//
//  MLWSessionSurvey.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCRequest.h"
#import "MLWSession.h"

@interface MLWSessionSurvey : CCRequest

- (id)initWithSession:(MLWSession *)session;

@property NSInteger speakerRating;
@property NSInteger contentRating;
@property (nonatomic, retain) NSString *comments;

- (void)submit:(void (^)(NSError *)) callback;

@end
