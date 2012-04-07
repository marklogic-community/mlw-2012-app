/*
    MLWTweetView.m
	MarkLogic World
	Created by Ryan Grimm on 3/19/12.

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

#import "MLWTweetView.h"

@interface MLWTweetView ()
@property (nonatomic, retain) MLWTweet *tweet;
@property (nonatomic, retain) UIImageView *profileImage;
@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@end

@implementation MLWTweetView

@synthesize tweet = _tweet;
@synthesize profileImage = _profileImage;
@synthesize usernameLabel = _usernameLabel;
@synthesize contentLabel = _contentLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		// Profile image view
		self.profileImage = [[[UIImageView alloc] init] autorelease];
		[self addSubview:self.profileImage];

		self.usernameLabel = [[[UILabel alloc] init] autorelease];
		self.usernameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.usernameLabel.adjustsFontSizeToFitWidth = YES;
		self.usernameLabel.minimumFontSize = 10;
		self.usernameLabel.font = [UIFont boldSystemFontOfSize:13];
		self.usernameLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.usernameLabel];

		self.contentLabel = [[[UILabel alloc] init] autorelease];
		self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.contentLabel.font = [UIFont systemFontOfSize:13];
		self.contentLabel.minimumFontSize = 10;
		self.contentLabel.numberOfLines = 0;
		self.contentLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.contentLabel];

		self.dateLabel = [[[UILabel alloc] init] autorelease];
		self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.dateLabel.font = [UIFont italicSystemFontOfSize:13];
		self.dateLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
	CGRect rightFrame;
	if(self.tweet.profileImage != nil) {
		CGRect imageFrame;
		CGRectDivide(self.bounds, &imageFrame, &rightFrame, 75, CGRectMinXEdge);
		imageFrame = CGRectInset(imageFrame, 7.5, 7.5);
		imageFrame.size.height = imageFrame.size.width;
		self.profileImage.frame = imageFrame;
		self.profileImage.image = self.tweet.profileImage;
	}
	else {
		rightFrame = CGRectInset(self.bounds, 5, 5);
	}

	int totalHeight = 5;
	self.usernameLabel.frame = CGRectMake(rightFrame.origin.x, totalHeight, rightFrame.size.width - 5, 16);
	self.usernameLabel.text = self.tweet.username;
	totalHeight += self.usernameLabel.frame.size.height;

	self.contentLabel.frame = CGRectMake(rightFrame.origin.x, totalHeight, rightFrame.size.width - 5, [self.tweet.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(rightFrame.size.width - 5, 63)].height);
	self.contentLabel.text = self.tweet.content;
	totalHeight += self.contentLabel.frame.size.height;

	self.dateLabel.frame = CGRectMake(rightFrame.origin.x, totalHeight, rightFrame.size.width - 5, 16);
	self.dateLabel.text = self.tweet.dateString;
}


- (void)updateTweet:(MLWTweet *)tweet {
	self.tweet = tweet;
	[self setNeedsLayout];
}

- (void)dealloc {
	self.tweet = nil;
	self.profileImage = nil;
	self.usernameLabel = nil;
	self.contentLabel = nil;
	self.dateLabel = nil;

	[super dealloc];
}

@end
