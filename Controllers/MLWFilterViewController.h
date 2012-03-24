//
//  MLWFilterViewController.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWAndConstraint.h"

@class MLWFilterViewController;

@protocol MLWFilterViewControllerDelegate <NSObject>
@optional
- (void)filterView:(MLWFilterViewController *) filterViewController constructedConstraint:(MLWAndConstraint *) constraint;
@end

@interface MLWFilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id<MLWFilterViewControllerDelegate>delegate;
}

@property (nonatomic, assign) id<MLWFilterViewControllerDelegate> delegate;

@end
