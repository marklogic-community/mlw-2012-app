//
//  UITableView+helpers.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITableView+helpers.h"

@implementation UITableView (helpers)

- (void)applyBackground {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fabric"]];
    self.backgroundView = bgView;
    [bgView release];
}

@end
