//
//  MLWSponsorView.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSponsorView.h"

@interface MLWSponsorView ()
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *websiteLabel;
@end


@implementation MLWSponsorView

@synthesize sponsor = _sponsor;
@synthesize nameLabel;
@synthesize contentLabel;
@synthesize websiteLabel;

- (id)initWithSponsor:(MLWSponsor *)sponsor {
    self = [super initWithFrame:CGRectZero];
    if (self) {
		nameLabelHeight = 20;
		websiteLabelHeight = 16;

		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.sponsor = sponsor;

		[self addSubview:sponsor.logo];

		self.nameLabel = [[[UILabel alloc] init] autorelease];
		self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.nameLabel.adjustsFontSizeToFitWidth = YES;
		self.nameLabel.minimumFontSize = 10;
		self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
		self.nameLabel.backgroundColor = [UIColor clearColor];
		self.nameLabel.text = sponsor.name;
		[self addSubview:self.nameLabel];

		self.contentLabel = [[[UILabel alloc] init] autorelease];
		self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.contentLabel.font = [UIFont systemFontOfSize:13];
		self.contentLabel.minimumFontSize = 10;
		self.contentLabel.numberOfLines = 0;
		self.contentLabel.backgroundColor = [UIColor clearColor];
		self.contentLabel.text = sponsor.description;
		[self addSubview:self.contentLabel];

		self.websiteLabel = [[[UILabel alloc] init] autorelease];
		self.websiteLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.websiteLabel.font = [UIFont italicSystemFontOfSize:13];
		self.websiteLabel.backgroundColor = [UIColor clearColor];
		self.websiteLabel.text = sponsor.website;
		[self addSubview:self.websiteLabel];
    }
    return self;
}

- (float)calculatedHeightWithWidth:(CGFloat) width {
	float totalHeight = 5;
	totalHeight += self.sponsor.logo.frame.size.height + 5;
	totalHeight += nameLabelHeight + 5;
	totalHeight += [self.sponsor.description sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(width - 10, 1000)].height + 5;
	totalHeight += websiteLabelHeight + 5;
	return totalHeight;
}

- (void)layoutSubviews {
	float totalHeight = 5;

	CGRect sponsorFrame = self.sponsor.logo.frame;
	sponsorFrame.origin.y = totalHeight;
	sponsorFrame.origin.x = (self.frame.size.width - sponsorFrame.size.width) / 2.0f;
	self.sponsor.logo.frame = sponsorFrame;
	totalHeight += sponsorFrame.size.height + 5;

	self.nameLabel.frame = CGRectMake(5, totalHeight, self.frame.size.width - 10, nameLabelHeight);
	totalHeight += self.nameLabel.frame.size.height + 5;

	self.contentLabel.frame = CGRectMake(5, totalHeight, self.frame.size.width - 10, [self.sponsor.description sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(self.frame.size.width - 10, 1000)].height);
	totalHeight += self.contentLabel.frame.size.height + 5;

	self.websiteLabel.frame = CGRectMake(5, totalHeight, self.frame.size.width - 10, websiteLabelHeight);
}

- (void)dealloc {
	self.sponsor = nil;
	self.nameLabel = nil;
	self.contentLabel = nil;
	self.websiteLabel = nil;
	[super dealloc];
}

@end
