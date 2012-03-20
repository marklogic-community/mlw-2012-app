//
//  MLWTweet.m
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWTweet.h"
#import <ImageIO/ImageIO.h>

@interface MLWTweet ()
- (NSDate *)stringToDate:(NSString *) dateString;
@property (nonatomic, retain) UIImage *cachedImage;
@end

@implementation MLWTweet

@synthesize username = _username;
@synthesize content = _content;
@synthesize date = _date;
@synthesize profileImageURL = _profileImageURL;
@synthesize cachedImage;

- (id)initWithData:(NSDictionary *) jsonData {
	self = [super init];
	if(self) {
		_username = [[jsonData objectForKey:@"from_user"] retain];
		_content = [[jsonData objectForKey:@"text"] retain];
		_date = [[self stringToDate:[jsonData objectForKey:@"created_at"]] retain];
		_profileImageURL = [[jsonData objectForKey:@"profile_image_url"] retain];

		if([_profileImageURL isKindOfClass:[NSNull class]] || _profileImageURL.length == 0) {
			[_profileImageURL release];
			_profileImageURL = nil;
		}
	}
	return self;
}

- (NSDate *)stringToDate:(NSString *) dateString {
	// Mon, 19 Mar 2012 20:38:10 +0000
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
	return [dateFormat dateFromString:dateString];
}

- (UIImage *)profileImage {
	if(_profileImageURL == nil) {
		return nil;
	}

	if(self.cachedImage != nil) {
		return self.cachedImage;
	}

	NSURL *url = [NSURL URLWithString:_profileImageURL];
	CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
	CGImageRef image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
	self.cachedImage = [UIImage imageWithCGImage:image];
	CFRelease(src);
	CGImageRelease(image);
	return self.cachedImage;
}

- (NSString *)dateString {
	int number;
	NSString *units;

	NSInteger interval = abs((NSInteger)[self.date timeIntervalSinceDate:[NSDate date]]);
	if(interval >= 86400) {
		number = interval / 86400;
		units = @"day";
	}
	else {
		if(interval >= 3600) {
			number = interval / 3600;
			units = @"hour";
		}
		else if(interval >= 60) {
			number = interval / 60;
			units = @"minute";
		}
		else {
			number = interval;
			units = @"seconds";
		}
	}

	if(number != 1) {
		units = [NSString stringWithFormat:@"%@s", units];
	}
	return [NSString stringWithFormat:@"%i %@ ago", number, units];
}

- (void) dealloc {
	[_username release];
	[_content release];
	[_date release];
	[_profileImageURL release];
	self.cachedImage = nil;

	[super dealloc];
}

@end
