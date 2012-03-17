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

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MLWConference *conference;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
