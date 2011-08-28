//
//  RemoteScore.h
//  MaaSiveChat
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MaaSive/MaaSive.h>

@class Score;

@interface RemoteScore : MaaSModel

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * name;

-(id)initRemoteScoreWithScore:(Score*)score;

@end