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
#import "MLWSessionView.h"
#import "UIPurposeView.h"

@implementation MLWScheduleGridView

@synthesize sessions = _sessions;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.sessions = [NSArray array];
		self.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
		self.layer.borderWidth = 0.5f;
    }
    return self;
}

- (void)setSessions:(NSArray *) sessions {
	[_sessions release];
	_sessions = [sessions retain];
	removeChildren = YES;
}

- (void)layoutSubviews {
	int columnWidth = self.bounds.size.width / NUMBEROFCOLUMNS;
	int rowHeight = 40;
	int sessionRowHeight = 150;
	if(removeChildren == YES) {
		for(UIView *view in self.subviews) {
			[view removeFromSuperview];
		}

		float totalHeight = 0.5;
		for(NSArray *blockSessions in self.sessions) {
			int totalWidth = 0;

			UIPurposeView *timeView = [[UIPurposeView alloc] initWithFrame:CGRectMake(totalWidth, totalHeight, columnWidth, rowHeight)]; 
			timeView.purpose = @"time";
			timeView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
			timeView.layer.borderWidth = 0.5f;

			UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectInset(timeView.bounds, 5, 5)];
			timeLabel.font = [UIFont boldSystemFontOfSize:11];
			timeLabel.text = ((MLWSession *)[blockSessions objectAtIndex:0]).formattedTime;
			[timeView addSubview:timeLabel];
			[timeLabel release];

			[self addSubview:timeView];

			totalWidth += columnWidth;

			if(blockSessions.count == 1) {
				MLWSession *session = [blockSessions objectAtIndex:0];
				MLWSessionView *sessionView = [[MLWSessionView alloc] initWithFrame:CGRectMake(totalWidth, totalHeight, self.frame.size.width - totalWidth, rowHeight) session:session]; 
				[self addSubview:sessionView];
				totalHeight += rowHeight;
				[sessionView release];
			}
			else {
				UIPurposeView *labelView = [[UIPurposeView alloc] initWithFrame:CGRectMake(totalWidth, totalHeight, self.frame.size.width - totalWidth, rowHeight)]; 
				labelView.purpose = @"breakoutLabel";
				labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				labelView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
				labelView.layer.borderWidth = 0.5f;

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

				int position = 0;
				totalWidth = 0;
				UIPurposeView *breakoutWrapper = [[UIPurposeView alloc] initWithFrame:CGRectMake(0, totalHeight, self.frame.size.width, sessionRowHeight)]; 
				breakoutWrapper.purpose = @"breakoutWrapper";
				breakoutWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				for(MLWSession *session in blockSessions) {
					MLWSessionView *sessionView = [[MLWSessionView alloc] initWithFrame:CGRectMake(totalWidth, 0, columnWidth, sessionRowHeight) session:session]; 
					[breakoutWrapper addSubview:sessionView];
					totalWidth += columnWidth;
					[sessionView release];
					position++;
				}
				for(int i = position; i < NUMBEROFCOLUMNS; i++) {
					MLWSessionView *blankView = [[MLWSessionView alloc] initWithFrame:CGRectMake(totalWidth, 0, columnWidth, sessionRowHeight) session:nil]; 
					[breakoutWrapper addSubview:blankView];
					totalWidth += columnWidth;
					[blankView release];
					position++;
				}
				[self addSubview:breakoutWrapper];
				totalHeight += sessionRowHeight;
			}

		}

		CGRect frame = self.frame;
		frame.size.height = totalHeight + 0.5;
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
					frame.size.width = columnWidth;
				}
				else if([purposeView.purpose isEqualToString:@"breakoutLabel"]) {
					frame.size.width = self.frame.size.width - columnWidth;
					frame.origin.x = columnWidth;
				}
				else if([purposeView.purpose isEqualToString:@"breakoutWrapper"]) {
					frame.size.width = self.frame.size.width;
					NSArray *sessionViews = [purposeView.subviews sortedArrayUsingComparator:^(MLWSessionView *sessionView1, MLWSessionView *sessionView2) {
						if(sessionView1.frame.origin.x < sessionView2.frame.origin.x) {
							return NSOrderedAscending;
						}
						return NSOrderedDescending;
					}];

					int totalWidth = 0;
					for(MLWSessionView *sessionView in sessionViews) {
						CGRect sessionFrame = sessionView.frame;
						sessionFrame.size.width = columnWidth;
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
}

- (void)dealloc {
	self.sessions = nil;
	[super dealloc];
}

@end
