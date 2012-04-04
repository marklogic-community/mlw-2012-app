//
//  MLWSessionView.h
//  MarkLogic World
//
//  Created by Ryan Grimm on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MLWSession.h"

@class MLWSessionView;

@protocol MLWSessionViewDelegate <NSObject>
@optional
- (void)sessionViewWasSelected:(MLWSessionView *) view;
@end

@interface MLWSessionView : UIView {
	BOOL isHighlighed;
}

- (id)initWithFrame:(CGRect)frame session:(MLWSession *) session;

@property (nonatomic, assign) NSObject<MLWSessionViewDelegate> *delegate;
@property (readonly) MLWSession *session;

- (BOOL)highlighed;
- (void)setHighlighted:(BOOL) highlighted;

@end
