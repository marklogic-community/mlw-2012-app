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

@implementation MLWScheduleGridView

@synthesize sessions = _sessions;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.sessions = [NSArray array];
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

		int totalHeight = 0;
		for(NSArray *blockSessions in self.sessions) {
			int totalWidth = 0;

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

				int position = 0;
				totalWidth = 0;
				UIPurposeView *breakoutWrapper = [[UIPurposeView alloc] initWithFrame:CGRectMake(0, totalHeight, self.frame.size.width, sessionRowHeight + 1)]; 
				breakoutWrapper.purpose = @"breakoutWrapper";
				breakoutWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				for(MLWSession *session in blockSessions) {
					position++;
					int width = columnWidth + 1;
					if(position == NUMBEROFCOLUMNS) {
						width = self.frame.size.width - totalWidth;
					}
					MLWSessionView *sessionView = [[MLWSessionView alloc] initWithFrame:CGRectMake(totalWidth, 0, width, sessionRowHeight + 1) session:session]; 
					sessionView.delegate = delegate;
					[breakoutWrapper addSubview:sessionView];
					totalWidth += columnWidth;
					[sessionView release];
				}
				for(int i = position; i < NUMBEROFCOLUMNS; i++) {
					position++;
					int width = columnWidth + 1;
					if(position == NUMBEROFCOLUMNS) {
						width = self.frame.size.width - totalWidth;
					}
					MLWSessionView *blankView = [[MLWSessionView alloc] initWithFrame:CGRectMake(totalWidth, 0, width, sessionRowHeight + 1) session:nil]; 
					[breakoutWrapper addSubview:blankView];
					totalWidth += columnWidth;
					[blankView release];
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
}

- (void)dealloc {
	self.delegate = nil;
	self.sessions = nil;

	[super dealloc];
}

@end
