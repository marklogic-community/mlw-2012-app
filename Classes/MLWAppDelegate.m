//
//  MLWAppDelegate.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWAppDelegate.h"
#import "MLWScheduleListController.h"
#import "MLWScheduleGridController.h"
#import "MLWSponsorListController.h"
#import "MLWTweetController.h"

@implementation MLWAppDelegate

@synthesize conference;
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize shouldScrollToNextSession;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.shouldScrollToNextSession = YES;
	self.conference = [[[MLWConference alloc] init] autorelease];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];

	MLWTweetController *tweetController = [[[MLWTweetController alloc] init] autorelease];
	UINavigationController *tweetNavController = [[[UINavigationController alloc] initWithRootViewController:tweetController] autorelease];
	tweetNavController.navigationBar.tintColor = [UIColor colorWithRed:(236.0f/255.0f) green:(125.0f/255.0f) blue:(30.0f/255.0f) alpha:1.0f];
	tweetController.title = @"Tweets";

	MLWSponsorListController *sponsorViewController = [[[MLWSponsorListController alloc] init] autorelease];
	UINavigationController *sponsorNavController = [[[UINavigationController alloc] initWithRootViewController:sponsorViewController] autorelease];
	sponsorNavController.navigationBar.tintColor = [UIColor colorWithRed:(236.0f/255.0f) green:(125.0f/255.0f) blue:(30.0f/255.0f) alpha:1.0f];
	sponsorNavController.title = @"Sponsors";

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MLWScheduleListController *scheduleViewController = [[[MLWScheduleListController alloc] init] autorelease];
		UINavigationController *scheduleNavController = [[[UINavigationController alloc] initWithRootViewController:scheduleViewController] autorelease];
		scheduleNavController.navigationBar.tintColor = [UIColor colorWithRed:(236.0f/255.0f) green:(125.0f/255.0f) blue:(30.0f/255.0f) alpha:1.0f];
		scheduleNavController.title = @"Schedule";


		self.tabBarController.viewControllers = [NSArray arrayWithObjects:scheduleNavController, tweetNavController, sponsorNavController, nil];
    }
	else {
        MLWScheduleGridController *scheduleViewController = [[[MLWScheduleGridController alloc] init] autorelease];
		UINavigationController *scheduleNavController = [[[UINavigationController alloc] initWithRootViewController:scheduleViewController] autorelease];
		scheduleNavController.navigationBar.tintColor = [UIColor colorWithRed:(236.0f/255.0f) green:(125.0f/255.0f) blue:(30.0f/255.0f) alpha:1.0f];
		scheduleNavController.title = @"Schedule";

		self.tabBarController.viewControllers = [NSArray arrayWithObjects:scheduleNavController, tweetNavController, sponsorNavController, nil];
    }

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
	 Sent when the application is about to move from active to inactive state.
	 This can occur for certain types of temporary interruptions (such as an
	 incoming phone call or SMS message) or when the user quits the application
	 and it begins the transition to the background state.  Use this method to
	 pause ongoing tasks, disable timers, and throttle down OpenGL ES frame
	 rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
	 Use this method to release shared resources, save user data, invalidate
	 timers, and store enough application state information to restore your
	 application to its current state in case it is terminated later.  If your
	 application supports background execution, this method is called instead
	 of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
	 Called as part of the transition from the background to the inactive
	 state; here you can undo many of the changes made on entering the
	 background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	self.shouldScrollToNextSession = YES;
    /*
	 Restart any tasks that were paused (or not yet started) while the
	 application was inactive. If the application was previously in the
	 background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void)dealloc {
	self.conference = nil;

    [_window release];
    [_tabBarController release];
    [super dealloc];
}

@end
