//
//  MLWConference.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWConference : NSObject

- (BOOL)sessions:(void (^)(NSArray *sessions, NSError *error)) callback;
- (BOOL)sponsors:(void (^)(NSArray *sessions, NSError *error)) callback;
- (BOOL)tweets:(void (^)(NSArray *sessions, NSError *error)) callback;

@end
