//
//  MLWFilterViewController.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCAndConstraint.h"

@class MLWFilterViewController;

@protocol MLWFilterViewControllerDelegate <NSObject>
@optional
- (void)filterView:(MLWFilterViewController *) filterViewController constructedConstraint:(CCAndConstraint *) constraint;
@end

@interface MLWFilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	id<MLWFilterViewControllerDelegate>delegate;
}

@property (nonatomic, assign) id<MLWFilterViewControllerDelegate> delegate;

@end
