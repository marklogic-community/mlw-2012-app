//
//  MLWScheduleGridView.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define NUMBEROFCOLUMNS 6.0f

#import <QuartzCore/QuartzCore.h>
#import "MLWScheduleGridView.h"
#import "MLWSession.h"
#import "UIPurposeView.h"
#import "MLWAppDelegate.h"
#import "MLWMySchedule.h"

@interface MLWScheduleGridView ()
- (UIView *)dayOfWeekHeader:(NSString *)dayOfWeek withFrame:(CGRect) frame;
@property (nonatomic, retain) NSMutableArray *sessionViews;
@end

@implementation MLWScheduleGridView

@synthesize sessions = _sessions;
@synthesize delegate;
@synthesize sessionViews = _sessionViews;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToNextSession) name:UIApplicationDidBecomeActiveNotification object:nil];

		self.sessionViews = [NSMutableArray arrayWithCapacity:100];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.sessions = [NSArray array];
    }
    return self;
}

- (void)setSessions:(NSArray *) sessions {
	[_sessions release];
	_sessions = [sessions retain];
	removeChildren = YES;
	[self.sessionViews removeAllObjects];
}

- (void)updateUserSchedule {
	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;
	MLWMySchedule *schedule = appDelegate.conference.userSchedule;
	for(MLWSessionView *sessionView in self.sessionViews) {
		sessionView.highlighted = [schedule hasSession:sessionView.session];
	}
}

- (void)scrollToNextSession {
	MLWAppDelegate *appDelegate = (MLWAppDelegate *)[UIApplication sharedApplication].delegate;

	if(_sessions.count == 0 || appDelegate.shouldScrollToNextSession == NO) {
		return;
	}
	appDelegate.shouldScrollToNextSession = NO;

	for(MLWSessionView *sessionView in self.sessionViews) {
		if([sessionView.session.startTime compare:[NSDate date]] == NSOrderedDescending) {
			NSLog(@"MLWScheduleGridView: Scrolling to session: %@", sessionView.session.title);
			UIScrollView *scrollView = (UIScrollView *)self.superview;
			CGRect scrollToFrame = sessionView.frame;
			scrollToFrame.origin.x = 0;
			if(scrollToFrame.origin.y == 0) {
				scrollToFrame.origin.y = sessionView.superview.frame.origin.y;
			}
			[scrollView scrollRectToVisible:scrollToFrame animated:YES];
			return;
		}
	}
}

