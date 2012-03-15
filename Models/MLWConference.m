//
//  MLWConference.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWConference.h"

@implementation MLWConference

- (BOOL)sessions:(void (^)(NSArray *sessions, NSError *error)) callback {
	return YES;
}

- (BOOL)sponsors:(void (^)(NSArray *sessions, NSError *error)) callback {
	return YES;
}

- (BOOL)tweets:(void (^)(NSArray *sessions, NSError *error)) callback {
	return YES;
}


@end
