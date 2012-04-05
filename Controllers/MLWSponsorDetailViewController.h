//
//  MLWSponsorDetailViewController.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSponsorView.h"

@interface MLWSponsorDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithSponsorView:(MLWSponsorView *)sponsorView;

@end
