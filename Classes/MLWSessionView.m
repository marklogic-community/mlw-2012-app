//
//  MLWSessionView.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSessionView.h"
#import <QuartzCore/QuartzCore.h>

@interface MLWSessionView ()
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *trackLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UILabel *combinedLabel;
@end

@implementation MLWSessionView

@synthesize delegate;
@synthesize session = _session;
@synthesize titleLabel;
@synthesize trackLabel;
@synthesize locationLabel;
@synthesize combinedLabel;

- (id)initWithFrame:(CGRect)frame session:(MLWSession *) session {
    self = [super initWithFrame:frame];
    if(self) {
		_session = [session retain];

		self.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
		self.layer.borderWidth = 1;

		if(session == nil) {
			self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank"]];
			return self;
		}

		self.titleLabel = [[[UILabel alloc] init] autorelease];
		titleLabel.text = session.title;
		titleLabel.font = [UIFont boldSystemFontOfSize:11];
		if(session.selectable) {
			titleLabel.textColor = [UIColor colorWithRed:(236.0f/255.0f) green:(125.0f/255.0f) blue:(30.0f/255.0f) alpha:1.0f];
		}
		else {
			titleLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
		}

		if(session.plenary == NO) {
			titleLabel.numberOfLines = 0;

			self.trackLabel = [[[UILabel alloc] init] autorelease];
			trackLabel.text = session.track;
			trackLabel.font = [UIFont systemFontOfSize:10];
			trackLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
			[self addSubview:trackLabel];

			self.locationLabel = [[[UILabel alloc] init] autorelease];
			locationLabel.text = session.location;
			locationLabel.font = [UIFont systemFontOfSize:10];
			locationLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
			[self addSubview:locationLabel];
		}

		[self addSubview:titleLabel];
    }
    return self;
}

- (BOOL)disabled {
	return self.titleLabel.alpha < 1.0;
}

- (void)setDisabled:(BOOL) disabled {
	if(disabled) {
		self.titleLabel.alpha = 0.25;
		self.trackLabel.alpha = 0.25;
		self.locationLabel.alpha = 0.25;
		self.combinedLabel.alpha = 0.25;
	}
	else {
		self.titleLabel.alpha = 1.0;
		self.trackLabel.alpha = 1.0;
		self.locationLabel.alpha = 1.0;
		self.combinedLabel.alpha = 1.0;
	}
}

- (void)layoutSubviews {
	if(_session.plenary) {
		titleLabel.frame = CGRectInset(self.bounds, 5, 5);
	}
	else {
		if(self.frame.size.height < 50) {
			CGRect maxTitleRect;
			CGRect metaRect;

			CGRectDivide(CGRectInset(self.bounds, 5, 5), &metaRect, &maxTitleRect, 30, CGRectMaxYEdge);
			CGSize requiredSize = [_session.title sizeWithFont:titleLabel.font constrainedToSize:maxTitleRect.size];
			titleLabel.frame = CGRectMake(maxTitleRect.origin.x, maxTitleRect.origin.y, requiredSize.width, requiredSize.height);

			if(combinedLabel == nil) {
				self.combinedLabel = [[[UILabel alloc] init] autorelease];
				combinedLabel.text = [NSString stringWithFormat:@"%@ - %@", _session.track, _session.location];
				combinedLabel.font = [UIFont systemFontOfSize:10];
				combinedLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
				[self addSubview:combinedLabel];
			}

			combinedLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, titleLabel.frame.size.width, 15);
		}
		else {
			CGRect maxTitleRect;
			CGRect metaRect;

			CGRectDivide(CGRectInset(self.bounds, 5, 5), &metaRect, &maxTitleRect, 30, CGRectMaxYEdge);
			CGSize requiredSize = [_session.title sizeWithFont:titleLabel.font constrainedToSize:maxTitleRect.size];
			titleLabel.frame = CGRectMake(maxTitleRect.origin.x, maxTitleRect.origin.y, requiredSize.width, requiredSize.height);

			trackLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, titleLabel.frame.size.width, 15);
			locationLabel.frame = CGRectMake(trackLabel.frame.origin.x, trackLabel.frame.origin.y + trackLabel.frame.size.height, titleLabel.frame.size.width, 15);
			[self.combinedLabel removeFromSuperview];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(touches.count > 1) {
		[super touchesEnded:touches withEvent:event];
		return;
	}   

	if([delegate respondsToSelector:@selector(sessionViewWasSelected:)]) {
		[delegate performSelectorOnMainThread:@selector(sessionViewWasSelected:) withObject:self waitUntilDone:NO];
	}   
}

- (void) dealloc {
	self.delegate = nil;
	self.titleLabel = nil;
	self.trackLabel = nil;
	self.locationLabel = nil;
	self.combinedLabel = nil;
	[_session release];

	[super dealloc];
}

@end
