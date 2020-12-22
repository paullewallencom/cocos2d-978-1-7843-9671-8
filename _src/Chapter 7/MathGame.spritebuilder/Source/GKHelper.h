//
//  GKHelper.h
//  MathGame
//
//  Created by Alex Ogorek on 1/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

//   Include the GameKit framework
#import <GameKit/GameKit.h>

//   Protocol to notify external
//   objects when Game Center events occur or
//   when Game Center async tasks are completed
@protocol GKHelperProtocol<NSObject>
-(void) onScoresSubmitted:(BOOL)success;
@end


@interface GKHelper : NSObject

@property (nonatomic, assign)
id<GKHelperProtocol> delegate;

+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;

// Leaderboards
-(void)presentLeaderboards;

// Achievements
-(void)presentAchievements;

// Scores
-(void) submitScore:(int64_t)highscore;
@end