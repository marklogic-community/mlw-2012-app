//
//  MLWSponsorView.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLWSponsor.h"

@interface MLWSponsorView : UIView {
	int nameLabelHeight;
	int websiteLabelHeight;
}

- (id)initWithSponsor:(MLWSponsor *)sponsor;
- (float)calculatedHeightWithWidth:(CGFloat) width;

@property (nonatomic, retain) MLWSponsor *sponsor;

@end
