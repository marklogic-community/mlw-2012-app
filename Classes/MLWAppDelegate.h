//
//  MLWAppDelegate.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLWConference.h"

@interface MLWAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) MLWConference *conference;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property BOOL shouldScrollToNextSession;

@end
