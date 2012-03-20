//
//  MLWTweet.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLWTweet : NSObject

- (id)initWithData:(NSDictionary *) jsonData;

@property (readonly) NSString *username;
@property (readonly) NSString *content;
@property (readonly) NSDate *date;
@property (readonly) UIImage *profileImage;
@property (readonly) NSString *profileImageURL;
@property (readonly) NSString *dateString;

@end
