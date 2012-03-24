//
//  CCRequest.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCRequest : NSObject

- (NSData *)dictionaryToPOSTData:(NSDictionary *) parameters;

@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSMutableDictionary *parameters;

@end
