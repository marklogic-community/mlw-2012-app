//
//  MLWSessionView.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLWSession.h"

@interface MLWSessionView : UIView

- (id)initWithFrame:(CGRect)frame session:(MLWSession *) session;

@property (readonly) MLWSession *session;

@end
