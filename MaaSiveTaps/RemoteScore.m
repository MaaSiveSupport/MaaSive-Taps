//
//  RemoteScore.m
//  MaaSiveChat
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "RemoteScore.h"
#import "Score.h"

@implementation RemoteScore

@synthesize score = score_;
@synthesize name = name_; 

-(id)initRemoteScoreWithScore:(Score*)score {
	
	self = [super init];
	
	if(self) {
		
		self.score = score.score;
		self.name = score.name;
	}
	
	return self;
}

-(void)dealloc {

	[score_ release];
	[name_ release];
	[super dealloc];
}

@end
