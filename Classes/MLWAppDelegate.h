/*
    MLWAppDelegate.h
	MarkLogic World
    Created by Ryan Grimm on 3/9/12.

	Copyright 2012 MarkLogic

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

#import <UIKit/UIKit.h>
#import "MLWConference.h"

@interface MLWAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) MLWConference *conference;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property BOOL shouldScrollToNextSession;

@end
