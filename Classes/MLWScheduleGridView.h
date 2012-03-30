//
//  MLWScheduleGridView.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLWSessionView.h"

@interface MLWScheduleGridView : UIView {
	BOOL removeChildren;
}

@property (nonatomic, assign) NSObject<MLWSessionViewDelegate> *delegate;
@property (nonatomic, retain) NSArray *sessions;

- (void)limitToUserSchedule:(BOOL) limit;

@end
