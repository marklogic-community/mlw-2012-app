//
//  UIPurposeView.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIPurposeView.h"

@implementation UIPurposeView

@synthesize purpose;

- (void) dealloc {
	self.purpose = nil;
	[super dealloc];
}

@end
