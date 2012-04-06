//
//  MLWSessionSurveyViewController.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSession.h"

@interface MLWSessionSurveyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithSession:(MLWSession *)session;

@end
