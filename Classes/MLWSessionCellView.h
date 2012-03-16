//
//  MLWSessionCellView.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLWSession.h"

@interface MLWSessionCellView : UIView

- (void)updateWithSessionData:(MLWSession *)session;

@end
