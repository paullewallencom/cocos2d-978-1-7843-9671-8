//
//  GKHelper.m
//  MathGame
//
//  Created by Alex Ogorek on 1/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GKHelper.h"

@interface GKHelper ()
<GKGameCenterControllerDelegate>
{
	BOOL gameCenterFeaturesEnabled;
}
@end

@implementation GKHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper
{
	static GKHelper *sharedGameKitHelper;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedGameKitHelper =
		[[GKHelper alloc] init];
	});
	return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
 
	__weak GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
 
	localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
	{
		[self setLastError:error];
		
		if ([CCDirector sharedDirector].isPaused)
			[[CCDirector sharedDirector] resume];
		
		if (localPlayer.authenticated)
		{
			gameCenterFeaturesEnabled = YES;
		}
		else if(viewController)
		{
			[[CCDirector sharedDirector] pause];
			[self presentViewController:viewController];
		}
		else
		{
			gameCenterFeaturesEnabled = NO;
		}
	};
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
	if (error) {
		NSLog(@"GameKitHelper ERROR: %@", [[error userInfo] description]);
	}
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController
{
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc
{
	UIViewController* rootVC = [self getRootViewController];
	[rootVC presentViewController:vc animated:YES completion:nil];
}

-(void)dismissViewController:(UIViewController*)vc
{
	UIViewController *rootVC = [self getRootViewController];
	[rootVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Leaderboards and Achievements

- (void) presentLeaderboards
{
	GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
	gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
	gameCenterController.gameCenterDelegate = self;
	[self presentViewController:gameCenterController];
}

-(void)presentAchievements
{
	GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
	gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
	gameCenterController.gameCenterDelegate = self;
	[self presentViewController:gameCenterController];
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController*) gameCenterViewController
{
	[self dismissViewController:gameCenterViewController];
}

#pragma mark - Score stuff

-(void) submitScore:(int64_t)highscore
{
	
	if (!gameCenterFeaturesEnabled)
	{
		CCLOG(@"Player not authenticated");
		return;
	}
 
	if ([GKLocalPlayer localPlayer].isAuthenticated)
	{
		GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"lbTotalScore"];
		score.value = highscore;
		[GKScore reportScores:@[score] withCompletionHandler:^(NSError *error)
		{
			if (error)
				NSLog(@"error: %@", error);
		}];
	}
}
@end