- (void)layoutSubviews {
	int columnWidth = self.bounds.size.width / NUMBEROFCOLUMNS;
	int rowHeight = 40;
	int sessionRowHeight = 150;
	if(removeChildren == YES) {
		for(UIView *view in self.subviews) {
			[view removeFromSuperview];
		}

		NSString *lastDay = nil;
		int totalHeight = 0;
		for(NSArray *blockSessions in self.sessions) {
			int totalWidth = 0;

			if([lastDay isEqualToString:((MLWSession *)[blockSessions objectAtIndex:0]).dayOfWeek] == NO) {
				lastDay = ((MLWSession *)[blockSessions objectAtIndex:0]).dayOfWeek;
				UIView *headerView = [self dayOfWeekHeader:lastDay withFrame:CGRectMake(totalWidth, totalHeight, self.frame.size.width, rowHeight + 1)];
				[self addSubview:headerView];
				totalHeight += rowHeight;
			}

			UIPurposeView *timeView = [[UIPurposeView alloc] initWithFrame:CGRectMake(totalWidth, totalHeight, columnWidth + 1, rowHeight + 1)]; 
			timeView.purpose = @"time";
			timeView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
			timeView.layer.borderWidth = 1;

			UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectInset(timeView.bounds, 5, 5)];
			timeLabel.font = [UIFont boldSystemFontOfSize:11];
			timeLabel.text = ((MLWSession *)[blockSessions objectAtIndex:0]).formattedTime;
			[timeView addSubview:timeLabel];
			[timeLabel release];

			[self addSubview:timeView];
            [timeView release];

			totalWidth += columnWidth;

			if(blockSessions.count == 1) {
				MLWSession *session = [blockSessions objectAtIndex:0];
				MLWSessionView *sessionView = [[MLWSessionView alloc] initWithFrame:CGRectMake(totalWidth, totalHeight, self.frame.size.width - totalWidth, rowHeight + 1) session:session]; 
				sessionView.delegate = delegate;
				[self.sessionViews addObject:sessionView];
				[self addSubview:sessionView];
				totalHeight += rowHeight;
				[sessionView release];
			}
			else {
				UIPurposeView *labelView = [[UIPurposeView alloc] initWithFrame:CGRectMake(totalWidth, totalHeight, self.frame.size.width - totalWidth, rowHeight + 1)]; 
				labelView.purpose = @"breakoutLabel";
				labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				labelView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
				labelView.layer.borderWidth = 1;

				UILabel *sessionTitleLabel = [[UILabel alloc] initWithFrame:CGRectInset(labelView.bounds, 5, 5)];
				sessionTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				sessionTitleLabel.font = [UIFont systemFontOfSize:11];
				sessionTitleLabel.text = @"Breakout Sessions";
				sessionTitleLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
				[labelView addSubview:sessionTitleLabel];
				[sessionTitleLabel release];

				[self addSubview:labelView];
				[labelView release];
				totalHeight += rowHeight;

				// Amphitheater, Polaris, Hemi A, Oceanic A&B, Hemi B, Meridian D&E

				int index = 0;
				NSMutableArray *ordered = [NSMutableArray arrayWithObjects:[NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], nil];
				for(MLWSession *session in blockSessions) {
					MLWSessionView *sessionView = [[MLWSessionView alloc] initWithFrame:CGRectZero session:session]; 
					sessionView.delegate = delegate;
					[self.sessionViews addObject:sessionView];

					index = -1;
					if([session.location isEqualToString:@"Amphitheater"]) {
						index = 0;
					}
					else if([session.location isEqualToString:@"Polaris"]) {
						index = 1;
					}
					else if([session.location isEqualToString:@"Hemisphere A"]) {
						index = 2;
					}
					else if([session.location isEqualToString:@"Oceanic A & B"]) {
						index = 3;
					}
					else if([session.location isEqualToString:@"Hemisphere B"]) {
						index = 4;
					}
					else if([session.location isEqualToString:@"Meridian D & E"]) {
						index = 5;
					}
					if(index == -1) {
						NSLog(@"Session '%@' has an incorrect location '%@'", session.title, session.location);
					}
					else {
						[ordered replaceObjectAtIndex:index withObject:sessionView];
					}

					[sessionView release];
				}
				
				for(index = 0; index < ordered.count; index++) {
					NSObject *item = [ordered objectAtIndex:index];
					if([item isKindOfClass:[NSNull class]]) {
						MLWSessionView *blankView = [[MLWSessionView alloc] initWithFrame:CGRectZero session:nil]; 
						[ordered replaceObjectAtIndex:index withObject:blankView];
						[blankView release];
					}
				}

				int position = 0;
				totalWidth = 0;
				UIPurposeView *breakoutWrapper = [[UIPurposeView alloc] initWithFrame:CGRectMake(0, totalHeight, self.frame.size.width, sessionRowHeight + 1)]; 
				breakoutWrapper.purpose = @"breakoutWrapper";
				breakoutWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				for(MLWSessionView *sessionView in ordered) {
					position++;
					int width = columnWidth + 1;
					if(position == NUMBEROFCOLUMNS) {
						width = self.frame.size.width - totalWidth;
					}
					sessionView.frame = CGRectMake(totalWidth, 0, width, sessionRowHeight + 1); 
					[breakoutWrapper addSubview:sessionView];
					totalWidth += columnWidth;
				}
				[self addSubview:breakoutWrapper];
                [breakoutWrapper release];
				totalHeight += sessionRowHeight;
			}

		}

		CGRect frame = self.frame;
		frame.size.height = totalHeight;
		self.frame = frame;
	}
	else {
		for(UIView *box in self.subviews) {
			CGRect frame = box.frame;
			if([box isKindOfClass:[MLWSessionView class]]) {
				MLWSessionView *sessionView = (MLWSessionView *)box;
				if(sessionView.session.plenary) {
					frame.size.width = self.frame.size.width - columnWidth;
					frame.origin.x = columnWidth;
				}
			}
			if([box isKindOfClass:[UIPurposeView class]]) {
				UIPurposeView *purposeView = (UIPurposeView *)box;
				if([purposeView.purpose isEqualToString:@"time"]) {
					frame.size.width = columnWidth + 1;
				}
				else if([purposeView.purpose isEqualToString:@"breakoutLabel"]) {
					frame.size.width = self.frame.size.width - columnWidth;
					frame.origin.x = columnWidth;
				}
				else if([purposeView.purpose isEqualToString:@"dayOfWeekHeader"]) {
					frame.size.width = self.frame.size.width + 1;
				}
				else if([purposeView.purpose isEqualToString:@"breakoutWrapper"]) {
					frame.size.width = self.frame.size.width;
					NSArray *sessionViews = [purposeView.subviews sortedArrayUsingComparator:^(MLWSessionView *sessionView1, MLWSessionView *sessionView2) {
						if(sessionView1.frame.origin.x < sessionView2.frame.origin.x) {
							return NSOrderedAscending;
						}
						return NSOrderedDescending;
					}];

					int position = 0;
					int totalWidth = 0;
					for(MLWSessionView *sessionView in sessionViews) {
						position++;
						CGRect sessionFrame = sessionView.frame;
						if(position == NUMBEROFCOLUMNS) {
							sessionFrame.size.width = self.frame.size.width - totalWidth;
						}
						else {
							sessionFrame.size.width = columnWidth + 1;
						}
						sessionFrame.origin.x = totalWidth;
						sessionView.frame = sessionFrame;
						totalWidth += columnWidth;
					}
				}
			}
			box.frame = frame;
		}
	}

	removeChildren = NO;
	[self updateUserSchedule];
	[self scrollToNextSession];
}

- (UIView *)dayOfWeekHeader:(NSString *)dayOfWeek withFrame:(CGRect) frame {
	UIPurposeView *labelView = [[[UIPurposeView alloc] initWithFrame:frame] autorelease]; 
	labelView.purpose = @"dayOfWeekHeader";
	labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	labelView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
	labelView.layer.borderWidth = 1;

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(labelView.bounds, 5, 5)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:14];
	label.text = dayOfWeek;
	label.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
	[labelView addSubview:label];
	[label release];

	return labelView;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	self.delegate = nil;
	self.sessions = nil;

	[super dealloc];
}

@end
