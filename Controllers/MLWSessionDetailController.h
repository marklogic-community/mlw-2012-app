//
//  MLWSessionDetailController.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLWSession.h"

@interface MLWSessionDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithSession:(MLWSession *)session;

@end
